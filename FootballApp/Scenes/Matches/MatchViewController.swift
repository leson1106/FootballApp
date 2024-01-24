//
//  MatchViewController.swift
//  FootBallApp
//
//  Created by Son Le on 17/01/2024.
//

import UIKit
import SnapKit
import Combine
import Domain

fileprivate enum CollectionSection {
    case `default`
}

class MatchViewController: UIViewController, LoadingIndicatorPresentable {

    var loadingView: UIActivityIndicatorView?

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = MatchCell.cellSize
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 16

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(type: MatchCell.self)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        return collectionView
    }()

    private typealias MatchDataSource = UICollectionViewDiffableDataSource<CollectionSection, MatchCellModel>
    private lazy var dataSource: MatchDataSource = {
        MatchDataSource(collectionView: collectionView) { [weak self] collectionView, indexPath, model in
            guard let self, let cell = collectionView.dequeueCell(type: MatchCell.self, at: indexPath) else { return nil }
            cell.bind(model: model)
            return cell
        }
    }()

    private var subcriptions = Set<AnyCancellable>()
    private let viewModel: MatchViewModel

    private let tapCellSubject = PassthroughSubject<IndexPath, Never>()
    private var tapCellPublisher: AnyPublisher<IndexPath, Never> {
        tapCellSubject.eraseToAnyPublisher()
    }

    private let toggleModeButton: UIButton = {
        let button = UIButton()
        button.setTitle("Filter", for: .normal)
        button.setTitleColor(.orange, for: .normal)
        return button
    }()

    init(viewModel: MatchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        navigationItem.title = "Matches"
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: toggleModeButton)

        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.trailing.leading.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }

        showActivityIndicator()

        bindViewModel()
    }
}

private extension MatchViewController {
    func bindViewModel() {
        let loadTrigger: PassthroughSubject<Void, Never> = .init()
        let openFilterTrigger: PassthroughSubject<Void, Never> = .init()

        defer {
            loadTrigger.send(())
        }

        let output = viewModel.transform(
            input: .init(loadTrigger: loadTrigger.eraseToAnyPublisher(),
                         openFilterTrigger: openFilterTrigger.eraseToAnyPublisher(),
                         selectPreviousMatchTrigger: tapCellPublisher.eraseToAnyPublisher())
        )

        output.load
            .sink { _ in }
            .store(in: &subcriptions)

        output
            .matches
            .combineLatest(output.logos) { (matches, logos) -> [MatchCellModel] in
                matches.map { MatchCellModel(match: $0,
                                             homeLogoURL: logos[$0.home],
                                             awayLogoURL: logos[$0.away]) }
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] matches in
                guard let self else { return }
                var snapshot = self.dataSource.snapshot()
                snapshot.deleteAllItems()
                snapshot.appendSections([.default])
                snapshot.appendItems(matches, toSection: .default)

                self.hideActivityIndicator()
                self.dataSource.apply(snapshot)
            }
            .store(in: &subcriptions)

        output
            .openFilter
            .sink { _ in }
            .store(in: &subcriptions)

        output.selectedPreviousMatch
            .sink { _ in }
            .store(in: &subcriptions)

        toggleModeButton.tapPublisher
            .sink { _ in
                openFilterTrigger.send(())
            }
            .store(in: &subcriptions)
    }
}

extension MatchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        tapCellSubject.send(indexPath)
    }
}

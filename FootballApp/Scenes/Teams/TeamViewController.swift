//
//  TeamViewController.swift
//  FootBallApp
//
//  Created by Son Le on 17/01/2024.
//

import UIKit
import Combine
import Domain

fileprivate enum CollectionSection {
    case `default`
}

class TeamViewController: UIViewController, LoadingIndicatorPresentable {

    var loadingView: UIActivityIndicatorView?

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let size = UIScreen.main.bounds.width / 3
        layout.itemSize = CGSize(width: size, height: size)
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(type: TeamLogoCell.self)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        return collectionView
    }()

    private typealias MatchDataSource = UICollectionViewDiffableDataSource<CollectionSection, Team>

    private lazy var dataSource: MatchDataSource = {
        MatchDataSource(collectionView: collectionView) { [weak self] collectionView, indexPath, team in
            guard let self, let cell = collectionView.dequeueCell(type: TeamLogoCell.self, at: indexPath) else { return nil }
            cell.bind(logoURL: team.logoURL)
            return cell
        }
    }()

    private var subcriptions = Set<AnyCancellable>()
    private let viewModel: TeamViewModel

    private let tapCellSubject = PassthroughSubject<IndexPath, Never>()
    private var tapCellPublisher: AnyPublisher<IndexPath, Never> {
        tapCellSubject.eraseToAnyPublisher()
    }

    init(viewModel: TeamViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        navigationItem.title = "Teams"

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

private extension TeamViewController {
    func bindViewModel() {
        let loadTrigger: PassthroughSubject<Void, Never> = .init()

        defer {
            loadTrigger.send(())
        }

        let output = viewModel.transform(
            input: .init(loadTrigger: loadTrigger.eraseToAnyPublisher(),
                         selectTeamTrigger: tapCellPublisher)
        )

        output
            .load
            .sink { _ in }
            .store(in: &subcriptions)

        output
            .teams
            .filter { !$0.isEmpty }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] teams in
                guard let self else { return }
                var snapshot = self.dataSource.snapshot()
                snapshot.deleteAllItems()
                snapshot.appendSections([.default])
                snapshot.appendItems(teams, toSection: .default)

                self.hideActivityIndicator()
                self.dataSource.apply(snapshot)
            }
            .store(in: &subcriptions)

        output
            .selectedTeam
            .sink { _ in }
            .store(in: &subcriptions)
    }
}

extension TeamViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        tapCellSubject.send(indexPath)
    }
}

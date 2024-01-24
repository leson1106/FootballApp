//
//  TeamDetailViewController.swift
//  FootBallApp
//
//  Created by Son Le on 21/01/2024.
//

import UIKit
import Combine

fileprivate enum CollectionSection {
    case `default`
}

final class TeamDetailViewController: UIViewController, LoadingIndicatorPresentable {

    var loadingView: UIActivityIndicatorView?

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = MatchCell.cellSize
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 16

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(type: MatchCell.self)
        collectionView.showsHorizontalScrollIndicator = false
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

    private let viewModel: TeamDetailViewModel
    private var subcriptions = Set<AnyCancellable>()

    init(viewModel: TeamDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private let logoImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        return image
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        view.addSubview(logoImage)
        logoImage.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.width.height.equalTo(80)
        }

        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(logoImage.snp.bottom).offset(16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }

        showActivityIndicator()
        loadingView?.snp.makeConstraints {
            $0.top.equalTo(logoImage.snp.bottom).offset(16)
        }

        bindViewModel()
    }
}

private extension TeamDetailViewController {
    func bindViewModel() {
        let loadTrigger: PassthroughSubject<Void, Never> = .init()

        defer {
            loadTrigger.send(())
        }

        let output = viewModel.transform(input: .init(loadTrigger: loadTrigger.eraseToAnyPublisher()))

        output
            .team
            .receive(on: DispatchQueue.main)
            .sink { [weak self] team in
                guard let self = self else { return }
                self.navigationItem.title = team.name
                self.logoImage.loadImage(url: URL(string: team.logoURL))
            }
            .store(in: &subcriptions)

        output
            .matches
            .receive(on: DispatchQueue.main)
            .sink { [weak self] matches in
                guard let self else { return }
                let models = matches.map { MatchCellModel(match: $0) }

                var snapshot = self.dataSource.snapshot()
                snapshot.deleteAllItems()
                snapshot.appendSections([.default])
                snapshot.appendItems(models, toSection: .default)

                self.hideActivityIndicator()
                self.dataSource.apply(snapshot)
            }
            .store(in: &subcriptions)
    }
}

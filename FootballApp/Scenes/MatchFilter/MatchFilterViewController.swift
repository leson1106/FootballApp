//
//  MatchFilterViewController.swift
//  FootBallApp
//
//  Created by Son Le on 22/01/2024.
//

import UIKit
import Combine
import Domain

fileprivate enum CollectionSection {
    case `default`
}

fileprivate class TeamFilterCellModel: Hashable {
    let team: Team
    var isSelected: Bool = false

    init(team: Team, isSelected: Bool = false) {
        self.team = team
        self.isSelected = isSelected
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(team.id)
    }

    static func ==(lhs: TeamFilterCellModel, rhs: TeamFilterCellModel) -> Bool {
        lhs.team.id == rhs.team.id
    }
}

class MatchFilterViewController: UIViewController {

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width - 16, height: 32)
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 8

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(type: MatchFilterTeamCell.self)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        return collectionView
    }()

    private typealias MatchDataSource = UICollectionViewDiffableDataSource<CollectionSection, TeamFilterCellModel>
    private lazy var dataSource: MatchDataSource = {
        MatchDataSource(collectionView: collectionView) { [weak self] collectionView, indexPath, cellData in
            guard let self, let cell = collectionView.dequeueCell(type: MatchFilterTeamCell.self, at: indexPath) else { return nil }
            cell.bind(teamName: cellData.team.name, isSelected: cellData.isSelected)
            return cell
        }
    }()

    private let types: [MatchType]
    private let teams: [Team]
    private let filterSubject: CurrentValueSubject<Filter, Never>

    init(types: [MatchType], teams: [Team], filterSubject: CurrentValueSubject<Filter, Never>) {
        self.types = types
        self.teams = teams
        self.filterSubject = filterSubject
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private let matchFilterLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.text = "Match Type:"
        return label
    }()

    private let matchTypeView = MatchFilterTypeView()

    private let teamFilterLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.text = "All teams:"
        return label
    }()

    private lazy var confirmButton: UIButton = {
        let button = UIButton()
        button.setTitle("Apply", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .orange
        button.makeRoundedCorner(radius: 8)
        button.addTarget(self, action: #selector(applyFilter), for: .touchUpInside)
        return button
    }()

    private static let defaultSpacing: CGFloat = 16

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        view.addSubview(matchFilterLabel)
        matchFilterLabel.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview().offset(Self.defaultSpacing)
        }

        view.addSubview(matchTypeView)
        matchTypeView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(Self.defaultSpacing)
            $0.top.equalTo(matchFilterLabel.snp.bottom).offset(Self.defaultSpacing)
        }
        matchTypeView.bind(selectedType: filterSubject.value.type)

        view.addSubview(teamFilterLabel)
        teamFilterLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().offset(Self.defaultSpacing)
            $0.top.equalTo(matchTypeView.snp.bottom).offset(Self.defaultSpacing)
        }

        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(Self.defaultSpacing)
            $0.top.equalTo(teamFilterLabel.snp.bottom).offset(Self.defaultSpacing)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }

        view.addSubview(confirmButton)
        confirmButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.leading.equalToSuperview().offset(Self.defaultSpacing * 2)
            $0.height.equalTo(44)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }

        let selectedTeams = filterSubject.value.teams
        let cellData = teams.map { team -> TeamFilterCellModel in
            if selectedTeams.contains(team) {
                return TeamFilterCellModel(team: team, isSelected: true)
            } else {
                return TeamFilterCellModel(team: team)
            }
        }

        var snapshot = self.dataSource.snapshot()
        snapshot.appendSections([.default])
        snapshot.appendItems(cellData, toSection: .default)
        dataSource.apply(snapshot)
    }

    @objc private func applyFilter() {
        let selectedType = matchTypeView.selectedType

        let selectedTeams = self.dataSource.snapshot()
            .itemIdentifiers(inSection: .default)
            .filter { $0.isSelected }
            .map { $0.team }

        dismiss(animated: true) {
            self.filterSubject.send(.init(type: selectedType, teams: selectedTeams))
        }
    }
}

extension MatchFilterViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let selectedItem = self.dataSource.itemIdentifier(for: indexPath) else { return }
        selectedItem.isSelected.toggle()
        var snapshot = self.dataSource.snapshot()
        snapshot.reloadItems([selectedItem])
        dataSource.apply(snapshot)
    }
}

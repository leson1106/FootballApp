//
//  MatchFilterTeamCell.swift
//  FootBallApp
//
//  Created by Son Le on 22/01/2024.
//

import UIKit

class MatchFilterTeamCell: UICollectionViewCell {

    private lazy var boundTeamName: UIView = {
        let view = UIView()
        view.addSubview(teamName)
        view.backgroundColor = .white
        return view
    }()

    private let teamName: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 15)
        label.textColor = .black
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        contentView.addSubview(boundTeamName)
        boundTeamName.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(32)
        }
        boundTeamName.makeRoundedCorner(radius: 4, borderColor: .black)

        teamName.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(4)
        }
    }

    func bind(teamName: String, isSelected: Bool) {
        self.teamName.text = teamName
        boundTeamName.makeRoundedCorner(radius: 4, borderColor: isSelected ? .orange : .black)
    }
}

//
//  MatchCell.swift
//  FootBallApp
//
//  Created by Son Le on 18/01/2024.
//

import UIKit
import Domain

struct MatchCellModel: Hashable {

    let match: Match
    let homeLogoURL: URL?
    let awayLogoURL: URL?

    init(match: Match, homeLogoURL: String? = nil, awayLogoURL: String? = nil) {
        self.match = match
        if let homeLogoURL {
            self.homeLogoURL = URL(string: homeLogoURL)
        } else {
            self.homeLogoURL = nil
        }
        if let awayLogoURL {
            self.awayLogoURL = URL(string: awayLogoURL)
        } else {
            self.awayLogoURL = nil
        }
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(match)
    }
}

class MatchCell: UICollectionViewCell {
    static var cellSize: CGSize {
        CGSize(width: UIScreen.main.bounds.width - 16,
               height: 80)
    }

    private let container: UIView = {
        let view = UIView()
        view.makeRoundedCorner(radius: 24, borderColor: .gray, borderWidth: 1)
        return view
    }()

    private let matchTitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.font = .systemFont(ofSize: 15, weight: .medium)
        return label
    }()

    private let timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 15, weight: .bold)
        return label
    }()

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = .systemFont(ofSize: 13, weight: .medium)
        return label
    }()

    private let homeLogo: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        return image
    }()

    private let awayLogo: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        return image
    }()

    private var insetPadding: CGFloat {
        32
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        contentView.addSubview(container)
        container.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(8)
            $0.height.equalTo(Self.cellSize.height)
        }

        container.addSubview(matchTitleLabel)
        matchTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(8)
            $0.centerX.equalToSuperview()
            $0.trailing.equalToSuperview().inset(8)
        }

        container.addSubview(timeLabel)
        timeLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }

        container.addSubview(dateLabel)
        dateLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(timeLabel.snp.bottom).offset(4)
        }

        container.addSubview(homeLogo)
        homeLogo.snp.makeConstraints {
            $0.size.equalTo(40)
            $0.leading.equalToSuperview().inset(insetPadding)
            $0.centerY.equalToSuperview().offset(8)
        }

        container.addSubview(awayLogo)
        awayLogo.snp.makeConstraints {
            $0.size.equalTo(40)
            $0.trailing.equalToSuperview().inset(insetPadding)
            $0.centerY.equalToSuperview().offset(8)
        }
    }

    func bind(model: MatchCellModel) {
        matchTitleLabel.text = model.match.description
        timeLabel.text = model.match.timeString
        dateLabel.text = model.match.dateString

        homeLogo.loadImage(url: model.homeLogoURL)
        awayLogo.loadImage(url: model.awayLogoURL)
    }
}

fileprivate extension Match {
    var timeString: String {
        ""
    }

    var dateString: String {
        ""
    }
}

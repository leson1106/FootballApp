//
//  MatchFilterTypeView.swift
//  FootBallApp
//
//  Created by Son Le on 22/01/2024.
//

import UIKit
import SnapKit
import Domain

fileprivate extension MatchType {
    var description: String {
        switch self {
        case .upcoming:
            return "Upcoming"
        case .previous:
            return "Previous"
        }
    }
}

class MatchFilterTypeView: UIView {

    private lazy var upcomingButton = createRoundedButton(with: MatchType.upcoming.description)
    private lazy var previousButton = createRoundedButton(with: MatchType.previous.description)

    private lazy var stackMatchType: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [upcomingButton, previousButton])
        stackView.axis = .horizontal
        stackView.spacing = 8
        return stackView
    }()

    var selectedType: MatchType {
        upcomingButton.isSelected ? .upcoming : .previous
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        addSubview(stackMatchType)
        stackMatchType.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    func bind(selectedType: MatchType) {
        selectedType == .upcoming
        ? toggleSelect(upcomingButton)
        : toggleSelect(previousButton)
    }

    @discardableResult
    private func createRoundedButton(with title: String) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15)
        button.setTitleColor(.black, for: .selected)
        button.setTitleColor(.lightGray, for: .normal)
        button.makeRoundedCorner(radius: 8)
        button.addTarget(self, action: #selector(toggleSelect), for: .touchUpInside)
        return button
    }

    @objc private func toggleSelect(_ sender: UIButton) {
        if sender === upcomingButton {
            upcomingButton.isSelected = true
            previousButton.isSelected = false
        } else {
            upcomingButton.isSelected = false
            previousButton.isSelected = true
        }
    }
}

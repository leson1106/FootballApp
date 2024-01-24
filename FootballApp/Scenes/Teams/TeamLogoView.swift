//
//  TeamLogoView.swift
//  FootBallApp
//
//  Created by Son Le on 20/01/2024.
//

import UIKit

class TeamLogoView: UIView {
    private let logo: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        addSubview(logo)
        logo.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    func bind(logoURL: String) {
        logo.loadImage(url: URL(string: logoURL))
    }
}

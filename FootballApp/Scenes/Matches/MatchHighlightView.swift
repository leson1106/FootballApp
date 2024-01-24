//
//  MatchHighlightView.swift
//  FootBallApp
//
//  Created by Son Le on 22/01/2024.
//

import UIKit
import SnapKit
import AVKit

class MatchHighlightView: UIViewController {

    private let url: URL?

    init(url: URL?) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        guard let url else { return }

        let player = AVPlayer(url: url)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player

        addChild(playerViewController)
        playerViewController.didMove(toParent: self)

        view.addSubview(playerViewController.view)
        playerViewController.view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        player.play()
    }
}

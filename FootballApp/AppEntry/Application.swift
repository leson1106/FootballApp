//
//  Application.swift
//  FootBallApp
//
//  Created by Son Le on 17/01/2024.
//

import UIKit

final class Application {
    static let shared = Application()

    private init() { }

    func initializeUI(in window: UIWindow) {
        let tabbar = TabBarController()
        window.rootViewController = tabbar
        window.makeKeyAndVisible()
    }
}

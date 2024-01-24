//
//  TabBarController.swift
//  FootBallApp
//
//  Created by Son Le on 19/01/2024.
//

import UIKit

class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViewControllers()
    }

    private func setupViewControllers() {
        let matches = createMatchesController()
        matches.tabBarItem = UITabBarItem(title: "Matches",
                                          image: UIImage(systemName: "calendar"),
                                          selectedImage: nil)

        let teams = createTeamsController()
        teams.tabBarItem = UITabBarItem(title: "Teams",
                                        image: UIImage(systemName: "house"),
                                        selectedImage: nil)

        viewControllers = [matches, teams]
    }

    private func createMatchesController() -> UIViewController {
        let navigationController = UINavigationController()
        let viewController = MatchScene.build(navigationController)
        navigationController.viewControllers = [viewController]
        navigationController.navigationBar.prefersLargeTitles = false
        return navigationController
    }

    private func createTeamsController() -> UIViewController {
        let navigationController = UINavigationController()
        let viewController = TeamScene.build(navigationController)
        navigationController.viewControllers = [viewController]
        navigationController.navigationBar.prefersLargeTitles = false
        return navigationController
    }
}

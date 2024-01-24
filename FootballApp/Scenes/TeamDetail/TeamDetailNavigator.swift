//
//  TeamDetailNavigator.swift
//  FootBallApp
//
//  Created by Son Le on 21/01/2024.
//

import UIKit

protocol TeamDetailNavigator {
    func popTeamDetail()
}

final class TeamDetailNavigatorDefault: TeamDetailNavigator {

    private let navigationController: UINavigationController

    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func popTeamDetail() {
        navigationController.popViewController(animated: true)
    }
}

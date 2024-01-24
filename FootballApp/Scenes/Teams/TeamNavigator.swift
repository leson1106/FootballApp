//
//  TeamNavigator.swift
//  FootBallApp
//
//  Created by Son Le on 17/01/2024.
//

import UIKit
import Domain
import MatchUseCase
import MatchRepository
import CoreDataRepository
import AWSService

protocol TeamNavigator {
    func toTeamDetail(_ team: Team)
}

class TeamNavigatorDefault: TeamNavigator {

    private let navigationController: UINavigationController

    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func toTeamDetail(_ team: Team) {
        let matchClient = MatchClient(service: AWSClient(domain: .aws))
        let useCase = MatchUseCaseDefault(matchRepository: matchClient, 
                                          coreDataRepository: CoreDataRepositoryDefault.shared)
        let viewModel = TeamDetailViewModel(team: team,
                                            useCase: useCase,
                                            navigator: TeamDetailNavigatorDefault(navigationController))
        let controller = TeamDetailViewController(viewModel: viewModel)
        navigationController.pushViewController(controller, animated: true)
    }
}

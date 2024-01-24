//
//  TeamDetailScene.swift
//  FootballApp
//
//  Created by Son Le on 24/01/2024.
//

import UIKit
import MatchUseCase
import MatchRepository
import TeamUseCase
import TeamRepository
import AWSService
import CoreDataRepository
import Domain

enum TeamDetailScene {
    static func build(_ team: Team, and navigationController: UINavigationController) -> TeamDetailViewController {
        let client = AWSClient(domain: .aws)
        let useCase = MatchUseCaseDefault(matchRepository: MatchClient(service: client),
                                          coreDataRepository: CoreDataRepositoryDefault.shared)
        let viewModel = TeamDetailViewModel(team: team,
                                            useCase: useCase,
                                            navigator: TeamDetailNavigatorDefault(navigationController))
        let viewController = TeamDetailViewController(viewModel: viewModel)
        return viewController
    }
}

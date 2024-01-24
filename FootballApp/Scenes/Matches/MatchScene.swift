//
//  MatchScene.swift
//  FootBallApp
//
//  Created by Son Le on 24/01/2024.
//

import UIKit
import Domain
import CoreDataRepository
import AWSService
import MatchUseCase
import MatchRepository
import TeamUseCase
import TeamRepository

enum MatchScene {
    static func build(_ navigationController: UINavigationController) -> MatchViewController {
        let coreData = CoreDataRepositoryDefault.shared
        let client = AWSClient(domain: .aws)
        let matchUseCase = MatchUseCaseDefault(matchRepository: MatchClient(service: client),
                                               coreDataRepository: coreData)
        let teamUseCase = TeamUseCaseDefault(teamRepository: TeamClient(service: client),
                                              coreDataRepository: coreData)
        let viewModel = MatchViewModel(filter: .init(type: .upcoming),
                                       matchUseCase: matchUseCase,
                                       teamUseCase: teamUseCase,
                                       navigator: MatchNavigatorDefault(navigationController))
        let viewController = MatchViewController(viewModel: viewModel)
        return viewController
    }
}

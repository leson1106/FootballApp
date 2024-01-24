//
//  TeamsScene.swift
//  FootBallApp
//
//  Created by Son Le on 24/01/2024.
//

import UIKit
import TeamUseCase
import TeamRepository
import AWSService
import CoreDataRepository

enum TeamScene {
    static func build(_ navigationController: UINavigationController) -> TeamViewController {
        let client = AWSClient(domain: .aws)
        let coreData = CoreDataRepositoryDefault.shared
        let useCase = TeamUseCaseDefault(teamRepository: TeamClient(service: client),
                                         coreDataRepository: coreData)
        let viewModel = TeamViewModel(useCase: useCase,
                                       navigator: TeamNavigatorDefault(navigationController))
        let viewController = TeamViewController(viewModel: viewModel)
        return viewController
    }
}

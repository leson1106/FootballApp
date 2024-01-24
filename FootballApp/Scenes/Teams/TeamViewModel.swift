//
//  TeamViewModel.swift
//  FootBallApp
//
//  Created by Son Le on 17/01/2024.
//

import UIKit
import Domain
import Combine
import TeamUseCase

class TeamViewModel: ViewModelType {

    private let useCase: TeamUseCase
    private let navigator: TeamNavigator

    init(useCase: TeamUseCase, navigator: TeamNavigator) {
        self.useCase = useCase
        self.navigator = navigator
    }

    func transform(input: Input) -> Output {
        let teams = useCase.teams

        let load = input.loadTrigger
            .handleEvents(receiveOutput: { _ in
                self.useCase.update()
            })
            .eraseToAnyPublisher()

        let toDetail = input.selectTeamTrigger
            .withLatestFrom(teams) { indexPath, teams in
                teams[indexPath.row]
            }
            .handleEvents(receiveOutput: { team in
                self.navigator.toTeamDetail(team)
            })
            .eraseToAnyPublisher()

        return Output(load: load, teams: teams, selectedTeam: toDetail)
    }
}

extension TeamViewModel {
    struct Input {
        let loadTrigger: AnyPublisher<Void, Never>
        let selectTeamTrigger: AnyPublisher<IndexPath, Never>
    }

    struct Output {
        let load: AnyPublisher<Void, Never>
        let teams: AnyPublisher<[Team], Never>
        let selectedTeam: AnyPublisher<Team, Never>
    }
}

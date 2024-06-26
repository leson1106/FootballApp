//
//  TeamDetailViewModel.swift
//  FootBallApp
//
//  Created by Son Le on 21/01/2024.
//

import Combine
import Domain
import MatchUseCase

final class TeamDetailViewModel: ViewModelType {

    private let team: Team
    private let useCase: MatchUseCase
    private let navigator: TeamDetailNavigator

    init(team: Team, useCase: MatchUseCase, navigator: TeamDetailNavigator) {
        self.team = team
        self.useCase = useCase
        self.navigator = navigator
    }

    func transform(input: Input) -> Output {
        let fetchMatches = useCase.matches

        let team = CurrentValueSubject<Team, Never>(team)
            .eraseToAnyPublisher()

        let result = input.loadTrigger
            .flatMap { fetchMatches }
            .withLatestFrom(team, resultSelector: { matches, team in
                matches.filter { $0.isContain(team: team) }
            })
            .eraseToAnyPublisher()

        return Output(team: team, matches: result)
    }
}

extension TeamDetailViewModel {
    struct Input {
        let loadTrigger: AnyPublisher<Void, Never>
    }

    struct Output {
        let team: AnyPublisher<Team, Never>
        let matches: AnyPublisher<[Match], Never>
    }
}

fileprivate extension Match {
    func isContain(team: Team) -> Bool {
        return self.home == team.name || self.away == team.name
    }
}

//
//  MatchViewModel.swift
//  FootBallApp
//
//  Created by Son Le on 17/01/2024.
//

import UIKit
import Combine
import MatchUseCase
import TeamUseCase
import Domain

final class MatchViewModel: ViewModelType {

    private let filter: Filter
    private let matchUseCase: MatchUseCase
    private let teamUseCase: TeamUseCase
    private let navigator: MatchNavigator

    init(filter: Filter, matchUseCase: MatchUseCase, teamUseCase: TeamUseCase, navigator: MatchNavigator) {
        self.filter = filter
        self.matchUseCase = matchUseCase
        self.teamUseCase = teamUseCase
        self.navigator = navigator
    }

    func transform(input: Input) -> Output {
        let load = input.loadTrigger
            .handleEvents(receiveOutput: { _ in
                self.teamUseCase.update()
                self.matchUseCase.update()
            })
            .eraseToAnyPublisher()

        let applyFilter = CurrentValueSubject<Filter, Never>(self.filter)

        let fetchMatches = matchUseCase.matches
        let fetchTeams = teamUseCase.teams

        let logos = fetchTeams
            .map { teams in
                teams.reduce(into: [String: String]()) { $0[$1.name] = $1.logoURL }
            }
            .eraseToAnyPublisher()

        let matches = applyFilter
            .combineLatest(fetchMatches) { filter, matches in
                let _matches = matches.filter { $0.type == filter.type }
                if filter.teams.isEmpty {
                    return _matches
                } else {
                    return _matches
                        .filter { match in
                            let names = filter.teams.map { $0.name }
                            return names.contains(match.away) || names.contains(match.home)
                        }
                }
            }
            .share()
            .eraseToAnyPublisher()

        let openFilter = input.openFilterTrigger
            .withLatestFrom(fetchTeams) { _, teams in
                teams
            }
            .handleEvents(receiveOutput: { teams in
                self.navigator.toFilter(types: MatchType.allCases, allTeams: teams, apply: applyFilter)
            })
            .eraseToAnyPublisher()

        let selectedPreviousMatch = input.selectPreviousMatchTrigger
            .withLatestFrom(matches) { indexPath, data in
                data[indexPath.row]
            }
            .filter { $0.highlights != nil }
            .handleEvents(receiveOutput: {
                self.navigator.toHighLight(match: $0)
            })
            .eraseToAnyPublisher()

        return Output(load: load,
                      matches: matches,
                      logos: logos,
                      openFilter: openFilter,
                      selectedPreviousMatch: selectedPreviousMatch)
    }
}

extension MatchViewModel {
    struct Input {
        let loadTrigger: AnyPublisher<Void, Never>
        let openFilterTrigger: AnyPublisher<Void, Never>
        let selectPreviousMatchTrigger: AnyPublisher<IndexPath, Never>
    }

    struct Output {
        let load: AnyPublisher<Void, Never>
        let matches: AnyPublisher<[Match], Never>
        let logos: AnyPublisher<[String: String], Never> /*[teamName: stringURL]*/
        let openFilter: AnyPublisher<[Team], Never>
        let selectedPreviousMatch: AnyPublisher<Match, Never>
    }
}

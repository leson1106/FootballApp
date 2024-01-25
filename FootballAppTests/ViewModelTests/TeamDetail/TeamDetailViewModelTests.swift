//
//  TeamDetailViewModelTests.swift
//  FootballAppTests
//
//  Created by Son Le on 25/01/2024.
//

import XCTest
import Combine
@testable import FootballApp

final class TeamDetailViewModelTests: XCTestCase {
    var matchUseCase: MatchUseCaseMock!
    var teamDetailNavigator: TeamDetailNavigatorMock!
    var teamDetailViewModel: TeamDetailViewModel!

    var team = TeamUseCaseMock.createMockTeams()[0]

    var subcriptions = Set<AnyCancellable>()

    override func setUp() {
        super.setUp()
        matchUseCase = MatchUseCaseMock()
        teamDetailNavigator = TeamDetailNavigatorMock()
        teamDetailViewModel = TeamDetailViewModel(team: team,
                                                  useCase: matchUseCase,
                                                  navigator: teamDetailNavigator)
    }

    func test_transform_loadTrigger_andMatches_firstTeamIndex() {
        let trigger = PassthroughSubject<Void, Never>()
        let input = createMockInput(loadTrigger: trigger.eraseToAnyPublisher())

        let matches = MatchUseCaseMock.createMockMatches()
        matchUseCase._matches.value = matches

        let selectedTeam = team

        let output = teamDetailViewModel.transform(input: input)
        output.team
            .sink { _ in }
            .store(in: &subcriptions)

        output.matches
            .sink { matches in
                XCTAssert(matches.count == 2)
                XCTAssertTrue(matches[0].home == selectedTeam.name || matches[0].away == selectedTeam.name)
                XCTAssertTrue(matches[1].home == selectedTeam.name || matches[1].away == selectedTeam.name)
            }
            .store(in: &subcriptions)

        trigger.send(())
    }
}

fileprivate extension TeamDetailViewModelTests {
    func createMockInput(loadTrigger: AnyPublisher<Void, Never>) -> TeamDetailViewModel.Input {
        .init(loadTrigger: loadTrigger)
    }
}

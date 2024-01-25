//
//  TeamViewModelTests.swift
//  FootballAppTests
//
//  Created by Son Le on 25/01/2024.
//

import XCTest
import Combine
import Domain
@testable import FootballApp

final class TeamViewModelTests: XCTestCase {

    var teamUsecase: TeamUseCaseMock!
    var teamNavigator: TeamNavigatorMock!
    var teamViewModel: TeamViewModel!

    var subcriptions = Set<AnyCancellable>()

    override func setUp() {
        super.setUp()
        teamUsecase = TeamUseCaseMock()
        teamNavigator = TeamNavigatorMock()
        teamViewModel = TeamViewModel(useCase: teamUsecase, navigator: teamNavigator)
    }

    func test_transform_loadTrigger_updateEmited() {
        let trigger = PassthroughSubject<Void, Never>()
        let input = createMockInput(loadTrigger: trigger.eraseToAnyPublisher())
        let output = teamViewModel.transform(input: input)

        output.load
            .sink { _ in }
            .store(in: &subcriptions)

        trigger.send(())

        XCTAssert(teamUsecase.update_get_called)
    }

    func test_tranform_selectTeamTrigger_navigateToTeamDetail() {
        let trigger = PassthroughSubject<Void, Never>()
        let select = PassthroughSubject<IndexPath, Never>()
        let input = createMockInput(loadTrigger: trigger.eraseToAnyPublisher(),
                                    selectedTeamTrigger: select.eraseToAnyPublisher())

        let teams = TeamUseCaseMock.createMockTeams()
        teamUsecase._teams.value = teams

        let output = teamViewModel.transform(input: input)
        output.selectedTeam
            .sink { _ in }
            .store(in: &subcriptions)

        trigger.send(())
        select.send(IndexPath(row: 2, section: 0))

        XCTAssert(teamNavigator.toTeamDetail_get_called)
        XCTAssertEqual(teamNavigator.toTeamDetail_with_team?.name, teams[2].name)
    }
}

private extension TeamViewModelTests {
    func createMockInput(loadTrigger: AnyPublisher<Void, Never> = PassthroughSubject<Void, Never>().eraseToAnyPublisher(),
                         selectedTeamTrigger: AnyPublisher<IndexPath, Never> = PassthroughSubject<IndexPath, Never>().eraseToAnyPublisher())
    -> TeamViewModel.Input {
        .init(loadTrigger: loadTrigger,
              selectTeamTrigger: selectedTeamTrigger)
    }
}

//
//  MatchViewModelTests.swift
//  FoodBallAppTests
//
//  Created by Son Le on 23/01/2024.
//

import XCTest
import Combine
import Domain
@testable import FootballApp

final class MatchViewModelTests: XCTestCase {

    var teamUseCase: TeamUseCaseMock!
    var matchUseCase: MatchUseCaseMock!
    var matchNavigator: MatchNavigatorMock!
    var matchViewModel: MatchViewModel!

    var subcriptions = Set<AnyCancellable>()

    override func setUp() {
        super.setUp()
        teamUseCase = TeamUseCaseMock()
        matchUseCase = MatchUseCaseMock()
        matchNavigator = MatchNavigatorMock()
        setupViewModel(filter: .init(type: .upcoming))
    }

    func test_transform_loadTrigger_updateEmited() {
        let trigger = PassthroughSubject<Void, Never>()
        let input = createMockInput(loadTrigger: trigger.eraseToAnyPublisher())
        let output = matchViewModel.transform(input: input)

        output.load
            .sink { _ in }
            .store(in: &subcriptions)

        trigger.send(())

        XCTAssert(matchUseCase.update_get_called)
    }

    func test_transform_openFilterTrigger_toFilterEmited() {
        let trigger = PassthroughSubject<Void, Never>()
        let input = createMockInput(openFilterTrigger: trigger.eraseToAnyPublisher())
        let output = matchViewModel.transform(input: input)

        output.openFilter
            .sink { _ in }
            .store(in: &subcriptions)

        trigger.send(())

        XCTAssert(matchNavigator.toFilter_get_called)
    }

    func test_transform_selectPreviousMatchTrigger_navigateToHighlight() {
        let trigger = PassthroughSubject<Void, Never>()
        let select = PassthroughSubject<IndexPath, Never>()
        let input = createMockInput(loadTrigger: trigger.eraseToAnyPublisher(),
                                    selectPreviousMatchTrigger: select.eraseToAnyPublisher())

        setupViewModel(filter: .init(type: .previous))

        let output = matchViewModel.transform(input: input)

        let matches = MatchUseCaseMock.createMockMatches()
        matchUseCase._matches.value = matches

        output.selectedPreviousMatch
            .sink { _ in }
            .store(in: &subcriptions)

        trigger.send(())
        select.send(IndexPath(row: 1, section: 0))

        XCTAssert(matchNavigator.toHighlight_get_called)
        XCTAssertEqual(matchNavigator.toHighlight_match, matches[matches.count - 1])
    }

    func test_transform_applyFilterTrigger_upcoming_mapMatchesToViewModel() {
        let trigger = PassthroughSubject<Void, Never>()
        let input = createMockInput(loadTrigger: trigger.eraseToAnyPublisher())

        setupViewModel(filter: .init(type: .upcoming))

        let matches = MatchUseCaseMock.createMockMatches()
        matchUseCase._matches.value = matches

        let output = matchViewModel.transform(input: input)
        output.load
            .sink { _ in }
            .store(in: &subcriptions)

        output.matches
            .sink { _matches in
                XCTAssert(_matches.count == 3)
                XCTAssertEqual(_matches[0].home, matches[0].home)
                XCTAssertEqual(_matches[0].away, matches[0].away)
            }
            .store(in: &subcriptions)

        trigger.send(())
    }

    func test_transform_applyFilterTrigger_upcomingAndTeams_mapMatchesToViewModel() {
        let trigger = PassthroughSubject<Void, Never>()
        let input = createMockInput(loadTrigger: trigger.eraseToAnyPublisher())

        let teams = TeamUseCaseMock.createMockTeams()
        setupViewModel(filter: .init(type: .upcoming, teams: [teams.first!]))

        let matches = MatchUseCaseMock.createMockMatches()
        matchUseCase._matches.value = matches

        let output = matchViewModel.transform(input: input)
        output.load
            .sink { _ in }
            .store(in: &subcriptions)

        output.matches
            .sink { _matches in
                XCTAssert(_matches.count == 1)
            }
            .store(in: &subcriptions)

        trigger.send(())
    }

    func test_transform_applyFilterTrigger_upcomingAndTeams_withEmptyResult_mapMatchesToViewModel() {
        let trigger = PassthroughSubject<Void, Never>()
        let input = createMockInput(loadTrigger: trigger.eraseToAnyPublisher())

        let teams = TeamUseCaseMock.createMockTeams()
        setupViewModel(filter: .init(type: .upcoming, teams: [teams.last!]))

        let matches = MatchUseCaseMock.createMockMatches()
        matchUseCase._matches.value = matches

        let output = matchViewModel.transform(input: input)
        output.load
            .sink { _ in }
            .store(in: &subcriptions)

        output.matches
            .sink { _matches in
                XCTAssert(_matches.isEmpty)
            }
            .store(in: &subcriptions)

        trigger.send(())
    }
}

private extension MatchViewModelTests {
    func setupViewModel(filter: Filter) {
        matchViewModel = .init(filter: filter,
                               matchUseCase: matchUseCase,
                               teamUseCase: teamUseCase,
                               navigator: matchNavigator)
    }

    func createMockInput(loadTrigger: AnyPublisher<Void, Never> = PassthroughSubject<Void, Never>().eraseToAnyPublisher(),
                         openFilterTrigger: AnyPublisher<Void, Never> = PassthroughSubject<Void, Never>().eraseToAnyPublisher(),
                         selectPreviousMatchTrigger: AnyPublisher<IndexPath, Never> = PassthroughSubject<IndexPath, Never>().eraseToAnyPublisher())
    -> MatchViewModel.Input {
        .init(loadTrigger: loadTrigger,
              openFilterTrigger: openFilterTrigger,
              selectPreviousMatchTrigger: selectPreviousMatchTrigger)
    }
}

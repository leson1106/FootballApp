//
//  MatchViewModelTests.swift
//  FoodBallAppTests
//
//  Created by Son Le on 23/01/2024.
//

import XCTest
import Combine
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

        matchViewModel = .init(filter: .init(type: .upcoming),
                               matchUseCase: matchUseCase,
                               teamUseCase: teamUseCase,
                               navigator: matchNavigator)
    }

    private func createMockInput(loadTrigger: AnyPublisher<Void, Never> = PassthroughSubject<Void, Never>().eraseToAnyPublisher(),
                                 openFilterTrigger: AnyPublisher<Void, Never> = PassthroughSubject<Void, Never>().eraseToAnyPublisher(),
                                 selectPreviousMatchTrigger: AnyPublisher<IndexPath, Never> = PassthroughSubject<IndexPath, Never>().eraseToAnyPublisher())
    -> MatchViewModel.Input {
        .init(loadTrigger: loadTrigger,
              openFilterTrigger: openFilterTrigger,
              selectPreviousMatchTrigger: selectPreviousMatchTrigger)
    }

    func test_transform_loadTrigger_updateEmited() {
        let loadTrigger = PassthroughSubject<Void, Never>()
        let input = createMockInput(loadTrigger: loadTrigger.eraseToAnyPublisher())
        let output = matchViewModel.transform(input: input)

        output.load
            .sink { _ in }
            .store(in: &subcriptions)

        loadTrigger.send(())

        XCTAssert(matchUseCase.update_get_called)
    }

    func test_transform_openFilterTrigger() {
        
    }
}

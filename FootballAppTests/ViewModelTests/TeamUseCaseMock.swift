//
//  TeamUseCaseMock.swift
//  FoodBallAppTests
//
//  Created by Son Le on 24/01/2024.
//

import Combine
import TeamUseCase
import Domain
@testable import FootballApp

class TeamUseCaseMock: TeamUseCase {
    var teams: AnyPublisher<[Team], Never> {
        _teams.eraseToAnyPublisher()
    }

    let _teams: CurrentValueSubject<[Team], Never> = .init([])

    var update_get_called = false
    func update() {
        update_get_called = true
    }
}

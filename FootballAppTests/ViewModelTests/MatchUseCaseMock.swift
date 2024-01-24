//
//  MatchUseCaseMock.swift
//  FoodBallAppTests
//
//  Created by Son Le on 23/01/2024.
//

import Combine
import MatchUseCase
import Domain
@testable import FootballApp

class MatchUseCaseMock: MatchUseCase {
    var matches: AnyPublisher<[Match], Never> {
        _matches.eraseToAnyPublisher()
    }

    let _matches: CurrentValueSubject<[Match], Never> = .init([])

    var update_get_called = false
    func update() {
        update_get_called = true
    }
}

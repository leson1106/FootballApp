//
//  TeamUseCaseMock.swift
//  FootballAppTests
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

extension TeamUseCaseMock {
    static func createMockTeams() -> [Team] {
        [
            .init(id: "1", name: "Blue dragon", logoURL: ""),
            .init(id: "2", name: "red dragon", logoURL: ""),
            .init(id: "3", name: "Royal Knights", logoURL: ""),
            .init(id: "4", name: "Chill Elephant", logoURL: ""),
            .init(id: "5", name: "Win King", logoURL: ""),
            .init(id: "6", name: "Serious Lions", logoURL: ""),
            .init(id: "7", name: "Growling Tigers", logoURL: "")
        ]
    }
}

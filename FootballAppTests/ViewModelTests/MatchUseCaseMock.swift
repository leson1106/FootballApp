//
//  MatchUseCaseMock.swift
//  FootballAppTests
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

extension MatchUseCaseMock {
    static func createMockMatches() -> [Match] {
        [
            .init(date: "2023-01-23T18:00:00.000Z", description: "",
                  home: "Blue dragon", away: "Red dragon", type: .upcoming),
            .init(date: "2023-02-23T18:00:00.000Z", description: "",
                  home: "Royal Knights", away: "Red dragon", type: .upcoming),
            .init(date: "2023-03-23T18:00:00.000Z", description: "",
                  home: "Chill Elephant", away: "Win King", type: .upcoming),
            .init(date: "2023-04-23T18:00:00.000Z", description: "",
                  home: "Serious Lions", away: "Growling Tigers", highlights: "https://tstzj.s3.amazonaws.com/highlights.mp4", type: .previous),
            .init(date: "2023-05-23T18:00:00.000Z", description: "",
                  home: "Blue dragon", away: "Royal Knights", highlights: "https://tstzj.s3.amazonaws.com/highlights.mp4", type: .previous)
        ]
    }
}

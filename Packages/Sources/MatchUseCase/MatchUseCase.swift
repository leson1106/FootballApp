//
//  MatchUseCase.swift
//
//  Created by Son Le on 24/01/2024.
//

import Domain
import MatchRepository
import CoreDataRepository
import Combine

public protocol MatchUseCase {
    var matches: AnyPublisher<[Match], Never> { get }
    func update()
}

public final class MatchUseCaseDefault {
    private let _matches: CurrentValueSubject<[Match], Never> = .init([])

    private let matchRepository: MatchRepository
    private let coreDataRepository: CoreDataRepository

    public init(matchRepository: MatchRepository, coreDataRepository: CoreDataRepository) {
        self.matchRepository = matchRepository
        self.coreDataRepository = coreDataRepository

        notifyMatchChanges()
    }
}

extension MatchUseCaseDefault: MatchUseCase {
    public var matches: AnyPublisher<[Match], Never> {
        _matches.eraseToAnyPublisher()
    }

    public func update() {
        Task.detached {
            guard let matches = try? await self.matchRepository.fetchMatches() else { return }
            self.coreDataRepository.save(matches: matches)

            self.notifyMatchChanges()
        }
    }

    private func notifyMatchChanges() {
        guard let matches = try? coreDataRepository.fetchMatches() else { return }
        _matches.value = matches
    }
}

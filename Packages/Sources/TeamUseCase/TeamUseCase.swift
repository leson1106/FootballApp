//
//  TeamUseCase.swift
//
//  Created by Son Le on 24/01/2024.
//

import Domain
import TeamRepository
import CoreDataRepository
import Combine

public protocol TeamUseCase {
    var teams: AnyPublisher<[Team], Never> { get }
    func update()
}

public final class TeamUseCaseDefault {
    private let _teams: CurrentValueSubject<[Team], Never> = .init([])

    private let teamRepository: TeamRepository
    private let coreDataRepository: CoreDataRepository

    public init(teamRepository: TeamRepository, coreDataRepository: CoreDataRepository) {
        self.teamRepository = teamRepository
        self.coreDataRepository = coreDataRepository
    }
}

extension TeamUseCaseDefault: TeamUseCase {
    public var teams: AnyPublisher<[Team], Never> {
        _teams.eraseToAnyPublisher()
    }

    public func update() {
        Task.detached {
            guard let teams = try? await self.teamRepository.fetchTeams() else { return }
            self.coreDataRepository.save(teams: teams)

            self.notifyTeamChanges()
        }
    }

    private func notifyTeamChanges() {
        guard let teams = try? coreDataRepository.fetchTeams() else { return }
        _teams.value = teams
    }
}

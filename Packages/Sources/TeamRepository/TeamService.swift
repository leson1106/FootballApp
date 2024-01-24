//
//  TeamRepository.swift
//
//  Created by Son Le on 24/01/2024.
//

import AWSService
import Domain

public protocol TeamRepository {
    func fetchTeams() async throws -> [Team]
}

public final class TeamClient {

    private let service: AWSService

    public init(service: AWSService) {
        self.service = service
    }
}

extension TeamClient: TeamRepository {
    public func fetchTeams() async throws -> [Team] {
        let request = FetchTeamsRequest()
        let response = try await service.request(request)
        return response.teams.map { Team($0) }
    }
}

fileprivate extension Team {
    init(_ response: FetchTeamsRequest.Response.Team) {
        self.init(id: response.id,
                  name: response.name,
                  logoURL: response.logoURL)
    }
}

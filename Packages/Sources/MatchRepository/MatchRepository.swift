//
//  MatchRepository.swift
//
//  Created by Son Le on 24/01/2024.
//

import AWSService
import Domain

public protocol MatchRepository {
    func fetchMatches() async throws -> [Match]
}

public final class MatchClient {

    private let service: AWSService

    public init(service: AWSService) {
        self.service = service
    }
}

extension MatchClient: MatchRepository {
    public func fetchMatches() async throws -> [Match] {
        let request = FetchMatchesRequest()
        let response = try await service.request(request)
        let upcomingMatches = response.matches.upcoming.map { Match($0, type: .upcoming) }
        let previoussMatches = response.matches.previous.map { Match($0, type: .previous) }
        return upcomingMatches + previoussMatches
    }
}

fileprivate extension Match {
    init(_ response: FetchMatchesRequest.Response.Match, type: MatchType) {
        self.init(date: response.date,
                  description: response.description,
                  home: response.home,
                  away: response.away,
                  winner: response.winner,
                  highlights: response.highlights,
                  type: type)
    }
}

//
//  FetchMatchesRequest.swift
//  FootBallApp
//
//  Created by Son Le on 23/01/2024.
//

import AWSService

public struct FetchMatchesRequest: Request {
    public let path = "teams/matches"
    public let method: HTTPMethod = .get
}

public extension FetchMatchesRequest {
    struct Response: Decodable {
        public let matches: Matches
    }
}

public extension FetchMatchesRequest.Response {
    struct Matches: Decodable {
        public let previous: [Match]
        public let upcoming: [Match]
    }

    struct Match: Decodable {
        public let date: String
        public let description: String
        public let home: String
        public let away: String
        public let winner: String?
        public let highlights: String?
    }
}

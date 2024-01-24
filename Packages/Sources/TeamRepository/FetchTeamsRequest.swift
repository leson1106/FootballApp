//
//  File.swift
//  
//
//  Created by Son Le on 24/01/2024.
//

import AWSService

public struct FetchTeamsRequest: Request {
    public let path = "teams"
    public let method: HTTPMethod = .get
}

public extension FetchTeamsRequest {
    struct Response: Decodable {
        public let teams: [Team]
    }
}

public extension FetchTeamsRequest.Response {
    struct Team: Decodable {
        public let id: String
        public let name: String
        public let logoURL: String

        enum CodingKeys: String, CodingKey {
            case id
            case name
            case logoURL = "logo"
        }
    }
}

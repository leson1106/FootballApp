//
//  Team.swift
//
//  Created by Son Le on 24/01/2024.
//

import Foundation

public struct Team: Hashable {
    public let id: String
    public let name: String
    public let logoURL: String

    public init(id: String, name: String, logoURL: String) {
        self.id = id
        self.name = name
        self.logoURL = logoURL
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

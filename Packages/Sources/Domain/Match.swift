//
//  Match.swift
//
//  Created by Son Le on 24/01/2024.
//

import Foundation

@objc
public enum MatchType: Int16, CaseIterable {
    case upcoming
    case previous
}

public struct Match: Hashable {
    public let date: String
    public let description: String
    public let home: String
    public let away: String
    public let winner: String?
    public let highlights: String?
    public let type: MatchType

    public init(date: String, description: String, home: String, away: String, winner: String? = nil, highlights: String? = nil, type: MatchType) {
        self.date = date
        self.description = description
        self.home = home
        self.away = away
        self.winner = winner
        self.highlights = highlights
        self.type = type
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(date)
        hasher.combine(description)
    }
}

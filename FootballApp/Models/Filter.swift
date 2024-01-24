//
//  Filter.swift
//  FootBallApp
//
//  Created by Son Le on 24/01/2024.
//

import Domain

struct Filter {
    let type: MatchType
    let teams: [Team]

    init(type: MatchType, teams: [Team] = []) {
        self.type = type
        self.teams = teams
    }
}

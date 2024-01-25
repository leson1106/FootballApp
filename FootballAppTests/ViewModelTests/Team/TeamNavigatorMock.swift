//
//  TeamNavigatorMock.swift
//  FootballAppTests
//
//  Created by Son Le on 25/01/2024.
//

import Domain
@testable import FootballApp

class TeamNavigatorMock: TeamNavigator {

    var toTeamDetail_get_called = false
    var toTeamDetail_with_team: Domain.Team?
    func toTeamDetail(_ team: Domain.Team) {
        toTeamDetail_get_called = true
        toTeamDetail_with_team = team
    }
}

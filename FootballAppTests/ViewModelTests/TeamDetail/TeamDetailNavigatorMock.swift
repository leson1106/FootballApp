//
//  TeamDetailNavigatorMock.swift
//  FootballAppTests
//
//  Created by Son Le on 25/01/2024.
//

import Foundation
@testable import FootballApp

class TeamDetailNavigatorMock: TeamDetailNavigator {

    var popTeamDetail_get_called = false
    func popTeamDetail() {
        popTeamDetail_get_called = true
    }
}

//
//  MatchNavigatorMock.swift
//  FootballAppTests
//
//  Created by Son Le on 23/01/2024.
//

import Combine
import Domain
@testable import FootballApp

class MatchNavigatorMock: MatchNavigator {

    var toFilter_get_called = false
    func toFilter(types: [MatchType],
                  allTeams: [Team],
                  apply: CurrentValueSubject<Filter, Never>) {
        toFilter_get_called = true
    }

    var toHighlight_get_called = false
    var toHighlight_match: Match?
    func toHighLight(match: Match) {
        toHighlight_get_called = true
        toHighlight_match = match
    }
}

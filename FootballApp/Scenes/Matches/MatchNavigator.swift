//
//  MatchNavigator.swift
//  FootBallApp
//
//  Created by Son Le on 17/01/2024.
//

import UIKit
import Combine
import Domain

protocol MatchNavigator {
    func toFilter(types: [MatchType], allTeams: [Team], apply: CurrentValueSubject<Filter, Never>)
    func toHighLight(match: Match)
}

final class MatchNavigatorDefault: MatchNavigator {

    private let navigationController: UINavigationController

    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func toFilter(types: [MatchType], allTeams: [Team], apply: CurrentValueSubject<Filter, Never>) {
        let filterController = MatchFilterViewController(types: types,
                                                         teams: allTeams,
                                                         filterSubject: apply)
        navigationController.present(filterController, animated: true)
    }

    func toHighLight(match: Match) {
        guard let highlight = match.highlights, let url = URL(string: highlight) else { return }
        let highlightController = MatchHighlightView(url: url)
        navigationController.present(highlightController, animated: true)
    }
}

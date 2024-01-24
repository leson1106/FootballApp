//
//  ViewModelType.swift
//  FootBallApp
//
//  Created by Son Le on 17/01/2024.
//

import Foundation

protocol ViewModelType {
    associatedtype Input
    associatedtype Output

    func transform(input: Input) -> Output
}

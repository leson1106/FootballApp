//
//  ServiceConstants.swift
//
//  Created by Son Le on 17/01/2024.
//

import Foundation

public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case update = "UPDATE"
    case delete = "DELETE"
}

public enum Domain {
    case aws

    var url: URL {
        return URL(string: "https://jmde6xvjr4.execute-api.us-east-1.amazonaws.com/")!
    }
}

enum APIError: Error, LocalizedError {
    case apiError(reason: String),
         parserError(reason: String),
         networkError(from: URLError),
         badRequest,
         unknown
}

//
//  Request.swift
//
//  Created by Son Le on 17/01/2024.
//

import Foundation

public protocol Request {
    associatedtype Response: Decodable

    var path: String { get }
    var method: HTTPMethod { get }
    var parameters: [String: String]? { get }
    var headers: [String: String]? { get }
}

public extension Request {
    var parameters: [String: String]? {
        return nil
    }

    var headers: [String: String]? {
        return nil
    }

    func asURLRequest(_ baseURL: URL) -> URLRequest? {
        let url: URL
        if #available(iOS 16.0, *) {
            url = baseURL.appending(path: path)
        } else {
            url = baseURL.appendingPathComponent(path)
        }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        return request
    }
}

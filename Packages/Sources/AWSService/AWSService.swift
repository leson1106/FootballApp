//
//  AWSService.swift
//
//  Created by Son Le on 24/01/2024.
//

import Foundation

public protocol AWSService {
    func request<T: Request>(_ request: T) async throws -> T.Response
}

public final class AWSClient {

    private let session: URLSession
    private let domain: Domain

    public init(domain: Domain, session: URLSession = .shared) {
        self.domain = domain
        self.session = session
    }
}

extension AWSClient: AWSService {
    public func request<T: Request>(_ request: T) async throws -> T.Response {
        guard let request = request.asURLRequest(domain.url) else {
            throw APIError.badRequest
        }

        return try await withCheckedThrowingContinuation { continuation in
            let task = session.dataTask(with: request) { data, response, error in
                if let error {
                    continuation.resume(throwing: error)
                    return
                }

                if let data {
                    do {
                        let result = try JSONDecoder().decode(T.Response.self, from: data)
                        continuation.resume(returning: result)
                    } catch {
                        continuation.resume(throwing: APIError.parserError(reason: error.localizedDescription))
                    }
                } else {
                    continuation.resume(throwing: APIError.unknown)
                }
            }
            task.resume()
        }
    }
}

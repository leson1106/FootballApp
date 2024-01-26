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

        let (data, _) = try await session.data(for: request)
        let decoder = JSONDecoder()
        return try decoder.decode(T.Response.self, from: data)
    }
}

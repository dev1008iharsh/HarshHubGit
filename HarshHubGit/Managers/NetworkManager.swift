//
//  HarshHubGit
//
//  Created by Harsh on 2026.
//  GitHub : https://github.com/dev1008iharsh?tab=repositories
//

import UIKit

final class NetworkManager {
    static let shared = NetworkManager()

    private let baseURL = "https://api.github.com/users/"
    private let session: URLSession
    let cache = NSCache<NSString, UIImage>()
    private let decoder: JSONDecoder

    private init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        configuration.requestCachePolicy = .returnCacheDataElseLoad
        session = URLSession(configuration: configuration)

        decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601

        cache.countLimit = 100
        cache.totalCostLimit = 50 * 1024 * 1024 // 50MB
    }

    // MARK: - Followers

    func getFollowers(for username: String, page: Int) async throws -> [Follower] {
        let endpoint = baseURL + "\(username)/followers?per_page=100&page=\(page)"
        guard let url = URL(string: endpoint) else { throw HDError.invalidUsername }

        let (data, response) = try await session.data(from: url)
        try validate(response: response)

        do {
            return try decoder.decode([Follower].self, from: data)
        } catch {
            throw HDError.invalidData
        }
    }

    // MARK: - User Info

    func getUserInfo(for username: String) async throws -> User {
        let endpoint = baseURL + "\(username)"
        guard let url = URL(string: endpoint) else { throw HDError.invalidUsername }

        let (data, response) = try await session.data(from: url)
        try validate(response: response)

        do {
            return try decoder.decode(User.self, from: data)
        } catch {
            throw HDError.invalidData
        }
    }

    // MARK: - Generic Fetch

    func fetchData<T: Decodable>(for: T.Type, from url: URL) async throws -> T {
        let (data, response) = try await session.data(from: url)
        try validate(response: response)

        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw HDError.invalidData
        }
    }

    // MARK: - Image Download

    func downloadImage(from urlString: String) async -> UIImage? {
        let cacheKey = NSString(string: urlString)

        if let image = cache.object(forKey: cacheKey) {
            return image
        }

        guard let url = URL(string: urlString) else { return nil }

        do {
            let (data, response) = try await session.data(from: url)
            try validate(response: response)

            guard let image = UIImage(data: data) else { return nil }

            cache.setObject(image, forKey: cacheKey, cost: data.count)
            return image
        } catch {
            return nil
        }
    }

    // MARK: - Response Validation

    private func validate(response: URLResponse) throws {
        guard let response = response as? HTTPURLResponse else {
            throw HDError.invalidResponse
        }

        guard response.statusCode == 200 else {
            throw HDError.invalidResponse
        }
    }
}

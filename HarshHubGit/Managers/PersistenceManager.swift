//
//  HarshHubGit
//
//  Created by Harsh on 2026.
//  GitHub : https://github.com/dev1008iharsh?tab=repositories
//

import Foundation

enum PersistenceActionType {
    case add, remove
}

enum PersistenceManager {
    private static let defaults = UserDefaults.standard
    private static let queue = DispatchQueue(label: "com.harsh.persistence", qos: .utility)

    enum Keys { static let favorites = "favorites" }

    static func updateWith(favorite: Follower, actionType: PersistenceActionType, completed: @escaping (HDError?) -> Void) {
        queue.async {
            retrieveFavorites { result in
                switch result {
                case var .success(favorites):

                    switch actionType {
                    case .add:
                        guard !favorites.contains(favorite) else {
                            DispatchQueue.main.async { completed(.alreadyInFavorites) }
                            return
                        }
                        favorites.append(favorite)

                    case .remove:
                        favorites.removeAll { $0.login == favorite.login }
                    }

                    let error = save(favorites: favorites)
                    DispatchQueue.main.async { completed(error) }

                case let .failure(error):
                    DispatchQueue.main.async { completed(error) }
                }
            }
        }
    }

    static func retrieveFavorites(completed: @escaping (Result<[Follower], HDError>) -> Void) {
        queue.async {
            guard let favoritesData = defaults.object(forKey: Keys.favorites) as? Data else {
                DispatchQueue.main.async { completed(.success([])) }
                return
            }

            do {
                let decoder = JSONDecoder()
                let favorites = try decoder.decode([Follower].self, from: favoritesData)
                DispatchQueue.main.async { completed(.success(favorites)) }
            } catch {
                DispatchQueue.main.async { completed(.failure(.unableToFavorite)) }
            }
        }
    }

    private static func save(favorites: [Follower]) -> HDError? {
        do {
            let encoder = JSONEncoder()
            let encodedFavorites = try encoder.encode(favorites)
            defaults.set(encodedFavorites, forKey: Keys.favorites)
            return nil
        } catch {
            return .unableToFavorite
        }
    }
}

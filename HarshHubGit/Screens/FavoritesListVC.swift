//
//  HarshHubGit
//
//  Created by Harsh on 2026.
//  GitHub : https://github.com/dev1008iharsh?tab=repositories
//

import UIKit

final class FavoritesListVC: HDDataLoadingVC {
    private let tableView = UITableView()
    private var favorites: [Follower] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getFavorites()
    }

    override func updateContentUnavailableConfiguration(using state: UIContentUnavailableConfigurationState) {
        if favorites.isEmpty {
            var config = UIContentUnavailableConfiguration.empty()
            config.image = .init(systemName: "star")
            config.text = "No Favorites"
            config.secondaryText = "Add a favorite on the follower list screen"
            contentUnavailableConfiguration = config
        } else {
            contentUnavailableConfiguration = nil
        }
    }

    private func configureViewController() {
        view.backgroundColor = .systemBackground
        title = "Favorites"
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    private func configureTableView() {
        view.addSubview(tableView)

        tableView.frame = view.bounds
        tableView.rowHeight = 80
        tableView.delegate = self
        tableView.dataSource = self
        tableView.removeExcessCells()

        tableView.register(FavoriteCell.self, forCellReuseIdentifier: FavoriteCell.reuseID)
    }

    private func getFavorites() {
        PersistenceManager.retrieveFavorites { [weak self] result in
            guard let self else { return }

            switch result {
            case let .success(favorites):
                DispatchQueue.main.async {
                    self.updateUI(with: favorites)
                }

            case let .failure(error):
                DispatchQueue.main.async {
                    self.presentHDAlert(title: "Something went wrong",
                                        message: error.rawValue,
                                        buttonTitle: "Ok")
                }
            }
        }
    }

    private func updateUI(with favorites: [Follower]) {
        self.favorites = favorites
        setNeedsUpdateContentUnavailableConfiguration()
        tableView.reloadData()
        view.bringSubviewToFront(tableView)
    }
}

extension FavoritesListVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        favorites.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: FavoriteCell.reuseID
        ) as? FavoriteCell else {
            return UITableViewCell()
        }

        let favorite = favorites[indexPath.row]
        cell.set(favorite: favorite)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let favorite = favorites[indexPath.row]
        let destVC = FollowerListVC(username: favorite.login)

        navigationController?.pushViewController(destVC, animated: true)
    }

    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }

        PersistenceManager.updateWith(
            favourite: favorites[indexPath.row],
            actionType: .remove
        ) { [weak self] error in

            guard let self else { return }

            guard let error else {
                DispatchQueue.main.async {
                    self.favorites.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .left)
                    self.setNeedsUpdateContentUnavailableConfiguration()
                }
                return
            }

            DispatchQueue.main.async {
                self.presentHDAlert(title: "Unable to remove",
                                    message: error.rawValue,
                                    buttonTitle: "Ok")
            }
        }
    }
}

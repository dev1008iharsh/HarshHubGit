//
//  HarshHubGit
//
//  Created by Harsh on 2026.
//  GitHub : https://github.com/dev1008iharsh?tab=repositories
//

import UIKit

final class FollowerListVC: HDDataLoadingVC, UISearchResultsUpdating, UICollectionViewDelegate {
    enum Section { case main }

    var username: String!

    private var followers: [Follower] = []
    private var filteredFollowers: [Follower] = []
    private var page = 1
    private var hasMoreFollowers = true
    private var isSearching = false
    private var isLoadingMoreFollowers = false

    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, Follower>!

    init(username: String) {
        super.init(nibName: nil, bundle: nil)
        self.username = username
        title = username
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureSearchController()
        configureCollectionView()
        configureDataSource()
        getFollowers(username: username, page: page)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }

    override func updateContentUnavailableConfiguration(using state: UIContentUnavailableConfigurationState) {
        if followers.isEmpty && !isLoadingMoreFollowers {
            var config = UIContentUnavailableConfiguration.empty()
            config.image = .init(systemName: "person.slash")
            config.text = "No Followers"
            config.secondaryText = "This user has no followers. Go follow them!"
            contentUnavailableConfiguration = config
        } else if isSearching && filteredFollowers.isEmpty {
            contentUnavailableConfiguration = UIContentUnavailableConfiguration.search()
        } else {
            contentUnavailableConfiguration = nil
        }
    }

    private func configureViewController() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true

        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addButton
    }

    private func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createThreeColumnFlowLayout(in: view))
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
        collectionView.register(FollowerCell.self, forCellWithReuseIdentifier: FollowerCell.reuseID)
    }

    private func configureSearchController() {
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search for a username"
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
    }

    // MARK: - SEARCH (FIXED)

    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text, !filter.isEmpty else {
            filteredFollowers.removeAll()
            updateData(on: followers)
            isSearching = false
            return
        }

        isSearching = true

        filteredFollowers = followers.filter {
            $0.login.lowercased().contains(filter.lowercased())
        }

        updateData(on: filteredFollowers)
        setNeedsUpdateContentUnavailableConfiguration()
    }

    // MARK: - API CALL

    private func getFollowers(username: String, page: Int) {
        guard !isLoadingMoreFollowers else { return }

        showLoadingView()
        isLoadingMoreFollowers = true

        Task { [weak self] in
            guard let self else { return }

            do {
                let followers = try await NetworkManager.shared.getFollowers(for: username, page: page)

                await MainActor.run {
                    self.updateUI(with: followers)
                    self.dismissLoadingView()
                    self.isLoadingMoreFollowers = false
                }

            } catch {
                await MainActor.run {
                    if let gfError = error as? HDError {
                        self.presentGFAlert(title: "Error", message: gfError.rawValue, buttonTitle: "Ok")
                    } else {
                        self.presentDefaultError()
                    }

                    self.dismissLoadingView()
                    self.isLoadingMoreFollowers = false
                }
            }
        }
    }

    private func updateUI(with followers: [Follower]) {
        if followers.count < 100 { hasMoreFollowers = false }
        self.followers.append(contentsOf: followers)
        updateData(on: self.followers)
        setNeedsUpdateContentUnavailableConfiguration()
    }

    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Follower>(collectionView: collectionView) {
            collectionView, indexPath, follower in

            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: FollowerCell.reuseID,
                for: indexPath
            ) as? FollowerCell else { return UICollectionViewCell() }

            cell.set(follower: follower)
            return cell
        }
    }

    private func updateData(on followers: [Follower]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Follower>()
        snapshot.appendSections([.main])
        snapshot.appendItems(followers)

        dataSource.apply(snapshot, animatingDifferences: true)
    }

    @objc private func addButtonTapped() {
        showLoadingView()

        Task { [weak self] in
            guard let self else { return }

            do {
                let user = try await NetworkManager.shared.getUserInfo(for: username)

                await MainActor.run {
                    self.addUserToFavorites(user: user)
                    self.dismissLoadingView()
                }

            } catch {
                await MainActor.run {
                    if let gfError = error as? HDError {
                        self.presentGFAlert(title: "Error", message: gfError.rawValue, buttonTitle: "Ok")
                    } else {
                        self.presentDefaultError()
                    }

                    self.dismissLoadingView()
                }
            }
        }
    }

    private func addUserToFavorites(user: User) {
        let favorite = Follower(login: user.login, avatarUrl: user.avatarUrl)

        PersistenceManager.updateWith(favorite: favorite, actionType: .add) { [weak self] error in
            guard let self else { return }

            DispatchQueue.main.async {
                if let error {
                    self.presentGFAlert(title: "Error", message: error.rawValue, buttonTitle: "Ok")
                } else {
                    self.presentGFAlert(title: "Success!", message: "User added to favorites 🎉", buttonTitle: "Done")
                }
            }
        }
    }
}

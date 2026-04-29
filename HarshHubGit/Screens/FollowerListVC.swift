//
//  HarshHubGit
//
//  Created by Harsh on 2026.
//  GitHub : https://github.com/dev1008iharsh?tab=repositories
//

import UIKit

final class FollowerListVC: HDDataLoadingVC {
    enum Section { case main }

    // MARK: - Properties

    var username: String

    private var followers: [Follower] = []
    private var filteredFollowers: [Follower] = []
    private var page = 1
    private var hasMoreFollowers = true
    private var isSearching = false
    private var isLoadingMoreFollowers = false
    private var user: User?

    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, Follower>!

    // MARK: - UI Components

    private let profileButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false

        button.setImage(UIImage(named: "avatar-placeholder"), for: .normal)
        button.tintColor = .white
        button.backgroundColor = .systemBlue

        button.layer.cornerRadius = 30
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.3
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.shadowRadius = 6

        // Accessibility
        button.accessibilityLabel = "Open GitHub Profile"
        button.accessibilityTraits = .button

        return button
    }()

    // MARK: - Init

    init(username: String) {
        self.username = username
        super.init(nibName: nil, bundle: nil)
        title = username
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureSearchController()
        configureCollectionView()
        configureDataSource()
        configureFloatingButton()
        getFollowers(username: username, page: page)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }

    // MARK: - Empty State

    override func updateContentUnavailableConfiguration(using state: UIContentUnavailableConfigurationState) {
        if followers.isEmpty && !isLoadingMoreFollowers {
            var config = UIContentUnavailableConfiguration.empty()
            config.image = UIImage(systemName: "person.2.slash")
            config.text = "No Followers"
            config.secondaryText = "This user has no followers. Go follow them!"
            contentUnavailableConfiguration = config
        } else if isSearching && filteredFollowers.isEmpty {
            contentUnavailableConfiguration = UIContentUnavailableConfiguration.search()
        } else {
            contentUnavailableConfiguration = nil
        }
    }

    // MARK: - UI Setup

    private func configureViewController() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true

        let addButton = UIBarButtonItem(barButtonSystemItem: .bookmarks,
                                        target: self,
                                        action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addButton
    }

    private func configureCollectionView() {
        collectionView = UICollectionView(
            frame: view.bounds,
            collectionViewLayout: UIHelper.createThreeColumnFlowLayout(in: view)
        )

        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
        collectionView.register(FollowerCell.self,
                                forCellWithReuseIdentifier: FollowerCell.reuseID)
    }

    private func configureSearchController() {
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search for a github username"
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
    }

    // MARK: - DataSource

    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Follower>(
            collectionView: collectionView
        ) { collectionView, indexPath, follower in

            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: FollowerCell.reuseID,
                for: indexPath
            ) as? FollowerCell else {
                return UICollectionViewCell()
            }

            cell.set(follower: follower)
            return cell
        }
    }

    private func configureFloatingButton() {
        view.addSubview(profileButton)

        NSLayoutConstraint.activate([
            profileButton.widthAnchor.constraint(equalToConstant: 60),

            profileButton.heightAnchor.constraint(equalToConstant: 60),

            profileButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),

            profileButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),

        ])

        profileButton.addTarget(self,
                                action: #selector(profileButtonTapped),

                                for: .touchUpInside)
    }

    @objc private func profileButtonTapped() {
        guard let url = URL(string: "https://github.com/\(username)") else { return }

        presentSafariVC(with: url)
    }

    private func updateData(on followers: [Follower]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Follower>()
        snapshot.appendSections([.main])
        snapshot.appendItems(followers)

        dataSource.apply(snapshot, animatingDifferences: true)
    }

    // MARK: - API

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
                    if let hdError = error as? HDError {
                        self.presentHDAlert(title: "Error",
                                            message: hdError.rawValue,
                                            buttonTitle: "Ok")
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

    // MARK: - Favorites

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
                    if let hdError = error as? HDError {
                        self.presentHDAlert(title: "Error",
                                            message: hdError.rawValue,
                                            buttonTitle: "OK")
                    } else {
                        self.presentDefaultError()
                    }

                    self.dismissLoadingView()
                }
            }
        }
    }

    private func addUserToFavorites(user: User) {
        let favourite = Follower(login: user.login, avatarUrl: user.avatarUrl)

        PersistenceManager.updateWith(favourite: favourite,
                                      actionType: .add) { [weak self] error in
            guard let self else { return }

            DispatchQueue.main.async {
                if let error {
                    self.presentHDAlert(title: "Error",
                                        message: error.rawValue,
                                        buttonTitle: "Ok")
                } else {
                    self.presentHDAlert(title: "Success!",
                                        message: "User added to favourites 🎉",
                                        buttonTitle: "Done")
                }
            }
        }
    }
}

// MARK: - UICollectionViewDelegate

extension FollowerListVC: UICollectionViewDelegate {
    // Pagination
    func scrollViewDidEndDragging(_ scrollView: UIScrollView,
                                  willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height

        if offsetY > contentHeight - height {
            guard hasMoreFollowers, !isLoadingMoreFollowers else { return }
            page += 1
            getFollowers(username: username, page: page)
        }
    }

    // Navigation
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        let activeArray = isSearching ? filteredFollowers : followers
        let follower = activeArray[indexPath.item]

        let destVC = UserInfoVC()
        destVC.username = follower.login
        destVC.delegate = self

        let navController = UINavigationController(rootViewController: destVC)
        present(navController, animated: true)
    }
}

// MARK: - Search

extension FollowerListVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text,
              !filter.isEmpty else {
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
}

// MARK: - UserInfoVCDelegate

extension FollowerListVC: UserInfoVCDelegate {
    func didRequestFollowers(for username: String) {
        self.username = username
        title = username
        page = 1

        followers.removeAll()
        filteredFollowers.removeAll()

        collectionView.setContentOffset(.zero, animated: true)
        getFollowers(username: username, page: page)
    }
}

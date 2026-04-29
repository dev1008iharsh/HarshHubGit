//
//  HarshHubGit
//
//  Created by Harsh on 2026.
//  GitHub : https://github.com/dev1008iharsh?tab=repositories
//

import UIKit

final class HDTabBarController: UITabBarController {
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabBar()
        setupViewControllers()
    }

    // MARK: - Configuration

    private func configureTabBar() {
        let appearance = UITabBarAppearance()
        appearance.configureWithDefaultBackground()

        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance

        tabBar.tintColor = .systemIndigo
        tabBar.unselectedItemTintColor = .secondaryLabel
    }

    private func setupViewControllers() {
        viewControllers = [
            createSearchNavigationController(),
            createFavoritesNavigationController(),
        ]
        selectedIndex = 0
    }

    // MARK: - Navigation Controllers

    private func createSearchNavigationController() -> UINavigationController {
        let viewController = SearchVC()
        viewController.title = "Search"
        viewController.navigationItem.largeTitleDisplayMode = .always

        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.navigationBar.prefersLargeTitles = true

        navigationController.tabBarItem = UITabBarItem(
            tabBarSystemItem: .search,
            tag: 0
        )

        // Accessibility
        navigationController.tabBarItem.accessibilityLabel = "Search Tab"
        navigationController.tabBarItem.accessibilityHint = "Search for users"

        return navigationController
    }

    private func createFavoritesNavigationController() -> UINavigationController {
        let viewController = FavoritesListVC() // ❗unchanged as per your rule
        viewController.title = "Favorites"
        viewController.navigationItem.largeTitleDisplayMode = .always

        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.navigationBar.prefersLargeTitles = true

        navigationController.tabBarItem = UITabBarItem(
            tabBarSystemItem: .favorites,
            tag: 1
        )

        // Accessibility
        navigationController.tabBarItem.accessibilityLabel = "Favorites Tab"
        navigationController.tabBarItem.accessibilityHint = "View favorite users"

        return navigationController
    }

    // MARK: - Debug

    deinit {
        print("HDTabBarController deinitialized")
    }
}

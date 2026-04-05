//
//  HarshHubGit
//
//  Created by Harsh on 2026.
//  GitHub : https://github.com/dev1008iharsh?tab=repositories
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    // MARK: - Properties

    var window: UIWindow?

    // MARK: - Scene Lifecycle

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }

        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = HDTabBarController()
        window.makeKeyAndVisible()

        self.window = window

        configureGlobalAppearance()
    }

    // MARK: - Global UI Configuration

    private func configureGlobalAppearance() {
        configureNavigationBar()
    }

    private func configureNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()

        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.label,
        ]

        appearance.largeTitleTextAttributes = [
            .foregroundColor: UIColor.label,
        ]

        UINavigationBar.appearance().tintColor = .systemGreen
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
    }

    // MARK: - Scene State

    func sceneDidDisconnect(_ scene: UIScene) {
        // Release resources if needed
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Restart tasks if needed
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Pause ongoing work
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Prepare UI updates
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Save data safely
    }

    // MARK: - Debug

    deinit {
        print("SceneDelegate deinitialized")
    }
}

//
//  HarshHubGit
//
//  Created by Harsh on 2026.
//  GitHub : https://github.com/dev1008iharsh?tab=repositories
//

import UIKit

class HDDataLoadingVC: UIViewController {
    private var containerView: UIView?

    // MARK: - Loading

    func showLoadingView() {
        DispatchQueue.main.async {
            // Prevent multiple overlays
            if self.containerView != nil { return }

            let containerView = UIView(frame: self.view.bounds)
            containerView.backgroundColor = .systemBackground
            containerView.alpha = 0

            self.view.addSubview(containerView)
            self.containerView = containerView

            UIView.animate(withDuration: 0.25) {
                containerView.alpha = 0.8
            }

            let activityIndicator = UIActivityIndicatorView(style: .large)
            activityIndicator.translatesAutoresizingMaskIntoConstraints = false

            containerView.addSubview(activityIndicator)

            NSLayoutConstraint.activate([
                activityIndicator.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
                activityIndicator.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            ])

            activityIndicator.startAnimating()
        }
    }

    func dismissLoadingView() {
        DispatchQueue.main.async {
            guard let containerView = self.containerView else { return }

            UIView.animate(withDuration: 0.2, animations: {
                containerView.alpha = 0
            }) { _ in
                containerView.removeFromSuperview()
                self.containerView = nil
            }
        }
    }

    // MARK: - Empty State

    func showEmptyStateView(with message: String, in view: UIView) {
        DispatchQueue.main.async {
            let emptyStateView = HDEmptyStateView(message: message)
            emptyStateView.frame = view.bounds

            // Remove previous empty views if any
            view.subviews
                .filter { $0 is HDEmptyStateView }
                .forEach { $0.removeFromSuperview() }

            view.addSubview(emptyStateView)
        }
    }
}

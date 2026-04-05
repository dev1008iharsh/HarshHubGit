//
//  HarshHubGit
//
//  Created by Harsh on 2026.
//  GitHub : https://github.com/dev1008iharsh?tab=repositories
//

import SafariServices
import UIKit

extension UIViewController {
    func presentGFAlert(title: String, message: String, buttonTitle: String) {
        DispatchQueue.main.async {
            guard self.presentedViewController == nil else { return }

            let alertVC = HDAlertVC(title: title, message: message, buttonTitle: buttonTitle)
            alertVC.modalPresentationStyle = .overFullScreen
            alertVC.modalTransitionStyle = .crossDissolve
            self.present(alertVC, animated: true)
        }
    }

    func presentDefaultError() {
        DispatchQueue.main.async {
            guard self.presentedViewController == nil else { return }

            let alertVC = HDAlertVC(
                title: "Something Went Wrong",
                message: "We were unable to complete your task at this time. Please try again.",
                buttonTitle: "Ok"
            )
            alertVC.modalPresentationStyle = .overFullScreen
            alertVC.modalTransitionStyle = .crossDissolve
            self.present(alertVC, animated: true)
        }
    }

    func presentSafariVC(with url: URL) {
        DispatchQueue.main.async {
            let safariVC = SFSafariViewController(url: url)
            safariVC.preferredControlTintColor = .systemGreen
            self.present(safariVC, animated: true)
        }
    }
}

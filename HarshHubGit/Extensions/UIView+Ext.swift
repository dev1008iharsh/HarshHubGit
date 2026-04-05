//
//  HarshHubGit
//
//  Created by Harsh on 2026.
//  GitHub : https://github.com/dev1008iharsh?tab=repositories
//

import UIKit

extension UIView {
    func pinToEdges(of superview: UIView, useSafeArea: Bool = false) {
        translatesAutoresizingMaskIntoConstraints = false

        if useSafeArea {
            let guide = superview.safeAreaLayoutGuide

            NSLayoutConstraint.activate([
                topAnchor.constraint(equalTo: guide.topAnchor),
                leadingAnchor.constraint(equalTo: guide.leadingAnchor),
                trailingAnchor.constraint(equalTo: guide.trailingAnchor),
                bottomAnchor.constraint(equalTo: guide.bottomAnchor),
            ])
        } else {
            NSLayoutConstraint.activate([
                topAnchor.constraint(equalTo: superview.topAnchor),
                leadingAnchor.constraint(equalTo: superview.leadingAnchor),
                trailingAnchor.constraint(equalTo: superview.trailingAnchor),
                bottomAnchor.constraint(equalTo: superview.bottomAnchor),
            ])
        }
    }

    func addSubviews(_ views: UIView...) {
        views.forEach { addSubview($0) }
    }
}

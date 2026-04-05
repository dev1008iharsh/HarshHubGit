//
//  HarshHubGit
//
//  Created by Harsh on 2026.
//  GitHub : https://github.com/dev1008iharsh?tab=repositories
//

import SwiftUI
import UIKit

final class FollowerCell: UICollectionViewCell {
    static let reuseID = "FollowerCell"

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure() {
        contentView.backgroundColor = .clear
        backgroundColor = .clear
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        contentConfiguration = nil // Prevent reuse artifacts
    }

    func set(follower: Follower) {
        contentConfiguration = UIHostingConfiguration {
            FollowerView(follower: follower)
        }
    }
}

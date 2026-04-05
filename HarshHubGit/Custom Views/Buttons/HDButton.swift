//
//  HarshHubGit
//
//  Created by Harsh on 2026.
//  GitHub : https://github.com/dev1008iharsh?tab=repositories
//

import UIKit

final class HDButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    convenience init(color: UIColor, title: String, systemImageName: String) {
        self.init(frame: .zero)
        set(color: color, title: title, systemImageName: systemImageName)
    }

    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false

        var config = UIButton.Configuration.filled()
        config.cornerStyle = .medium
        config.imagePadding = 6
        config.imagePlacement = .leading

        configuration = config

        // Accessibility
        accessibilityTraits = .button
    }

    final func set(color: UIColor, title: String, systemImageName: String) {
        guard var config = configuration else { return }

        config.baseBackgroundColor = color
        config.baseForegroundColor = .white
        config.title = title
        config.image = UIImage(systemName: systemImageName)

        configuration = config

        accessibilityLabel = title
        accessibilityHint = "Tap to perform action"
    }
}

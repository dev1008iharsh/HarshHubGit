//
//  HarshHubGit
//
//  Created by Harsh on 2026.
//  GitHub : https://github.com/dev1008iharsh?tab=repositories
//

import UIKit

final class HDTextField: UITextField {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false

        layer.cornerRadius = 10
        layer.borderWidth = 2
        layer.borderColor = UIColor.systemGray4.cgColor

        textColor = .label
        tintColor = .label
        textAlignment = .center

        font = UIFont.preferredFont(forTextStyle: .title2)
        adjustsFontForContentSizeCategory = true // Dynamic Type support

        adjustsFontSizeToFitWidth = true
        minimumFontSize = 12

        backgroundColor = .tertiarySystemBackground

        autocorrectionType = .no
        autocapitalizationType = .none // IMPORTANT for usernames
        returnKeyType = .go
        clearButtonMode = .whileEditing

        placeholder = "Enter a username"

        accessibilityLabel = "Username Text Field"
        accessibilityHint = "Enter a GitHub username"
    }
}

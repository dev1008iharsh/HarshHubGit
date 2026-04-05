//
//  HarshHubGit
//
//  Created by Harsh on 2026.
//  GitHub : https://github.com/dev1008iharsh?tab=repositories
//

import UIKit

final class HDSecondaryTitleLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    convenience init(fontSize: CGFloat) {
        self.init(frame: .zero)

        let baseFont = UIFont.systemFont(ofSize: fontSize, weight: .medium)
        font = UIFontMetrics(forTextStyle: .subheadline).scaledFont(for: baseFont)
    }

    private func configure() {
        textColor = .secondaryLabel

        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.9
        lineBreakMode = .byTruncatingTail

        adjustsFontForContentSizeCategory = true // Dynamic Type

        translatesAutoresizingMaskIntoConstraints = false

        isAccessibilityElement = true
    }
}

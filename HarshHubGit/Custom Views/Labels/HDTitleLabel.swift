//
//  HarshHubGit
//
//  Created by Harsh on 2026.
//  GitHub : https://github.com/dev1008iharsh?tab=repositories
//

import UIKit

final class HDTitleLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    convenience init(textAlignment: NSTextAlignment, fontSize: CGFloat) {
        self.init(frame: .zero)
        self.textAlignment = textAlignment

        let baseFont = UIFont.systemFont(ofSize: fontSize, weight: .bold)
        font = UIFontMetrics(forTextStyle: .headline).scaledFont(for: baseFont)
    }

    private func configure() {
        textColor = .label

        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.9
        lineBreakMode = .byTruncatingTail

        adjustsFontForContentSizeCategory = true  

        translatesAutoresizingMaskIntoConstraints = false

        isAccessibilityElement = true
    }
}

//
//  HarshHubGit
//
//  Created by Harsh on 2026.
//  GitHub : https://github.com/dev1008iharsh?tab=repositories
//

import UIKit

final class HDAvatarImageView: UIImageView {
    private let cache = NetworkManager.shared.cache
    private let placeholderImage = Images.placeholder

    private var currentURL: String?

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure() {
        layer.cornerRadius = 10
        clipsToBounds = true
        image = placeholderImage
        contentMode = .scaleAspectFill
        translatesAutoresizingMaskIntoConstraints = false
    }

    func downloadImage(fromURL urlString: String) {
        currentURL = urlString
        image = placeholderImage

        let cacheKey = NSString(string: urlString)
        if let cachedImage = cache.object(forKey: cacheKey) {
            image = cachedImage
            return
        }

        Task { [weak self] in
            guard let self else { return }

            let image = await NetworkManager.shared.downloadImage(from: urlString)

            // Prevent wrong image due to reuse
            guard self.currentURL == urlString else { return }

            DispatchQueue.main.async {
                self.image = image ?? self.placeholderImage
            }
        }
    }
}

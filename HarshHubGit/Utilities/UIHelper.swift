//
//  HarshHubGit
//
//  Created by Harsh on 2026.
//  GitHub : https://github.com/dev1008iharsh?tab=repositories
//

import UIKit

enum UIHelper {
    static func createThreeColumnFlowLayout(in view: UIView) -> UICollectionViewFlowLayout {
        let width = view.bounds.width
        let padding: CGFloat = 12
        let minimumItemSpacing: CGFloat = 10

        // Ensure layout adapts properly (iPad / rotation)
        let numberOfItemsPerRow: CGFloat = width > 500 ? 4 : 3

        let totalSpacing = (padding * 2) + (minimumItemSpacing * (numberOfItemsPerRow - 1))
        let availableWidth = width - totalSpacing
        let itemWidth = floor(availableWidth / numberOfItemsPerRow)

        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        flowLayout.minimumInteritemSpacing = minimumItemSpacing
        flowLayout.minimumLineSpacing = minimumItemSpacing
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth + 40)

        return flowLayout
    }
}

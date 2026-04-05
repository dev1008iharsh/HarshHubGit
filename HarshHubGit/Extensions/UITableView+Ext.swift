//
//  HarshHubGit
//
//  Created by Harsh on 2026.
//  GitHub : https://github.com/dev1008iharsh?tab=repositories
//

import UIKit

extension UITableView {
    func reloadDataOnMainThread() {
        if Thread.isMainThread {
            reloadData()
        } else {
            DispatchQueue.main.async { [weak self] in
                self?.reloadData()
            }
        }
    }

    func removeExcessCells() {
        tableFooterView = UIView(frame: .zero)
    }
}

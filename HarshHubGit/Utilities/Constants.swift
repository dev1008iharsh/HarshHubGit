//
//  HarshHubGit
//
//  Created by Harsh on 2026.
//  GitHub : https://github.com/dev1008iharsh?tab=repositories
//

import UIKit

enum SFSymbols {
    static let location = UIImage(systemName: "mappin.and.ellipse")
    static let repos = UIImage(systemName: "folder")
    static let gists = UIImage(systemName: "text.alignleft")
    static let followers = UIImage(systemName: "heart")
    static let following = UIImage(systemName: "person.2")
}

enum Images {
    static let placeholder = UIImage(resource: .avatarPlaceholder)
    static let emptyStateLogo = UIImage(resource: .emptyStateLogo)
    static let harshHubRounded = UIImage(resource: .harshHubRounded) // naming fix
}

enum DeviceTypes {
    
    static let idiom = UIDevice.current.userInterfaceIdiom
    static let isiPad = idiom == .pad
    
    static var isSmallDevice: Bool {
        UIScreen.main.bounds.height < 700
    }
}

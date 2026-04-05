//
//  HarshHubGit
//
//  Created by Harsh on 2026.
//  GitHub : https://github.com/dev1008iharsh?tab=repositories
//

import SwiftUI

struct FollowerView: View {
    let follower: Follower

    var body: some View {
        VStack(spacing: 8) {
            AsyncImage(url: URL(string: follower.avatarUrl)) { phase in
                switch phase {
                case .empty:
                    placeholder

                case let .success(image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)

                case .failure:
                    placeholder

                @unknown default:
                    placeholder
                }
            }
            .frame(height: 100)
            .clipShape(Circle())

            Text(follower.login)
                .font(.headline)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
                .foregroundColor(.primary)
        }
    }

    private var placeholder: some View {
        Image(.avatarPlaceholder)
            .resizable()
            .aspectRatio(contentMode: .fill)
    }
}

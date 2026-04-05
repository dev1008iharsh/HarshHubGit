//
//  HarshHubGit
//
//  Created by Harsh on 2026.
//  GitHub : https://github.com/dev1008iharsh?tab=repositories
//

import Foundation

enum HDError: String, Error {
    case invalidUsername = "The username you entered is not valid. Please double-check the spelling and try again."

    case unableToComplete = "We were unable to complete your request at this time. Please check your internet connection and try again."

    case invalidResponse = "We received an unexpected response from the server. Please try again in a few moments."

    case invalidData = "The data we received from the server appears to be corrupted or invalid. Please try again later."

    case unableToFavorite = "We couldn’t update your favorites right now. Please try again in a moment."

    case alreadyInFavorites = "This user is already in your favorites list. You don’t need to add them again."
}

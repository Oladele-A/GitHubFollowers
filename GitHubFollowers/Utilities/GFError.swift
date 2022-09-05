//
//  GFError.swift
//  GitHubFollowers
//
//  Created by Oladele Abimbola on 8/22/22.
//

import Foundation

enum GFError: String, Error {
    case invalidUsername = "This username created an invalid request. Please try again"
    case unableToComplete = "Unable to complete your request. Please check your internet connection"
    case invalidResponse = "Invalid response from the server. Please try again."
    case invalidData = "The data received from the server is invalid. Please try again"
    case unableToFavorite = "There was an error adding this user to your favorite list. Please try again."
    case alreadyInFavorite = "You've already added this user to your favorite. You must REALLY like them!"
}

//
//  Constants.swift
//  CinemaGuide
//
//  Created by Mohamed Khaled on 30/11/2025.
//

import Foundation

enum Constants {
    static let baseUrl: String = "https://api.themoviedb.org/3"
    static let imageBaseURL = "https://image.tmdb.org/t/p/w500"
    static let apiKey = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String ?? ""
    static let accessKey = Bundle.main.object(forInfoDictionaryKey: "ACCESS_KEY") as? String ?? ""
}

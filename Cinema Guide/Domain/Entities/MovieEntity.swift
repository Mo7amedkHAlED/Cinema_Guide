//
//  MovieEntity.swift
//  CinemaGuide
//
//  Created by Mohamed Khaled Gomaa on 29/11/2025.
//

import Foundation

struct MovieEntity {
    let id: Int
    let posterURL: String
    let title: String
    let releaseDate: String
    let rating: String
    let overview: String
    let voteAverage: String
    let originalLanguage: String
}

extension MovieDTO {
    func toEntity() -> MovieEntity {
        return MovieEntity(
            id: id,
            posterURL: "\(Constants.imageBaseURL)\(posterPath ?? "")",
            title: title,
            releaseDate: releaseDate,
            rating: String(format: "%.1f ⭐️", voteAverage),
            overview: overview,
            voteAverage: "\(voteAverage)",
            originalLanguage: originalLanguage
        )
    }
}

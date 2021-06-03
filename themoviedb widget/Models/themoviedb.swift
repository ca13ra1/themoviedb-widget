//
//  themoviedb.swift
//  themoviedb widgetExtension
//
//  Created by cole cabral on 2021-05-17.
//

import Foundation

struct TMDb: Codable {
    let results: [Result]
}

struct Result: Codable {
    let backdropPath: String
    let genreIDS: [Int]
    let originalTitle: String?
    let posterPath: String
    let voteAverage: Double
    let overview: String
    let releaseDate, title: String?
    let name, originalName: String?
    let firstAirDate: String?

    enum CodingKeys: String, CodingKey {
        case backdropPath = "backdrop_path"
        case genreIDS = "genre_ids"
        case originalTitle = "original_title"
        case originalName = "original_name"
        case posterPath = "poster_path"
        case voteAverage = "vote_average"
        case overview
        case releaseDate = "release_date"
        case title
        case name
        case firstAirDate = "first_air_date"
    }
}

struct Genres: Codable {
    let genres: [Genre]
}

struct Genre: Codable {
    let id: Int
    let name: String
}

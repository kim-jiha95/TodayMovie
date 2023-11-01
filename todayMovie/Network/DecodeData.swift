//
//  DecodeData.swift
//  todayMovie
//
//  Created by Jihaha kim on 2023/11/01.
//
import Foundation

struct Movie: Codable {
    let adult: Bool
    let backdropPath: String?
    let belongsToCollection: String?
    let budget: Int
    let genres: [Genre]
    let homepage: String
    let id: Int
    let imdbId: String
    let originalLanguage: String
    let originalTitle: String
    let overview: String
    let popularity: Double
    let posterPath: String?
    let productionCompanies: [ProductionCompany]
    let productionCountries: [ProductionCountry]
    let releaseDate: String
    let revenue: Int
    let runtime: Int
    let spokenLanguages: [SpokenLanguage]
    let status: String
    let tagline: String
    let title: String
    let video: Bool
    let voteAverage: Double
    let voteCount: Int
    let videos: Videos

    struct Genre: Codable {
        let id: Int
        let name: String
    }

    struct ProductionCompany: Codable {
        let id: Int
        let logoPath: String?
        let name: String
        let originCountry: String
    }

    struct ProductionCountry: Codable {
        let iso3166_1: String
        let name: String
    }

    struct SpokenLanguage: Codable {
        let englishName: String
        let iso639_1: String
        let name: String
    }

    struct Videos: Codable {
        let results: [Video]

        struct Video: Codable {
            let iso639_1: String
            let iso3166_1: String
            let name: String
            let key: String
            let publishedAt: String
            let site: String
            let size: Int
            let type: String
            let official: Bool
            let id: String
        }
    }
}

//
//if let jsonData = jsonData.data(using: .utf8) {
//    do {
//        let movie = try JSONDecoder().decode(Movie.self, from: jsonData)
//        print("Movie title: \(movie.title)")
//        print("Overview: \(movie.overview)")
//        // Access other properties as needed
//    } catch {
//        print("Error decoding JSON: \(error)")
//    }
//} else {
//    print("Invalid JSON data")
//}

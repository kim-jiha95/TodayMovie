//
//  DecodeData.swift
//  todayMovie
//
//  Created by Jihaha kim on 2023/11/01.
//
import Foundation

struct Movie: Codable {
    let id: Int
    let title: String
    let overview: String
    let releaseDate: String
    let voteAverage: Double
    let voteCount: Int
    let backdropPath: String?
    let posterPath: String?
    let homepage: String?
    let genres: [Genre]
    let productionCompanies: [ProductionCompany]
    let productionCountries: [ProductionCountry]
    let spokenLanguages: [SpokenLanguage]
    let videos: Videos

    struct Genre: Codable {
        let id: Int
        let name: String
    }

    struct ProductionCompany: Codable {
        let id: Int
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
            let name: String
            let key: String
            let site: String
            let type: String
            let official: Bool
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

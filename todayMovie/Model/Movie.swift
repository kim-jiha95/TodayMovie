//
//  DecodeData.swift
//  todayMovie
//
//  Created by Jihaha kim on 2023/11/01.
//
import Foundation

/// 1. 이 데이터의 프로퍼티들이 다 쓰이나요?
/// -> 서버에서 정의한 모델을 그냥 정의한 모델
/// 1-1. 우리가 필요없는 데이터는 정의하지 않는다. -> 이 쪽이 더 편하고 간단
/// 1-2. 서버에서 내려주는 모델을 받고, 우리가 필요한 모델로 맵핑해준다.
///    -> Clean Architecture, 역할이 좀 더 명확하게 구분되긴 하지만, 오버헤드가 있고 복잡해진다.
///
/// 2. 모델에서는 스네이크 케이스를 쓰지 않아요.
/// -> CodingKeys
///
/// 3. Codable
/// -> Encodable & Decodable
/// 어떤 역할을 할 때 필요한지
///
/// 프로토콜이 어떤 요구사항을 요구하고 있고,
/// 어떤 경우에 요 함수를 사용하면 되는지
/// `func encode(to encoder: Encoder) throws`
///
/// Model: Encodable -> Encoder -> encode -> data -> decode -> Decoder -> Model: Decodable


struct MovieData: Codable {
    let page: Int
    let results: [Movie]
    let total_pages: Int
    let total_results: Int
}

struct Movie: Codable, Equatable, Identifiable, Hashable {
    let adult: Bool
    let backdrop_path: String?
    let genre_ids: [Int]
    let id: UUID = .init()
    let original_language: String
    let original_title: String
    let overview: String
    let popularity: Double
    let posterPath: String?
    let releaseDate: String
    let title: String
    let video: Bool
    let voteAverage: Double
    let voteCount: Int
    
    
    private enum CodingKeys: String, CodingKey {
        case adult = "adult"
        case backdrop_path = "backdrop_path"
        case genre_ids = "genre_ids"
//        case id = "id"
        case original_language = "original_language"
        case original_title = "original_title"
        case overview = "overview"
        case popularity = "popularity"
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title = "title"
        case video = "video"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}

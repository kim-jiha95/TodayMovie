//
//  TodayMovieResult.swift
//  todayMovie
//
//  Created by Jihaha kim on 2023/11/19.
//

import Foundation

struct TodayMovieResult: Decodable {
    let TodayMovieResultType: String                   // 박스오피스 종류
    let showRange: String                       // 조회 일자 범위
    let dailyTodayMovieResultList: [DailyTodayMovieResult]    // 일별 박스오피스 목록
    
    private enum CodingKeys: String, CodingKey {
        case TodayMovieType = "TodayMovieType"
        case showRange
        case dailyTodayMovieList
    }
}

//
//  codingKey_example.swift
//  todayMovie
//
//  Created by Jihaha kim on 2023/11/09.
//

import Foundation




struct Response: Codable {
    let resultCount: Int
    let results: [Track_]
}

struct Track_: Codable {
    let title: String
    let artistName: String
    let isStreamable: Bool
}

let jsonData_ = """
{
  "resultCount": 50,
  "results": [{
    "artistName" : "Dua Lipa",
    "isStreamable" : true,
    "title" : "New Rules"
  }]
}
""".data(using: .utf8)!

do {
    let decoder = JSONDecoder()
    let data = try decoder.decode(Response.self, from: jsonData_)
    print(data.results[0]) // Track(title: "New Rules", artistName: "Dua Lipa", isStreamable: true)
} catch {
    print(error)
}

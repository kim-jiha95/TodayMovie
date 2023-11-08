//
//  codable_example.swift
//  todayMovie
//
//  Created by Jihaha kim on 2023/11/09.
//

import Foundation


//encoding
struct Track: Codable {
  let title: String
  let artistName: String
  let isStreamable: Bool
}

let sampleInput = Track(title: "New Rules", artistName: "Dua Lipa", isStreamable: true)

do {
    let encoder = JSONEncoder()
    let data = try encoder.encode(sampleInput)
    print(data) // 65 Bytes
} catch {
    print(error)
}

//decoding
let jsonData = """
{
  "artistName" : "Dua Lipa",
  "isStreamable" : true,
  "title" : "New Rules"
}
""".data(using: .utf8)!


do {
    let decoder = JSONDecoder()
    let data = try decoder.decode(Track.self, from: jsonData)
    print(data) // Track(title: "New Rules", artistName: "Dua Lipa", isStreamable: true)
    print(data.title) // New Rules
} catch {
    print(error)
}

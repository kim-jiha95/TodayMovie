//
//  Sample.swift
//  todayMovie
//
//  Created by havi.log on 2023/11/02.
//

import Foundation

/*
struct Sample: Codable { // Movie -> Codable == Encodable & Decodable
    let kamelCase: String
    let title: String
    let id: Int
    
    private enum CodingKeys: String, CodingKey {
        case kamelCase = "kamelCase"
        case title
        case id
    }
}

/// Model: Encodable -> Encoder -> encode -> data -> decode -> Decoder -> Model: Decodable

let sample: Sample = .init(kamelCase: "123", title: "영화", id: 1)
do {
    let data = try JSONEncoder().encode(sample)
    /**
     {
        "snake_case": "123",
        "kamelCase": "123",
        "title": "영화",
        "id": 1,
     }
     */
    let sample = try JSONDecoder().decode(Sample.self, from: data)
}
catch {
    
}

// app Diary { }
// tab A, B, C

// 일기에 대한 CRUD는 모두 이 DiaryManager를 통해서 하고싶다.
// 앱에 지금 표시되는 일기를 모두 여기서 관리
// 싱글톤 객체
class DiaryManager {
    static let shared: DiaryManager = .init()
    private init() { }
}

struct A {
    let manager: DiaryManager = .shared
}
struct B {
    let manager: DiaryManager = .shared
}
struct C {
    let manager: DiaryManager = .shared
}

let a = A()
let b = B()
let c = C()
    
// stack    heap
//   a  ----->
//   b  -> shared(0x0001)
//   c  ----->
*/

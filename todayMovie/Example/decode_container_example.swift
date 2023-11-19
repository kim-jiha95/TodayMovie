////
////  decode_container_example.swift
////  todayMovie
////
////  Created by Jihaha kim on 2023/11/09.
////
//
//import Foundation
//
//struct ConfirmedCase {
//    let date: String
//    let numbers: Int
//    
//    enum CodingKeys: String, CodingKey {
//        case date
//        case numbers = "numberOfConfirmedCase"
//    }
//}
//
//extension ConfirmedCase: Decodable {
//    init(from decoder: Decoder) throws {
//        // CodingKeys의 키를 사용하는 컨테이너 추출
//        // try , try?  차이
//        // decode, decodeIfPresent(<#T##T#>) 차이
//        let container = try decoder.container(keyedBy: CodingKeys.self)
////        self.date = try container.decode(String.self, forKey: .date)
//        self.date = try container.decodeIfPresent(String.self, forKey: .date)!
//        self.numbers = try container.decode(Int.self, forKey: .numbers)
//    }
//}

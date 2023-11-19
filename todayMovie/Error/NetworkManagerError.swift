//
//  NetworkManagerError.swift
//  todayMovie
//
//  Created by Jihaha kim on 2023/11/19.
//

import Foundation

enum NetworkManagerError: Error {
    case cannotLoadFromNetwork
    case failureHttpResponse
    case failureJsonDecode
    case unknown
}

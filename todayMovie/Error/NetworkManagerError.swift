//
//  NetworkManagerError.swift
//  todayMovie
//
//  Created by Jihaha kim on 2023/11/19.
//

import Foundation

enum NetworkError: Error {
    case noConnection
    case timeout
    case other(String)

    var localizedDescription: String {
        switch self {
        case .noConnection:
            return "No network connection."
        case .timeout:
            return "Request timed out."
        case .other(let description):
            return "Network error: \(description)"
        }
    }
}

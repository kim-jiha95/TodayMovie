//
//  NetworkError.swift
//  todayMovie
//
//  Created by 한상진 on 11/20/23.
//

import Foundation

enum JHNetworkError: Error {
    
    enum ParameterEncodingError: Error {
        case missingURL
        case invalidJSON
        case jsonEncodingFailed
    }
    
    case invalidURLString
    case endpointCongifureFailed
    case parameterEnocdingFailed(ParameterEncodingError)
}

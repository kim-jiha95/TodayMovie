//
//  JHRequest.swift
//  todayMovie
//
//  Created by 한상진 on 11/20/23.
//

import Foundation

/// "Content-Type: application/json"
/// `["Content-Type": "application/json"]`
typealias HTTPHeaders = [String: String]

/// "CustomeParam: 0"
/// "CustomeParam: 다른 값들"
typealias Parameters = [String: Any]

enum HTTPMethod: String {
    case get
    case post
    case put
    case delete
    /// 나머지... (patch)
    
    var uppercasedValue: String {
        return self.rawValue.uppercased() // get -> GET
    }
}

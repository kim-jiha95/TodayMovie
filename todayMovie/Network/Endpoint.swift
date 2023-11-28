//
//  Endpoint.swift
//  todayMovie
//
//  Created by 한상진 on 11/20/23.
//

import Foundation

protocol URLRequestConfigurable {
    var urlString: String { get }
    var path: String? { get }
    var method: HTTPMethod { get }
    var headers: HTTPHeaders? { get }
    var encoder: ParameterEncodable { get }
    
    func asURLRequest() throws -> URLRequest
}

struct Endpoint { }
extension Endpoint {
    enum Movie {
        case topRated(_ parameters: Parameters)
    }
}

extension Endpoint.Movie: URLRequestConfigurable {
    var urlString: String {
        switch self {
        case .topRated: return "https://api.themoviedb.org/3/movie"
        }
    }
    
    var path: String? {
        switch self {
        case .topRated: return "/top_rated"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .topRated: return .get
        }
    }
    
    var headers: HTTPHeaders? {
        switch self {
        case .topRated: return ["Content-Type": "application/json"]
        }
    }
    
    var encoder: ParameterEncodable {
        switch self {
        case .topRated: return URLEncoding()
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        guard var url: URL = URL(string: self.urlString) else { 
            throw JHNetworkError.invalidURLString 
        }
        
        if let path { url.append(path: path) }
        
        var urlRequest: URLRequest = .init(url: url)
        urlRequest.httpMethod = self.method.uppercasedValue
        urlRequest.allHTTPHeaderFields = self.headers
        
        switch self {
        case let .topRated(parameters):
            let encodedRequest = try encoder.encode(request: urlRequest, with: parameters)
            return encodedRequest
        }
    }
}

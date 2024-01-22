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
        static let baseURL: String = "https://api.themoviedb.org/3"
        case topRated(page: Int)
        case search(query: String, page: Int)
    }
}

extension Endpoint.Movie: URLRequestConfigurable {
    
    var urlString: String {
        return Endpoint.Movie.baseURL
    }
    
    var path: String? {
        switch self {
        case .topRated: return "/movie/top_rated"
        case .search: return "/search/movie"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .topRated: return .get
        case .search: return .get
        }
    }
    
    var headers: HTTPHeaders? {
        switch self {
        case .topRated: return ["Content-Type": "application/json"]
        case .search: return ["Content-Type": "application/json"]
        }
    }
    
    var encoder: ParameterEncodable {
        switch self {
        case .topRated: return URLEncoding()
        case .search: return URLEncoding()
        }
    }
    
    var parameters: Parameters? {
        var commonParameters: Parameters = [
            "api_key": NetworkConstant.tmdbAPIKey,
            "language": "ko-KR",
            "append_to_response": "videos",
        ]
        switch self {
        case let .topRated(page):
            commonParameters["page"] = "\(page)"
        case let .search(query, page):
            commonParameters["page"] = "\(page)"
            commonParameters["query"] = "\(query)"
        }
        return commonParameters
    }
    
    func asURLRequest() throws -> URLRequest {
        guard var url: URL = URL(string: self.urlString) else { 
            throw JHNetworkError.invalidURLString 
        }
        
        if let path { url.append(path: path) }
        
        var urlRequest: URLRequest = .init(url: url)
        urlRequest.httpMethod = self.method.uppercasedValue
        urlRequest.allHTTPHeaderFields = self.headers
        
        let encodedRequest = try encoder.encode(request: urlRequest, with: parameters)
        return encodedRequest        
    }
}


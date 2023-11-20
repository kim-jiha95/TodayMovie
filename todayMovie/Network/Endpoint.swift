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
    enum Home {
        case initialize(parameters: Parameters)
    }
}

extension Endpoint.Home: URLRequestConfigurable {
    var urlString: String {
        switch self {
        case .initialize: return "http:www.naver.com"
        }
    }
    
    var path: String? {
        switch self {
        case .initialize: return "/home"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .initialize: return .get
        }
    }
    
    var headers: HTTPHeaders? {
        switch self {
        case .initialize: return ["Content-Type": "application/json"]
        }
    }
    
    var encoder: ParameterEncodable {
        switch self {
        case .initialize: return URLEncoding()
        }
    }
    
    func asURLRequest(parameters: Parameters) throws -> URLRequest {
        guard var url: URL = URL(string: self.urlString) else { 
            throw JHNetworkError.invalidURLString 
        }
        if let path { url.appendPathExtension(path) }
        
        var urlRequest: URLRequest = .init(url: url)
        urlRequest.httpMethod = self.method.uppercasedValue
        urlRequest.allHTTPHeaderFields = self.headers
        
        switch self {
        case let .initialize(parameters):
            let encodedRequest = try encoder.encode(request: urlRequest, with: parameters)
            return encodedRequest
        }
    }
}

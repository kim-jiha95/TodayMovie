//
//  ParameterEncoding.swift
//  todayMovie
//
//  Created by 한상진 on 11/20/23.
//

import Foundation

protocol ParameterEncodable {
    /// URLRequest, "https:www.naver.com"
    /// ["page": "1"] // parameter
    /// 
    /// -> "https:www.naver.com/page=1"
    func encode(
        request: URLRequest,
        with parameters: Parameters?
    ) throws -> URLRequest
}

struct URLEncoding: ParameterEncodable {
    func encode(
        request: URLRequest,
        with parameters: Parameters?
    ) throws -> URLRequest {
        var request = request
        guard let parameters else { return request }
        guard let url = request.url else {
            throw JHNetworkError.parameterEnocdingFailed(.missingURL)
        }
        if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) {
            urlComponents.queryItems = parameters.compactMap { key, value in
                return URLQueryItem(name: key, value: "\(value)")
            }
            request.url = urlComponents.url 
        }
        return request
    }
}

struct JSONEncoding: ParameterEncodable {
    func encode(
        request: URLRequest,
        with parameters: Parameters?
    ) throws -> URLRequest {
        var request = request
        guard let parameters else { return request }
        guard JSONSerialization.isValidJSONObject(parameters) else {
            throw JHNetworkError.parameterEnocdingFailed(.invalidJSON)
        }
        do {
            let data: Data = try JSONSerialization.data(withJSONObject: parameters)
            request.httpBody = data
        }
        catch {
            throw JHNetworkError.parameterEnocdingFailed(.jsonEncodingFailed)
        }
        return request
    }
}

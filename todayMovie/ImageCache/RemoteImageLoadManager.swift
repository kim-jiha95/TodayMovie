//
//  ImageLoadManager.swift
//  todayMovie
//
//  Created by 한상진 on 1/29/24.
//

import UIKit

/// let manager = RemoteImageLoadManager.shared
/// let manager2 = RemoteImageLoadManager.shared
/// 
/// manager.count == 1
/// manager.count += 1
/// 
/// manager1.count == 2
/// manager2.count == 2
/// 
/// data -> heap
/// 
/// 값 타입 -> stack -> 작은 영역
/// 참조 타입 -> heap -> 큰 영역
/// 
/// 싱글톤 == 하나의 인스턴스만 가지고 있겠다.
/// Single == 1개 솔로
final class RemoteImageLoadManager: ImageLoadable {
    
    func loadImage(url: String) async throws -> UIImage? {
        guard let url = URL(string: url) else {
            throw ImageLoadError.invalidURL
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            guard let image = UIImage(data: data) else {
                throw ImageLoadError.decodingFailed
            }
            
            return image
        } catch {
            throw ImageLoadError.missingData
        }
    }
    
    
    static let shared = RemoteImageLoadManager()
    private var latestTask: URLSessionDataTask?
    
    private let session: URLSession = {
        let sessionConfiguration = URLSessionConfiguration.default
        return URLSession(configuration: sessionConfiguration)
    }()
    
    private init() {}
    
    func cancelDownloadTask() {
        latestTask?.cancel()
    }
}

enum ImageLoadError: Error {
    case invalidURL
    case decodingFailed
    case missingData
    case downloadFailed(Error)
}

extension ImageLoadable {
    func loadImage(url: String, using session: URLSession = .shared) async throws -> UIImage? {
        guard let url = URL(string: url), url.absoluteString.hasPrefix("https") else {
            throw ImageLoadError.invalidURL
        }
        
        if let cachedResponse = session.configuration.urlCache?.cachedResponse(for: URLRequest(url: url)),
           let image = UIImage(data: cachedResponse.data) {
            return image
        }
        
        do {
            let (data, response) = try await session.data(from: url)
            
            guard let image = UIImage(data: data) else {
                throw ImageLoadError.decodingFailed
            }
            
            let cachedResponse = CachedURLResponse(response: response, data: data)
            session.configuration.urlCache?.storeCachedResponse(cachedResponse, for: URLRequest(url: url))
            
            return image
        } catch {
            throw ImageLoadError.downloadFailed(error)
        }
    }
}

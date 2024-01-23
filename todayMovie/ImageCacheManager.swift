//
//  ImageCacheManager.swift
//  todayMovie
//
//  Created by Jihaha kim on 2023/12/06.
//

import UIKit
import Combine

final class ImageLoadManager {
    static let shared = ImageLoadManager()
    
    private var latestTask: URLSessionDataTask?
    let session: URLSession = {
        let sessionConfiguration: URLSessionConfiguration = {
            let configuration = URLSessionConfiguration.default
            configuration.requestCachePolicy = .reloadIgnoringCacheData
            return configuration
        }()
        let session =  URLSession(configuration: sessionConfiguration)
        return session
    }()
    
    private init() {}
    
    func cancelDownloadTask() {
        latestTask?.cancel()
    }
    
    func loadImage(url urlString: String, completion: @escaping (UIImage?) -> Void) {
        guard urlString.contains("https"), let url = URL(string: urlString) else {
            let defaultImage = UIImage(named: "https://picsum.photos/100/100")
                    completion(defaultImage)
            return
        }
        
        latestTask = session.dataTask(with: url, completionHandler: { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Error downloading image: \(error)")
                    completion(nil)
                    return
                }

                guard let data = data, let image = UIImage(data: data) else {
                    print("Error converting data to image")
                    completion(nil)
                    return
                }
                
                completion(image)
            }
        })
        latestTask?.resume()
    }
}

// 이미지 캐시를 담당하는 actor
actor ImageCacheManager {
    static let shared = ImageCacheManager()
        
        private let cache = NSCache<NSString, UIImage>()
        private let fileManager = FileManager.default
        private let cacheDirectoryURL: URL
        
        private init() {
            let urls = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)
            cacheDirectoryURL = urls[0].appendingPathComponent("imageCache")
            try? fileManager.createDirectory(at: cacheDirectoryURL, withIntermediateDirectories: true)
        }

    func loadCachedImage(for key: String) async -> UIImage? {
        let itemURL = NSString(string: key)
        
        if let image = cache.object(forKey: itemURL) {
            return image
        }
        
        let fileURL = cacheDirectoryURL.appendingPathComponent(key)
        if let data = try? Data(contentsOf: fileURL), let image = UIImage(data: data) {
            return image
        }
        
        return nil
    }
    
    func cacheImage(_ image: UIImage, for key: String) async {
        let itemURL = NSString(string: key)
        
        cache.setObject(image, forKey: itemURL)
        
        let fileURL = cacheDirectoryURL.appendingPathComponent(key)
        if let data = image.jpegData(compressionQuality: 1.0) {
            try? data.write(to: fileURL)
        }
    }
}



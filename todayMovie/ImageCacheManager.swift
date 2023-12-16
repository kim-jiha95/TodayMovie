//
//  ImageCacheManager.swift
//  todayMovie
//
//  Created by Jihaha kim on 2023/12/06.
//

import UIKit
import Combine

final class ImageCacheManager {
    static let shared = ImageCacheManager()
    
    private let cache = NSCache<NSString, UIImage>()
    
    private var latestTask: URLSessionDataTask?
    private let session: URLSession = {
        let sessionConfiguration: URLSessionConfiguration = {
            let configuration = URLSessionConfiguration.default
            configuration.requestCachePolicy = .reloadIgnoringCacheData
            return configuration
        }()
        let session =  URLSession(configuration: sessionConfiguration)
        return session
    }()
    private init() {}
    
    func loadCachedData(for key: String) -> UIImage? {
        let itemURL = NSString(string: key)
        return cache.object(forKey: itemURL)
    }
    
    func setCacheData(of image: UIImage, for key: String) {
        let itemURL = NSString(string: key)
        cache.setObject(image, forKey: itemURL)
    }
    
    func cancelDownloadTask() {
        latestTask?.cancel()
    }
    
    func setImage(url urlString: String, completion: @escaping (UIImage?) -> Void) {
        guard urlString.contains("https"), let url = URL(string: urlString) else {
            let defaultImage = UIImage(named: "https://picsum.photos/100/100")
                    completion(defaultImage)
            return 
        }
        /// 얘도 네트워크쪽 코드를 사용해서 쓰면 좋을 것 같긴 한데...
        latestTask = session.dataTask(with: url, completionHandler: { data, response, error in
            DispatchQueue.main.async {
                /// 저장하고 나서 completion? 
                if let data, let image = UIImage(data: data) {
                    completion(image)
                } else {
                    completion(nil)
                }
            }
        })
        latestTask?.resume()
    }
}

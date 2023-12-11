//
//  ImageCacheManager.swift
//  todayMovie
//
//  Created by Jihaha kim on 2023/12/06.
//

import UIKit
import Combine

final class ImageCacheManager {
    
    /// 숙제5. shared(싱글톤)을 썼을 때의 장단점
    static let shared = ImageCacheManager()
    
    private let cache = NSCache<NSString, UIImage>()
    
    /// 숙제6. latestTask를 취소 하고, 안하고의 차이
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
            // 여기도 default이미지를 주거나, error를 throw하거나
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

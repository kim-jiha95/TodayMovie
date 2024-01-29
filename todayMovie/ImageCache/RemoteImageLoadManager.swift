//
//  ImageLoadManager.swift
//  todayMovie
//
//  Created by 한상진 on 1/29/24.
//

import UIKit

final class RemoteImageLoadManager: ImageLoadable {
    static let shared = RemoteImageLoadManager()
    
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

//
//  ImageLoader.swift
//  todayMovie
//
//  Created by 한상진 on 1/29/24.
//

import UIKit

protocol ImageCachable {
    func loadCachedImage(for key: String) -> UIImage?
    func cacheImage(_ image: UIImage, for key: String) 
}

protocol ImageLoadable {
    func loadImage(url: String, completion: @escaping (UIImage?) -> Void)
}

final class ImageLoader {
    private let cacheManager: ImageCacheManager
    private let loadManager: any ImageLoadable
    
    init(
        cacheManager: ImageCacheManager = ImageCacheManager(),
        loadManager: any ImageLoadable = RemoteImageLoadManager.shared
    ) {
        self.cacheManager = cacheManager
        self.loadManager = loadManager
    }
    
    func loadImage(with url: String,cacheType: ImageCachType = .all, completion: @escaping (UIImage?) -> Void) {
        if let cachedImage = self.cacheManager.loadCachedImage(for: url, cacheType: cacheType) {
            completion(cachedImage)
        } else {
            self.loadManager.loadImage(url: url) { image in
                if let image = image {
                    self.cacheManager.cacheImage(image, for: url, cacheType: cacheType)
                }
                completion(image)
            }
        }
    }
}

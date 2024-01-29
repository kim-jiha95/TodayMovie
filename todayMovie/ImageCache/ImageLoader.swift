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
    
    func loadImage(with url: String, completion: @escaping (UIImage?) -> Void) {
        Task {
//            if let cachedImage = await self.cacheManager.loadCachedImage(for: url) {
//                completion(cachedImage)
//            } else {
                self.loadManager.loadImage(url: url) { image in
//                    if let image = image {
//                        Task {
//                            await self.cacheManager.cacheImage(image, for: url)
//                        }
//                    }
                    completion(image)
                }
//            }
        }
    }
}

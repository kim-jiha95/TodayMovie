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
    //    func loadImage(url: String, completion: @escaping (UIImage?) -> Void)
    func loadImage(url: String) async throws -> UIImage?
}

/// 면접관:
/// any protocol에 의존하도록 작성하셨는데, 
/// 왜 이렇게 하셨나요?
/// 
/// 1. any에 대해 설명
/// 1-1. any vs some 의 차이
/// 1-2. any를 사용한 이유
/// 
/// 2. 프로토콜로 추상화를 한 이유
/// 2-1. Open-Closed Principle
/// 2-2. Dependency Inversion Principle
/// 
/// 3. Dependency Injection
/// 3-1. Test코드를 작성할 때 Mock객체를 넣어줌으로써 외부 의존성을 제어
/// 
/// 쇼생크 탈출 -> ImageLoader 1 -> remote -> 캐시 저장
/// 대부 -> ImageLoader 2 -> remote -> 캐시 저장 -> 안보이게되면 -> 셀은 재사용 -> ImageLoader2 없어지겠죠 -> ImageCacheManager deinit
/// 대부2 -> ImageLoader 3 -> remote -> 캐시 저장
final class ImageLoader {
    private let cacheManager: any ImageCacheManagable
    private let loadManager: any ImageLoadable // stored property
    // var test: Bool { return Bool.random() } // computed property
    
    init(
        cacheManager: any ImageCacheManagable = ImageCacheManager.shared,
        loadManager: any ImageLoadable = RemoteImageLoadManager.shared
    ) {
        self.cacheManager = cacheManager
        self.loadManager = loadManager
    }
    
    func loadImage(with url: String, cacheType: ImageCachType = .all) async throws -> UIImage? {
        if let cachedImage = self.cacheManager.loadCachedImage(for: url, cacheType: cacheType) {
            return cachedImage
        } else {
            let image = try await loadManager.loadImage(url: url)
            
            if let image {
                self.cacheManager.cache(image: image, key: url, cacheType: cacheType)
            }
            return image
        }
    }
}


struct Home {
    /// cache -> Memory
    //    func test() {
    //        ImageLoader(cacheManager: ImageCacheManager()).loadImage(with: "home") { image in
    //            
    //        }
    //    }
}

struct Detail {
    struct DetailCacheManager: ImageCacheManagable {
        func cache(image: UIImage, key: String, cacheType: ImageCachType) {
            
        }
        
        func loadCachedImage(for key: String, cacheType: ImageCachType) -> UIImage? {
            return nil
        }
    }
    
    /// cache -> Disk
    
    func test() {
        let imageLoader = ImageLoader(cacheManager: DetailCacheManager())
        Task {
            do {
                let image = try await imageLoader.loadImage(with: "home")
                // Use the image here (e.g., update UI)
                if let image = image {
                    // ... use the image
                } else {
                    // Handle the case where image is nil (e.g., loading failed)
                }
            } catch {
                print("Error loading image: \(error)")
            }
        }
    }
}

//
//  ImageCacheManager.swift
//  todayMovie
//
//  Created by Jihaha kim on 2023/12/06.
//

import UIKit

struct MemoryStorage: ImageCachable {
    private let cache = NSCache<NSString, UIImage>()
    func loadCachedImage(for key: String) -> UIImage? {
        let itemURL = NSString(string: key)
        if let image = cache.object(forKey: itemURL) {
            return image
        } else {
            return nil
        }
    }
    
    func cacheImage(_ image: UIImage, for key: String) {
        let itemURL = NSString(string: key)
        cache.setObject(image, forKey: itemURL)
    }
}

struct FileStorage: ImageCachable {
    private let fileManager = FileManager.default
    private let cacheDirectoryURL: URL
    
    init() {
        let urls = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)
        cacheDirectoryURL = urls[0].appendingPathComponent("imageCache")
        try? fileManager.createDirectory(at: cacheDirectoryURL, withIntermediateDirectories: true)
    }
    
    func loadCachedImage(for key: String) -> UIImage? {
        let fileURL = cacheDirectoryURL.appendingPathComponent(key)
        if let data = try? Data(contentsOf: fileURL), 
            let image = UIImage(data: data) {
            return image
        } else {
            return nil
        }
    }
    
    func cacheImage(_ image: UIImage, for key: String) {
        let fileURL = cacheDirectoryURL.appendingPathComponent(key)
        if let data = image.jpegData(compressionQuality: 1.0) {
            try? data.write(to: fileURL)
        }
    }
}

struct ImageCachType: OptionSet {
    let rawValue: Int
    static let memory: ImageCachType = .init(rawValue: 1 << 0) // 2^0 == 1
    static let disk: ImageCachType = .init(rawValue: 1 << 1) // 2^1 == 2
    static let none: ImageCachType = []
    static let all: ImageCachType = [.memory, .disk]
}

protocol ImageCacheManagable {
    func cache(image: UIImage, key: String, cacheType: ImageCachType)
    func loadCachedImage(for key: String, cacheType: ImageCachType) -> UIImage?
}

// FIXME: actor 로 구현하기
final class ImageCacheManager: ImageCacheManagable {
    static let shared: ImageCacheManager = .init()
    
    private let memoryStorage: any ImageCachable
    private let diskStorage: any ImageCachable
    
    init(
        memoryStorage: any ImageCachable = MemoryStorage(),
        diskStorage: any ImageCachable = FileStorage()
    ) {
        self.memoryStorage = memoryStorage
        self.diskStorage = diskStorage
    }
    
    func cache(image: UIImage, key: String, cacheType: ImageCachType) {
        switch cacheType {
        case .none:
            return
            
        case .memory:
            memoryStorage.cacheImage(image, for: key)
            
        case .disk:
            diskStorage.cacheImage(image, for: key)
            
        case .all:
            memoryStorage.cacheImage(image, for: key)
            diskStorage.cacheImage(image, for: key)
            
        default:
            return
        }
    }
    func loadCachedImage(for key: String, cacheType: ImageCachType) -> UIImage? {
        switch cacheType {
        case .none:
            return nil
            
        case .memory:
            return memoryStorage.loadCachedImage(for: key)
            
        case .disk:
            return diskStorage.loadCachedImage(for: key)
            
        case .all:
            if let image = memoryStorage.loadCachedImage(for: key) {
                return image
            }
            return diskStorage.loadCachedImage(for: key)
            
        default:
            return nil
        }
    }
}

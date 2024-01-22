//
//  UIImageView+extension.swift
//  todayMovie
//
//  Created by Jihaha kim on 2023/12/06.
//

import UIKit
import OSLog

extension UIImageView {
    
    private func indicator() -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.tintColor = .white
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }
    
    final class ImageLoader {
        private let cacheManager = ImageCacheManager.shared
        private let loadManager = ImageLoadManager.shared


        func loadImage(with url: String, completion: @escaping (UIImage?) -> Void) {
            Task {
                if let cachedImage = await self.cacheManager.loadCachedImage(for: url) {
                    completion(cachedImage)
                } else {
                    self.loadManager.loadImage(url: url) { image in
                        if let image = image {
                            Task {
                                await self.cacheManager.cacheImage(image, for: url)
                            }
                        }
                        completion(image)
                    }
                }
            }
        }
    }
    
    func setImage(with url: String) {
        let indicator = self.indicator()
        addSubview(indicator)
        indicator.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        indicator.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        ImageLoader().loadImage(with: url) { [weak self] image in
            if let image = image {
                // Set the image and stop the indicator
                self?.image = image
            }
            indicator.stopAnimating()
        }
    }

}

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

        func loadImage(with url: String, completion: @escaping (UIImage?) -> Void) {
            if let cachedImage = cacheManager.loadCachedData(for: url) {
                completion(cachedImage)
            } else {
                cacheManager.setImage(url: url) { image in
                    completion(image)
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

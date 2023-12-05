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
    
    func setImage(with url: String) {
        let indicator = indicator()
        addSubview(indicator)
        indicator.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        indicator.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        if let cachedImage = ImageCacheManager.shared.loadCachedData(for: url) {
            self.image = cachedImage
        } else {
            ImageCacheManager.shared.setImage(url: url) { [weak self] image in
                guard let image else {
                    return
                }
                ImageCacheManager.shared.setCacheData(of: image, for: url)
                self?.image = image
            }
        }
        indicator.stopAnimating()
    }
}

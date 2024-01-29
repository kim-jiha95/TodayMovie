//
//  UIImageView+extension.swift
//  todayMovie
//
//  Created by Jihaha kim on 2023/12/06.
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
        let indicator = self.indicator()
        addSubview(indicator)
        indicator.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        indicator.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        ImageLoader().loadImage(with: url) { [weak self] image in
            DispatchQueue.main.async {
                
                if let image = image {
                    // Set the image and stop the indicator
                    self?.image = image
                }
                indicator.stopAnimating()
            }
        }
    }
    
    // SRP
    // 인디케이터 돌리기
    // 이미지 세팅
    func setImage(urlString: String) {
        // 캐시된 이미지 or 리모트 이미지를 가져와서 넣어주는 객체
        // 이미지를 가져와서 self.image에 넣어주는 로직
    }
}


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
    
    func setImage(with url: String) async {
        let indicator = self.indicator()
        addSubview(indicator)
        indicator.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        indicator.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        do {
            let image = try await ImageLoader().loadImage(with: url)
            if let image {
                self.image = image
            }
            indicator.stopAnimating()
        } catch {
            print("Error loading image: \(error)")
        }
    }
}


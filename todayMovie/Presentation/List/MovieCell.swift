//
//  MovieCell.swift
//  todayMovie
//
//  Created by Jihaha kim on 2023/11/30.
//

import UIKit

/// swift custom cell programmatically
final class MovieCell: UITableViewCell {
    
    static let cellId = "CellId" // protocol
    
    private let thunbnailImageView: UIImageView = .init()
    private let titleLabel: UILabel = .init()
    private let descriptionLabel: UILabel = .init()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Error")
    }
    private lazy var posterView: UIImageView = {
        let imageView = UIImageView()
        imageView.widthAnchor.constraint(equalToConstant: 90).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 110).isActive = true
        imageView.backgroundColor = .darkGray
        return imageView
    }()

    // 이    타이틀
    // 미지  디스크립션
    private func configureUI() {
        let hStack: UIStackView = .init()
        hStack.axis = .horizontal
        hStack.alignment = .center
        hStack.distribution = .fill
        hStack.translatesAutoresizingMaskIntoConstraints = false
        
        let vStack: UIStackView = .init()
        vStack.axis = .vertical
        vStack.alignment = .fill
        vStack.distribution = .fillEqually
        vStack.translatesAutoresizingMaskIntoConstraints = false
        
        hStack.addArrangedSubview(thunbnailImageView)
        thunbnailImageView.translatesAutoresizingMaskIntoConstraints = false
        hStack.addArrangedSubview(vStack)
        
        vStack.addArrangedSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        vStack.addArrangedSubview(descriptionLabel)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(hStack)
        NSLayoutConstraint.activate([
            thunbnailImageView.widthAnchor.constraint(equalToConstant: 100),
            thunbnailImageView.heightAnchor.constraint(equalToConstant: 100),
            hStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            hStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            hStack.topAnchor.constraint(equalTo: contentView.topAnchor),
            hStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
    
    func configure(with movie: Movie) {
        posterView.setImage(with: movie.posterPath ?? "")
        // TODO: Image 처리
        // posterPath를 가지고 API를 찔러서 이미지 가져오기
        // image cache 에 대해 알아보고 구현하기
        titleLabel.text = movie.title
        descriptionLabel.text = "\(movie.popularity)"
    }
    func reset() {
        ImageCacheManager.shared.cancelDownloadTask()
    }
}

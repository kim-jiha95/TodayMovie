//
//  MovieCell.swift
//  todayMovie
//
//  Created by Jihaha kim on 2023/11/30.
//

import UIKit

/// swift custom cell programmatically
final class MovieCell: UITableViewCell {
    
    static let cellId = "CellId" // 숙제8. protocol
    
    private let thunbnailImageView: UIImageView = .init() // 요기에 넣어주세요 이미지
    private let rankLabel: UILabel = {
        let rankLabel: UILabel = .init()
        rankLabel.font = UIFont.boldSystemFont(ofSize: 18)
        rankLabel.textColor = .black
        rankLabel.textAlignment = .center
        rankLabel.translatesAutoresizingMaskIntoConstraints = false
        return rankLabel
    }()
    /// label을 정의한다.
    /// font, textColor는 거의 무조건 정의가 필요해요.
    private let titleLabel: UILabel = .init()
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = UIFont.boldSystemFont(ofSize: 13)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        thunbnailImageView.image = .none
        rankLabel.text = .none
        titleLabel.text = .none
        descriptionLabel.text = .none
        ImageCacheManager.shared.cancelDownloadTask() // 숙제8. 얘도 고쳐주세요
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

    /// cell에 property가 어디에 어떻게 놓일지에 대한
    /// UI제약조건을 잡아주는 역할을 하는 함수
    private func configureUI() {
        let hStack: UIStackView = .init()
        hStack.axis = .horizontal
        hStack.alignment = .center
        hStack.distribution = .fill
        hStack.spacing = 5
        hStack.translatesAutoresizingMaskIntoConstraints = false
        
        let vStack: UIStackView = .init()
        vStack.axis = .vertical
        vStack.alignment = .fill
        vStack.distribution = .fillEqually
        vStack.translatesAutoresizingMaskIntoConstraints = false
        
        hStack.addArrangedSubview(rankLabel)
        hStack.addArrangedSubview(vStack)
        vStack.addArrangedSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        vStack.addArrangedSubview(descriptionLabel)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(hStack)
        rankLabel.setContentHuggingPriority(.required, for: .horizontal)
        rankLabel.setContentCompressionResistancePriority(.required, for: .horizontal)

        NSLayoutConstraint.activate([
            hStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            hStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            hStack.topAnchor.constraint(equalTo: contentView.topAnchor),
            hStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
    
    
    func configure(with movie: Movie, briefRank: Int) {
        let defaultImage = "https://picsum.photos/100/100"
        if let path = movie.posterPath {
            posterView.setImage(with: path)
        } else {
            posterView.setImage(with: defaultImage)
        }
        titleLabel.text = movie.title
        descriptionLabel.text = "평점: " + movie.voteAverage.formatted
        rankLabel.text = "\(briefRank + 1)" + "위"
    }
}

fileprivate extension Double {
    var formatted: String { return .init(format: "%.1f", self) }
}

//
//  MovieCell.swift
//  todayMovie
//
//  Created by Jihaha kim on 2023/11/30.
//

import UIKit

final class MovieCell: UITableViewCell {
    
    static let cellId = "CellId" // 숙제8. protocol
    
    private let thunbnailImageView: UIImageView = {
        let view = UIImageView()
        view.heightAnchor.constraint(equalToConstant: 100).isActive = false
        view.widthAnchor.constraint(equalToConstant: 100).isActive = false
        return view
    }()
    private let rankLabel: UILabel = {
        let rankLabel: UILabel = .init()
        rankLabel.font = UIFont.boldSystemFont(ofSize: 18)
        rankLabel.textColor = .black
        rankLabel.textAlignment = .center
        rankLabel.translatesAutoresizingMaskIntoConstraints = false
        return rankLabel
    }()
  
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
        
//        hStack.addArrangedSubview(rankLabel)
        hStack.addArrangedSubview(thunbnailImageView)
        hStack.addArrangedSubview(vStack)
        vStack.addArrangedSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        vStack.addArrangedSubview(descriptionLabel)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(hStack)
        rankLabel.setContentHuggingPriority(.required, for: .horizontal)
        rankLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        thunbnailImageView.setContentHuggingPriority(.required, for: .horizontal)
        thunbnailImageView.setContentCompressionResistancePriority(.required, for: .horizontal)

        NSLayoutConstraint.activate([
            hStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            hStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            hStack.topAnchor.constraint(equalTo: contentView.topAnchor),
            hStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
        
        NSLayoutConstraint.activate([
            thunbnailImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 30),
            thunbnailImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            thunbnailImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.2),
            thunbnailImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30),
            thunbnailImageView.heightAnchor.constraint(equalToConstant: 150)
            ])
        thunbnailImageView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    func configure(with movie: Movie, briefRank: Int) {
        titleLabel.text = movie.title
        descriptionLabel.text = "평점: " + movie.voteAverage.formatted
        rankLabel.text = "\(briefRank + 1)" + "위"
        thunbnailImageView.setImage(with: "https://image.tmdb.org/t/p/w200" + (movie.posterPath ?? ""))
    }
}

fileprivate extension Double {
    var formatted: String { return .init(format: "%.1f", self) }
}

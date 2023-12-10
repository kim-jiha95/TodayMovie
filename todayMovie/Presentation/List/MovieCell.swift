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
    private let RankView: UITextView = .init()
    private let titleLabel: UILabel = .init()
    private let rank: UILabel = .init()
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
        
        RankView.font = UIFont.boldSystemFont(ofSize: 18)
        RankView.textColor = .black
        RankView.textAlignment = .center
        RankView.contentInset = UIEdgeInsets(top: 25, left: 0, bottom: 0, right: 0)

        hStack.addArrangedSubview(RankView)
        RankView.translatesAutoresizingMaskIntoConstraints = false
        hStack.addArrangedSubview(vStack)
        vStack.addArrangedSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        vStack.addArrangedSubview(descriptionLabel)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(hStack)
        NSLayoutConstraint.activate([
            RankView.widthAnchor.constraint(equalToConstant: 100),
            RankView.heightAnchor.constraint(equalToConstant: 100),
            hStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            hStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            hStack.topAnchor.constraint(equalTo: contentView.topAnchor),
            hStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
    
    func configure(with movie: Movie, briefRank: Int) {
        posterView.setImage(with: movie.posterPath ?? "")
        let formattedVoteAverage = String(format: "%.1f", movie.voteAverage)

        // image cache 에 대해 알아보고 구현하기
        titleLabel.text = movie.title
        descriptionLabel.text = "평점: " + formattedVoteAverage
        RankView.text = "\(briefRank + 1)" + "위"
    }
    func reset() {
        ImageCacheManager.shared.cancelDownloadTask()
    }
}

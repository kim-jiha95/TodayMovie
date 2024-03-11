//
//  MovieCell.swift
//  todayMovie
//
//  Created by Jihaha kim on 2023/11/30.
//

import UIKit

final class MovieCell: UITableViewCell {
    
    private let thumbnailImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
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
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        return label
    }()
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = UIFont.boldSystemFont(ofSize: 13)
        return label
    }()
    
    private var topConstraint: NSLayoutConstraint!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        thumbnailImageView.image = .none
        rankLabel.text = .none
        titleLabel.text = .none
        descriptionLabel.text = .none
    }
    required init?(coder: NSCoder) {
        fatalError("Error")
    }
    
    private func configureUI() {
        let vStack: UIStackView = {
            let stackView = UIStackView(arrangedSubviews: [titleLabel, descriptionLabel])
            stackView.axis = .vertical
            stackView.alignment = .fill
            stackView.distribution = .fillEqually
            stackView.translatesAutoresizingMaskIntoConstraints = false
            return stackView
        }()
        
        let hStack: UIStackView = {
            let stackView = UIStackView(arrangedSubviews: [thumbnailImageView, vStack])
            stackView.axis = .horizontal
            stackView.alignment = .center
            stackView.distribution = .fillProportionally
            stackView.spacing = 5
            stackView.translatesAutoresizingMaskIntoConstraints = false
            return stackView
        }()
        
        hStack.addArrangedSubview(thumbnailImageView)
        hStack.addArrangedSubview(vStack)
        vStack.addArrangedSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        vStack.addArrangedSubview(descriptionLabel)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(hStack)
        rankLabel.setContentHuggingPriority(.required, for: .horizontal)
        rankLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        if #available(iOS 11.0, *) {
            topConstraint = hStack.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 10)
        } else {
            topConstraint = hStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10)
        }
        
        NSLayoutConstraint.activate([
            hStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            hStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            topConstraint,
            hStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            thumbnailImageView.widthAnchor.constraint(equalToConstant: 150),
            thumbnailImageView.heightAnchor.constraint(equalToConstant: 150),
            
            vStack.leadingAnchor.constraint(equalTo: thumbnailImageView.trailingAnchor, constant: 5),
            vStack.trailingAnchor.constraint(equalTo: hStack.trailingAnchor),
            topConstraint
        ])
    }
    
    
    func configure(with movie: Movie, briefRank: Int, isFirstCell: Bool) async {
        titleLabel.text = movie.title
        descriptionLabel.text = "평점: " + movie.voteAverage.formatted
        rankLabel.text = "\(briefRank + 1)" + "위"
        await thumbnailImageView.setImage(with: "https://image.tmdb.org/t/p/w200" + (movie.posterPath ?? ""))
        
        if isFirstCell {
            topConstraint.constant = 20
        } else {
            topConstraint.constant = 0
        }
    }
}

fileprivate extension Double {
    var formatted: String { return .init(format: "%.1f", self) }
}

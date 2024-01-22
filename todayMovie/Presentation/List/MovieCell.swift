//
//  MovieCell.swift
//  todayMovie
//
//  Created by Jihaha kim on 2023/11/30.
//

import UIKit

final class MovieCell: UITableViewCell {
    
    private let thunbnailImageView: UIImageView = {
        let view = UIImageView()
        view.setContentHuggingPriority(.required, for: .horizontal)
        view.setContentCompressionResistancePriority(.required, for: .horizontal)
        view.heightAnchor.constraint(equalToConstant: 100).isActive = false
        view.widthAnchor.constraint(equalToConstant: 100).isActive = false
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
        hStack.addArrangedSubview(thunbnailImageView)
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
        
        NSLayoutConstraint.activate([
            thunbnailImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.2),
            thunbnailImageView.heightAnchor.constraint(equalToConstant: 150),
            // todo: 아래 3개 ui 제약 때문에 터미널 에러 생김
            thunbnailImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30),
            thunbnailImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            thunbnailImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 60),
        ])
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

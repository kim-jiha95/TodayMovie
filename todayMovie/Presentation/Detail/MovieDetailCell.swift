//
//  MovieDetailCell.swift
//  todayMovie
//
//  Created by Jihaha kim on 2023/12/07.
//

import UIKit

final class MovieDetailCell: UITableViewCell {
    static let cellId = "CellId2"
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()

    private let subTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = UIFont.boldSystemFont(ofSize: 12)
        return label
    }()
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.numberOfLines = 3
        label.font = UIFont.boldSystemFont(ofSize: 10)
        return label
    }()
    private let descriptionTitle: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.text = "줄거리"
        return label
    }()
    private let releaseDateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = UIFont.boldSystemFont(ofSize: 10)
        return label
    }()
    private let starLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 13)
        return label
    }()
    
    private var backgroundImageView: UIImageView = {
        let view = UIImageView()
        view.heightAnchor.constraint(equalToConstant: 300).isActive = false
        view.widthAnchor.constraint(equalToConstant: 300).isActive = false
        return view
    }()
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setAutolayout()
        contentView.backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setAutolayout() {
        let backgroundImageStack: UIStackView = .init()
        backgroundImageStack.axis = .horizontal
        backgroundImageStack.alignment = .center
        backgroundImageStack.distribution = .fill
        backgroundImageStack.translatesAutoresizingMaskIntoConstraints = false
        
        let contentStack: UIStackView = .init()
        contentStack.axis = .horizontal
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        
        let vStack: UIStackView = .init()
        vStack.axis = .vertical
        vStack.distribution = .fill
        vStack.spacing = 12
        vStack.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(vStack)
        contentView.addSubview(backgroundImageStack)

        backgroundImageStack.addSubview(backgroundImageView)
        
        vStack.addArrangedSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        vStack.addArrangedSubview(subTitleLabel)
        subTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        vStack.addArrangedSubview(releaseDateLabel)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        vStack.addArrangedSubview(descriptionTitle)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        vStack.addArrangedSubview(descriptionLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        vStack.addArrangedSubview(starLabel)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            backgroundImageStack.heightAnchor.constraint(equalToConstant: 400)
        ])
        
        NSLayoutConstraint.activate([
               backgroundImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 1),
               backgroundImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 1),
               backgroundImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -1),
               backgroundImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
               backgroundImageView.heightAnchor.constraint(equalToConstant: 350)

           ])
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            vStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 320),
            vStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 100),
            vStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -100),
            vStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40),
            vStack.heightAnchor.constraint(equalToConstant: 250),
            titleLabel.heightAnchor.constraint(equalToConstant: 50)
           ])
        vStack.translatesAutoresizingMaskIntoConstraints = false
    }
    func transferData( _ movie: Movie) {
        let formattedVoteAverage = String(format: "%.1f", movie.voteAverage)
       backgroundImageView.setImage(with: "https://image.tmdb.org/t/p/w500" + (movie.backdrop_path ?? ""))
        
        titleLabel.text = movie.title
        subTitleLabel.text = movie.original_title
        descriptionLabel.text = "\(movie.overview)"
        releaseDateLabel.text = "\(movie.releaseDate)" + "개봉"
        starLabel.text = "평점:" + " " + formattedVoteAverage
    }
}

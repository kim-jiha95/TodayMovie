//
//  MovieDetailCell.swift
//  todayMovie
//
//  Created by Jihaha kim on 2023/12/07.
//

import UIKit

class MovieDetailCell: UITableViewCell {
    static let cellId = "CellId2"
    let titleLabel: UILabel = .init()
    let subTitleLabel: UILabel = .init()
    let descriptionLabel: UILabel = .init()
    let releaseDateLabel: UILabel = .init()
    let starLabel: UILabel = .init()

    
    private lazy var posterImageView: UIImageView = {

        let view = UIImageView()
        view.heightAnchor.constraint(equalToConstant: 120).isActive = true
        view.widthAnchor.constraint(equalToConstant: 120).isActive = true
        view.layer.cornerRadius = 25
        return view
    }()
    
    private lazy var backgroundImageView: UIImageView = {
        let view = UIImageView()
        view.heightAnchor.constraint(equalToConstant: 525).isActive = true
        view.widthAnchor.constraint(equalToConstant: 312).isActive = true
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
        
        let mainImageStack: UIStackView = .init()
        mainImageStack.axis = .horizontal
        mainImageStack.alignment = .center
        mainImageStack.distribution = .fill
        mainImageStack.translatesAutoresizingMaskIntoConstraints = false
        
        let backgroundImageStack: UIStackView = .init()
        backgroundImageStack.axis = .horizontal
        backgroundImageStack.alignment = .fill
        backgroundImageStack.distribution = .fillEqually
        backgroundImageStack.translatesAutoresizingMaskIntoConstraints = false
        
        let vStack: UIStackView = .init()
        vStack.axis = .vertical
        vStack.alignment = .fill
        vStack.distribution = .fillEqually
        vStack.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(mainImageStack)
        contentView.addSubview(backgroundImageStack)
        contentView.addSubview(vStack)
        mainImageStack.addSubview(posterImageView)
        backgroundImageStack.addSubview(backgroundImageView)
//        backgroundImageStack.addArrangedSubview(vStack)
        mainImageStack.layer.zPosition = 2
        backgroundImageStack.layer.zPosition = 1
        vStack.layer.zPosition = 10
        
        vStack.addArrangedSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        vStack.addArrangedSubview(subTitleLabel)
        subTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        vStack.addArrangedSubview(descriptionLabel)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        vStack.addArrangedSubview(releaseDateLabel)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        vStack.addArrangedSubview(starLabel)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 25),
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            posterImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            posterImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -25),
          
        ])
        posterImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            backgroundImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32),
            backgroundImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -32),
            backgroundImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
        ])
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false

    }
    func transferData( _ movie: Movie) {
        posterImageView.setImage(with: "https://image.tmdb.org/t/p/w500" + (movie.posterPath ?? "") )

        backgroundImageView.setImage(with: "https://image.tmdb.org/t/p/w500" + (movie.backdrop_path ?? "") )

        titleLabel.text = movie.title
        subTitleLabel.text = movie.original_title
        descriptionLabel.text = "\(movie.overview)"
        releaseDateLabel.text = "\(movie.releaseDate)"
        starLabel.text = "\(movie.voteAverage)"
    }
}

//
//  MovieDetailCell.swift
//  todayMovie
//
//  Created by Jihaha kim on 2023/12/07.
//

import UIKit

class MovieDetailCell: UITableViewCell {
    static let cellId = "CellId2" // protocol

    private lazy var posterImageView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .darkGray
        view.heightAnchor.constraint(equalToConstant: 325).isActive = true
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
        contentView.addSubview(posterImageView)

        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 30),
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 64),
            posterImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -64),
            posterImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30),
        ])
        posterImageView.translatesAutoresizingMaskIntoConstraints = false

    }
    func transferData( _ movie: Movie) {
        posterImageView.setImage(with: "https://image.tmdb.org/t/p/w500" + (movie.posterPath ?? "") )
    }
}

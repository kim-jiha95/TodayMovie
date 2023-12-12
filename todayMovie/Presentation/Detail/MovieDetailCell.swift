//
//  MovieDetailCell.swift
//  todayMovie
//
//  Created by Jihaha kim on 2023/12/07.
//

import UIKit

// 1. final은 무조건 class앞에 붙여주세요
class MovieDetailCell: UITableViewCell {
    static let cellId = "CellId2"
    // 2. 프로퍼티를 설정할 때에도 private은 디폴트
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()

    let subTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = UIFont.boldSystemFont(ofSize: 12)
        return label
    }()
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.numberOfLines = 3
        label.font = UIFont.boldSystemFont(ofSize: 10)
        return label
    }()
    let descriptionTitle: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.text = "줄거리"
        return label
    }()
    let releaseDateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = UIFont.boldSystemFont(ofSize: 10)
        return label
    }()
    let starLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 13)
        return label
    }()

    /// lazy는 언제 왜 쓰나요?
    /// 
    /// lazy라는 아이는
    /// memory에 이 프로퍼티가 올라갈 수도 있고, 안올라갈 수도 있는 아이.
    /// 아니면 self를 참조해서 init시점이 아닌 dynamic하게 올라가는 아이.
    /// 
    private lazy var posterImageView: UIImageView = {
        let view = UIImageView()
        view.heightAnchor.constraint(equalToConstant: 120).isActive = false
        view.widthAnchor.constraint(equalToConstant: 120).isActive = false
        view.layer.cornerRadius = 15
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var backgroundImageView: UIImageView = {
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
    
    /// 스택뷰를 많이 쓴 이유?
    /// HStack 하나,
    /// VStack 하나
    /// 만 있으면 돼요.
    /// 
    /// 숙제3: StackView Refactoring
    func setAutolayout() {
        let mainImageStack: UIStackView = .init()
        mainImageStack.axis = .horizontal
        mainImageStack.alignment = .center
        mainImageStack.translatesAutoresizingMaskIntoConstraints = false
        
        let backgroundImageStack: UIStackView = .init()
        backgroundImageStack.axis = .horizontal
        backgroundImageStack.translatesAutoresizingMaskIntoConstraints = false
        
        let imageStack: UIStackView = .init()
        imageStack.axis = .horizontal
        imageStack.translatesAutoresizingMaskIntoConstraints = false
        
        let contentStack: UIStackView = .init()
        contentStack.axis = .horizontal
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        
        let vStack: UIStackView = .init()
        vStack.axis = .vertical
        vStack.distribution = .fill
        vStack.translatesAutoresizingMaskIntoConstraints = false
        
        let v2Stack: UIStackView = .init()
        v2Stack.axis = .vertical
        v2Stack.distribution = .fill
        v2Stack.spacing = 5
        v2Stack.translatesAutoresizingMaskIntoConstraints = false
        
        imageStack.addSubview(mainImageStack)
        imageStack.addSubview(backgroundImageStack)
        contentStack.addSubview(vStack)
        contentStack.addSubview(v2Stack)
        contentView.addSubview(imageStack)
        contentView.addSubview(contentStack)

        mainImageStack.addSubview(posterImageView)
        backgroundImageStack.addSubview(backgroundImageView)

        mainImageStack.layer.zPosition = 2
        backgroundImageStack.layer.zPosition = 1
        vStack.layer.zPosition = 10
        
        vStack.addArrangedSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        vStack.addArrangedSubview(subTitleLabel)
        subTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        vStack.addArrangedSubview(releaseDateLabel)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        v2Stack.addArrangedSubview(descriptionTitle)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        v2Stack.addArrangedSubview(descriptionLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        v2Stack.addArrangedSubview(starLabel)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            imageStack.heightAnchor.constraint(equalToConstant: 400),
            contentStack.heightAnchor.constraint(equalToConstant: 400),
        ])
        
        NSLayoutConstraint.activate([
                posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 30),
                posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
                posterImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.2),
                posterImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30),
                posterImageView.heightAnchor.constraint(equalToConstant: 150)
            ])
        posterImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
               backgroundImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 1),
               backgroundImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 1),
               backgroundImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -1),
               backgroundImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
               backgroundImageView.heightAnchor.constraint(equalToConstant: 50)

           ])
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            vStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 100),
            vStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 100),
            vStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -100),
            vStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40),
            vStack.heightAnchor.constraint(equalToConstant: 150)

           ])
        vStack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            v2Stack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 310),
            v2Stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 100),
            v2Stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -100),
//            v2Stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -50),
            vStack.heightAnchor.constraint(equalToConstant: 150)
           ])
        v2Stack.translatesAutoresizingMaskIntoConstraints = false
    }
    func transferData( _ movie: Movie) {
        let formattedVoteAverage = String(format: "%.1f", movie.voteAverage)
        posterImageView.setImage(with: "https://image.tmdb.org/t/p/w500" + (movie.posterPath ?? "") )
        
        backgroundImageView.setImage(with: "https://image.tmdb.org/t/p/w500" + (movie.backdrop_path ?? "") )
        
        titleLabel.text = movie.title
        subTitleLabel.text = movie.original_title
        descriptionLabel.text = "\(movie.overview)"
        releaseDateLabel.text = "\(movie.releaseDate)" + "개봉"
        starLabel.text = "평점:" + " " + formattedVoteAverage
    }
}

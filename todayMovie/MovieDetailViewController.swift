//
//  MovieDetailController.swift
//  todayMovie
//
//  Created by Jihaha kim on 2023/11/30.
//

import UIKit

final class MovieDetailViewController: UIViewController {
    private let movie: Movie
    
    init(movie: Movie) {
        self.movie = movie
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        // 선택된 영화 정보를 이용하여 화면을 구성합니다.
        // 예를 들어, 영화 정보를 레이블이나 이미지 뷰에 표시할 수 있습니다.
        // selectedMovie의 속성들을 활용하여 화면을 구성합니다.
        // 예를 들어, 영화 제목은 selectedMovie.title 등으로 접근 가능합니다.
    }
}

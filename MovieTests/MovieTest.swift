//
//  MovieTest.swift
//  todayMovie
//
//  Created by 한상진 on 1/15/24.
//

import XCTest
@testable import todayMovie

@MainActor
final class MovieTests: XCTestCase {
    
    // system under test
    var sut: MovieViewModel!

    override func setUpWithError() throws {
        let networkClient: NetworkClient = .init()
        sut = .init(networkClient: networkClient)
    }

    override func tearDownWithError() throws {
        sut = .none
    }
    
    /// input, output을 테스트해야해요
    /// 
    /// 네트워크는 우리가 제어할 수 없잖아요
    /// 네트워크라는 외부 요인을 제외한 채,
    /// 우리가 짠 비지니스 로직은 완벽한가?
    /// 
    /// 지금까지 짠 로직에 대해 테스트 짜보기
    /// 
    func test_뷰가_로드되면_movie_데이터를_받아온다() throws {
        let given: String = "비교할 결과" // 영화 이름, page ...
        let expectedResult: [Movie] = []
        
        sut.viewDidLoad()
        XCTAssertEqual(sut.movies, expectedResult)
    }
}

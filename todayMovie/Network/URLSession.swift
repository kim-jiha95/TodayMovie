//
//  URLSession.swift
//  todayMovie
//
//  Created by Jihaha kim on 2023/10/29.
//

import Foundation

/// request
/// task
/// response
/// 
/// configuration
/// session

/// Network 통신을 담당하는 객체
///
/// <CS 기초 지식> -> 도 알아야한다.
///
/// 공개키/개인키 기반 암호화
/// 인증서 발급
/// 쿠키/세션
///
/// OSI 7계층
/// Presentation
/// TCP/IP
/// dns -> router
/// ...
///
/// RestAPI
/// get, post, put, delete
///
/// <Swift/iOS에서는 어떻게 네트워크 통신이 이루어지는지> -> 지금은 이것부터
///
/// 1. URLSessionConfiguration에 어떤 아이들이 있는지
/// 1-1. 각각 아이들의 장단점 -> 어떤 경우에 어떤 아이를 쓰는지
/// 2. URLSession은 어떤 아이인지?
/// 3. APIKey -> 중요한 정보, 따로 관리하는게 좋아요. 지금은 안해도 될 것 같아요.
/// 4. fetchData는 몇백개, 몇천개가 될 수 있어요.
/// 4-1. generic을 통해 만들거든요?
/// `func fetchData<Model: Decodable>() -> Model`
/// 5. 분할정복
/// 5-1. url, parameter encoding, method, response parsing, response validating, decoding 함수로 분리할 수도 잇고, 객체로 분리할 수도 있겠죠?
///
/// 다음시간까지 목표
/// 공식문서들 -> 깃헙, 구글 -> 네트워크 매니저를 어떻게 만들었는지 여러 개를 분석해보고 -> 모르는 개념들을 다시 공부하고 -> 어떤 아이들이 있고 어떻게 구현해야하는지
func fetchData() {
    let configuration = URLSessionConfiguration.default
    let session = URLSession(configuration: configuration)
    let tmdbAPIKey = "e3269631c1a855227a37cefab44ad995"
    let urlString = "https://api.themoviedb.org/3/movie/157336?api_key=\(tmdbAPIKey)&append_to_response=videos"
    
    guard let url = URL(string: urlString) else {
        print("Invalid URL")
        return
    }
    
    let task = session.dataTask(with: url) { data, response, error in
        guard let httpResponse = response as? HTTPURLResponse, (200..<300).contains(httpResponse.statusCode) else {
            print("--> response \(String(describing: response))")
            return
        }
        
        guard let data = data, let result = String(data: data, encoding: .utf8) else {
            return
        }
        
        print("Movie result:", result)
    }
    
    task.resume()
}

/**
struct Network {
    let errorHandler = ErrorHandler()
    func fetch() {
        url()
        parameter()
        // url, parameter encoding, method, response parsing, response validating, decoding
        errorHandler.handleError()
    }
    
    func url() {
        
    }
    
    func parameter() {
        
    }
}

struct ErrorHanlder {
    
}

struct NetworkDecoder {
    
}
 */

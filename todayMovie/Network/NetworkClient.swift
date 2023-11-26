//
//  NetworkClient.swift
//  todayMovie
//
//  Created by 한상진 on 11/20/23.
//

import Foundation

struct Model: Decodable { }

struct NetworkClient {
    /// 비동기 처리
    /// 
    /// `completionHandler`: (closure - callback) -> 가장 기초적인 비동기 처리 방식
    /// 
    /// `RxSwift / Combine`: 함수형 프로그래밍 방식
    ///     `RxSwift`: 써드파티에서 만든 오래된 프레임워크
    ///     `Combine`: 애플에서 만든 RxSwift랑 같은 기능을 하는 프레임워크
    /// `async/await`: 애플에서 만든 최신 비동기 처리 방식
    /// 
    /// 
    /// 
    /// /// 네트워크 요청 0.1~2초
    /// 유저가 터치하는
    /// 이 동안 화면은 멈추면 안되겠죠?
    /// 홈으로 들어갔는데, 홈의 API가 끝나기 전에, 세팅으로 가고 싶어요
    /// 숙제1: completionHandler: 
    ///     ios main thread 동작 -> UI는 메인쓰레드에서 돈다
    ///     ios callback closure를 사용하는 이유
    /// 숙제2: request함수는 큰 문제가 하나 있어요
    ///     그 문제를 찾아내고 수정하시오
    /// 숙제3: 하나의 함수가 너무 길어요.
    ///     어떻게 해야할까요?
    /// 숙제4: URLSession.shared를 사용하고 있는데, 
    ///     shared가 아닌 직접 만든 URLSession을 사용하도록 수정
    /// 숙제5: 위 숙제들 다 했으면 viewcontroller에서 todayMovie를 이 함수로 받아오도록 수정하기
    func request(
        endpoint: URLRequestConfigurable,
        completionHandler: @escaping (Result<Model, Error>) -> Void
    ) {
        do {
            let urlRequest = try endpoint.asURLRequest()
            performRequest(with: urlRequest, completionHandler: completionHandler)
        } catch {
            completionHandler(.failure(JHNetworkError.endpointCongifureFailed))

        }
    }

    private func performRequest(
        with urlRequest: URLRequest,
        completionHandler: @escaping (Result<Model, Error>) -> Void
    ) {
        let customURLSession = URLSession(configuration: .default)

        let dataTask = customURLSession.dataTask(with: urlRequest) { data, response, error in
            handleResponse(data: data, response: response, error: error, completionHandler: completionHandler)
        }

        dataTask.resume()
    }

    private func handleResponse(
        data: Data?,
        response: URLResponse?,
        error: Error?,
        completionHandler: @escaping (Result<Model, Error>) -> Void
    ) {
        guard let data = data else {
            completionHandler(.failure(JHNetworkError.endpointCongifureFailed))

            return
        }

        guard error == nil else {
            completionHandler(.failure(JHNetworkError.endpointCongifureFailed))

            return
        }

        guard let response = response as? HTTPURLResponse, 200..<300 ~= response.statusCode else {
            completionHandler(.failure(JHNetworkError.endpointCongifureFailed))

            return
        }

        do {
            let model = try JSONDecoder().decode(Model.self, from: data)
            completionHandler(.success(model))
        } catch {
            completionHandler(.failure(JHNetworkError.endpointCongifureFailed))
        }
    }

}

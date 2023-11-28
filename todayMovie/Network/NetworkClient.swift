//
//  NetworkClient.swift
//  todayMovie
//
//  Created by 한상진 on 11/20/23.
//

import Foundation


/// 비동기 처리
/// 
/// `completionHandler`: (closure - callback) -> 가장 기초적인 비동기 처리 방식
/// `GCD or Operation Queue`
/// 
/// `RxSwift / Combine`: 함수형 프로그래밍 방식
///     `RxSwift`: 써드파티에서 만든 오래된 프레임워크
///     `Combine`: 애플에서 만든 RxSwift랑 같은 기능을 하는 프레임워크
///     
/// `async/await`: 애플에서 만든 최신 비동기 처리 방식
/// 
/// GCD, completionHandler -> async/await 정석
/// 요즘은 거의 async/await를 사용하는데,
/// 면접에서 GCD, completionHandler 물어볼 수도 있고, 
/// 아직은 RxSwift를 많이 쓰고있더든요?
/// 좋아서는 아니고, 이미 개발되어있는 아이들 변경할 시간이 없어서
/// 결국에는 다 할 줄 알아야 취직이 되기 쉬운데,
/// 일단은 completionHandler 얘부터 해야한다.

struct Model1: Decodable { }
struct Model2: Decodable { }
struct Model3: Decodable { }
struct Model4: Decodable { }
struct Model5: Decodable { }
struct Model6: Decodable { }

/// 네트워크를 요청할 때 쓰는 아이
/// 
/// 어떤 상황에서는 네트워크 요청을 실제로 안하고 싶을 수도 있고,
/// timeInterval같은거를 조절하고 싶을 수도 있고 (60초 -> 10초)
/// 
/// url session을 변경할 수 있으면 좋잖아요?
/// parameter로 사용할 session을 주던가
/// initialize하는 시점에
/// 
/// 동작과 역할분리는 어느정도는 된 상태
/// 완벽하지는 않아요.

struct NetworkClient {
    
    private let urlSession: URLSession
    
    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
    
    func request<T: Decodable>(
        endpoint: URLRequestConfigurable,
        for type: T.Type,
        completionHandler: @escaping (Result<T, Error>) -> Void
    ) {
        do {
            let urlRequest = try endpoint.asURLRequest()

            /// 버튼이 눌리는건 UI니까 Main Thread -> request -> dataTask
            /// callback이 실행되는 thread는 백그라운드 쓰레드
            let dataTask = urlSession.dataTask(with: urlRequest) { data, response, error in
                guard let data = data else {
                    completionHandler(.failure(NSError(domain: "1", code: 1)))
                    return
                }

                guard error == nil else {
                    completionHandler(.failure(NSError(domain: "2", code: 2)))
                    return
                }
                
                do {
                    try validate(response: response)
                }
                catch {
                    completionHandler(.failure(error))
                }

                do {
                    let model = try JSONDecoder().decode(T.self, from: data)
                    completionHandler(.success(model))
                } catch {
                    completionHandler(.failure(NSError(domain: "3", code: 3)))
                }
            }

            dataTask.resume()
        } catch {
            completionHandler(.failure(NSError(domain: "4", code: 4)))
        }
    }
    
    private func validate(response: URLResponse?) throws {
        guard 
            let response = response as? HTTPURLResponse, 
            200..<300 ~= response.statusCode 
        else {
            print(response)
            throw NSError(domain: "5", code: 5)
        }
    }
}

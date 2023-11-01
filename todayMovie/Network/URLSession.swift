//
//  URLSession.swift
//  todayMovie
//
//  Created by Jihaha kim on 2023/10/29.
//

import Foundation
import UIKit

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





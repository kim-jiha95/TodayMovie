//
//  URLSession.swift
//  todayMovie
//
//  Created by Jihaha kim on 2023/10/29.
//

import Foundation

// configuration -> urlsession -> urlsessiontask

let configuration = URLSessionConfiguration.default
let session = URLSession(configuration: configuration)

let url = URL(string: "https://api.themoviedb.org/3/movie/157336?api_key=e3269631c1a855227a37cefab44ad995&append_to_response=videos")

let task  = session.dataTask(with: url) { data, response, error in
    guard let httpResponse = response as? HTTPPURLResponse,
          (200..<300).contains(httpResponse.statusCode) else {
        print("--> response \(response)")
    }
}

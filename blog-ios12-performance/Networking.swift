//
//  Networking.swift
//  blog-ios12-performance
//
//  Created by Swain Molster on 6/8/18.
//  Copyright © 2018 CapTech. All rights reserved.
//

import Foundation

private let PageSize = 40
private let APIToken = "f35e44daa6eb4c75993efd566596a3b1"
private let BaseURL = "https://newsapi.org/v2"

struct Network {
    
    static func loadArticles(q: String, page: Int, completion: @escaping (ArticlesResponse) -> Void) {
        let url = URL(string: "\(BaseURL)/everything?pageSize=\(PageSize)&q=\(q)&language=en&sortBy=publishedAt&page=\(page)")!
        print("Fetch \(url.absoluteString)")
        URLSession.shared.dataTask(with: urlRequest(for: url)) { (data, urlResponse, error) in
            if let data = data, let json = String(data: data, encoding: .utf8) {
                print(json)
            }
            guard let response = articlesResponse(from: data, page: page) else {
                return
            }
            
            DispatchQueue.main.async {
                completion(response)
            }
        }.resume()
    }
    
    private static func articlesResponse(from data: Data?, page: Int) -> ArticlesResponse? {
        guard let data = data else { return nil }
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            var response = try decoder.decode(ArticlesResponse.self, from: data)
            response.page = page
            return response
        } catch let e {
            print("\(e)")
        }
        
        return nil
    }
    
    private static func urlRequest(for url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.addValue("Bearer \(APIToken)", forHTTPHeaderField: "Authorization")
        return request
    }
}


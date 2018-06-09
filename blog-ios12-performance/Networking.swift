//
//  Networking.swift
//  blog-ios12-performance
//
//  Created by Swain Molster on 6/8/18.
//  Copyright © 2018 CapTech. All rights reserved.
//

import Foundation

struct ArticlesResponse: Codable {
    let status: String
    let totalResults: Int
    let articles: [Article]
}

struct Article: Codable {
    struct Source: Codable {
        let id: String?
        let name: String
    }
    
    let source: Source
    let author: String?
    let title: String
    let description: String?
    let url: URL?
    let urlToImage: URL?
    let publishedAt: String?
    
    var publishedAtDate: Date? {
        guard let dateString = publishedAt else { return nil }
        return ISO8601DateFormatter().date(from: dateString)
    }
    
    func cacheKey() -> String {
        return self.title.replacingOccurrences(of: " ", with: "-").replacingOccurrences(of: "/", with: "").lowercased()
    }
}

private func urlRequest(for url: URL) -> URLRequest {
    var request = URLRequest(url: url)
    request.addValue("Bearer f35e44daa6eb4c75993efd566596a3b1", forHTTPHeaderField: "Authorization")
    return request
}

struct Network {
    
    static func loadTopHeadlines(completion: @escaping (ArticlesResponse) -> Void) {
        let url = URL(string: "https://newsapi.org/v2/everything?pageSize=100&q=apple&language=en&sortBy=publishedAt")!
        URLSession.shared.dataTask(with: urlRequest(for: url)) { (data, urlResponse, error) in
            if let data = data, let json = String(data: data, encoding: .utf8) {
                print(json)
            }
            guard let response = articlesResponse(from: data) else {
                return
            }
            DispatchQueue.main.async {
                completion(response)
            }
        }.resume()
    }
    
    private static func articlesResponse(from data: Data?) -> ArticlesResponse? {
        guard let data = data else { return nil }
        do {
            return try JSONDecoder().decode(ArticlesResponse.self, from: data)
        } catch let e {
            print("\(e)")
        }
        
        return nil
    }
}


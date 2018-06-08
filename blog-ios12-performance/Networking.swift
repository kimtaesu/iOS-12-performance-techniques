//
//  Networking.swift
//  blog-ios12-performance
//
//  Created by Swain Molster on 6/8/18.
//  Copyright © 2018 CapTech. All rights reserved.
//

import Foundation

struct AllArticlesResponse: Decodable {
    let status: String
    let totalResults: Int
    let articles: [Article]
}

struct Article: Decodable {
    struct Source: Decodable {
        let id: String?
        let name: String
    }
    
    let source: Source
    let author: String
    let title: String
    let description: String
    let url: URL
    let urlToImage: URL
    let publishedAt: Date
}

private func urlRequest(for url: URL) -> URLRequest {
    var request = URLRequest(url: url)
    request.addValue("Bearer f35e44daa6eb4c75993efd566596a3b1", forHTTPHeaderField: "Authorization")
    return request
}

func loadAllArticles(query: String, completion: @escaping (AllArticlesResponse) -> Void) {
    let url = URL(string: "https://newsapi.org/v2/everything?q=\(query)")!
    URLSession.shared.dataTask(with: urlRequest(for: url)) { data, urlResponse, error in
        guard let data = data else {
            // TODO: Handle errors
            return
        }
        
        do {
            let articlesResponse = try JSONDecoder().decode(AllArticlesResponse.self, from: data)
            completion(articlesResponse)
        } catch {
            // TODO: Handle errors
        }
    }
}

//
//  Model.swift
//  blog-ios12-performance
//
//  Created by ttillage on 6/9/18.
//  Copyright © 2018 CapTech. All rights reserved.
//

import Foundation
import NaturalLanguage

struct ArticlesResponse: Codable {
    let status: String
    let totalResults: Int
    private(set) var articles: [Article]
    var page: Int?
    
    mutating func formatArticles() {
        for (i, _) in articles.enumerated() {
            articles[i].calculateFormattedValues()
        }
    }
    
    mutating func filterInvalidArticles() {
        articles = articles.filter({ $0.urlToImage != nil })
    }
}

struct Article: Codable {
    
    static let nameTagger = NLTagger(tagSchemes: [.nameType])
    static let isoDateFormatter = ISO8601DateFormatter()
    static let displayDateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .long
        df.timeStyle = .short
        return df
    }()
    
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
    
    private(set) var publishedAtDate: Date?
    
    private(set) var displayDate: String?
    
    private(set) var nameHighlightedTitle: NSAttributedString?
    
    /// Not thread-safe!
    mutating func calculateFormattedValues() {
        // Date formatting
        if let dateString = publishedAt, let date = Article.isoDateFormatter.date(from: dateString) {
            publishedAtDate = date
            displayDate = Article.displayDateFormatter.string(from: date)
        }
        
        // NLP
        Article.nameTagger.string = title
        let range = title.startIndex ..< title.endIndex
        
        let tags = Article.nameTagger.tags(in: range, unit: .word, scheme: .nameType)
        
        let attrString = NSMutableAttributedString(string: title)
        for (tag, tagRange) in tags where tag == .personalName {
            let nsRange = (title as NSString).range(of: String(title[tagRange]))
            attrString.addAttribute(.underlineStyle, value: 1, range: nsRange)
        }
        nameHighlightedTitle = attrString
    }
    
    func cacheKey() -> String {
        return self.title.replacingOccurrences(of: " ", with: "-").replacingOccurrences(of: "/", with: "").lowercased()
    }
}

extension Article {
    enum CodingKeys: String, CodingKey {
        case source
        case author
        case title
        case description
        case url
        case urlToImage
        case publishedAt
    }
}

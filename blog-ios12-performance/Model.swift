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
    
    var nameHighlightedTitle: NSAttributedString {
        let tagger = NLTagger(tagSchemes: [.nameType])
        tagger.string = title
        let range = title.startIndex ..< title.endIndex
        
        let tags = tagger.tags(in: range, unit: .word, scheme: .nameType)
        
        let attrString = NSMutableAttributedString(string: title)
        for (tag, tagRange) in tags where tag == .personalName {
            let nsRange = (title as NSString).range(of: String(title[tagRange]))
            attrString.addAttribute(.underlineStyle, value: 1, range: nsRange)
        }
        return attrString
    }
    
    func cacheKey() -> String {
        return self.title.replacingOccurrences(of: " ", with: "-").replacingOccurrences(of: "/", with: "").lowercased()
    }
}

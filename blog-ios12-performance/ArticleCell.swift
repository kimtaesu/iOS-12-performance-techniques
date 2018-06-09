//
//  ArticleCell.swift
//  blog-ios12-performance
//
//  Created by ttillage on 6/9/18.
//  Copyright © 2018 CapTech. All rights reserved.
//

import UIKit
import NaturalLanguage

final class ArticleCell : UITableViewCell {
    static let reuseID = "article_cell"
    
    @IBOutlet var mediaImageView: UIImageView!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var bodyLabel: UILabel!
    
    private var loadingURL: URL?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.loadingURL = nil
    }
    
    func configureWith(article: Article, imageLoader: ImageLoader) {
        self.bodyLabel.attributedText = self.highlightedTitle(for: article.title)
        if let publishedDate = article.publishedAtDate {
            self.dateLabel.text = configuredString(using: publishedDate)
        } else {
            self.dateLabel.text = "Invalid Date"
        }
        
        self.loadingURL = nil
        self.mediaImageView.image = nil
        
        if let url = article.urlToImage {
            self.loadingURL = url
            imageLoader.load(url: url, completion: { url, image in
                if url == self.loadingURL {
                    self.mediaImageView.image = image
                }
            })
        }
    }
    
    func highlightedTitle(for title: String) -> NSAttributedString {
        let tagger = NLTagger(tagSchemes: [.nameType])
        tagger.string = title
        let range = title.startIndex ..< title.endIndex
        
        let tags = tagger.tags(in: range, unit: .word, scheme: .nameType)
        
        let attrString = NSMutableAttributedString(string: title)
        for (tag, tagRange) in tags where tag == NLTag.organizationName || tag == NLTag.personalName {
            let nsRange = (title as NSString).range(of: String(title[tagRange]))
            attrString.addAttribute(.underlineStyle, value: 1, range: nsRange)
        }
        return attrString
    }
    
    func configuredString(using date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: date)
    }
}

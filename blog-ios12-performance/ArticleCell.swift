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
        self.mediaImageView.image = nil
    }
    
    func configureWith(article: Article, imageLoader: ImageLoader) {
        self.bodyLabel.attributedText = article.nameHighlightedTitle
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
    
    func configuredString(using date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: date)
    }
}

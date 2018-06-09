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
    
    func configureWith(article: Article, imageLoader: ImageLoader) {
        self.bodyLabel.attributedText = article.nameHighlightedTitle
        self.dateLabel.text = article.displayDate
        
        if let url = article.urlToImage {
            if self.loadingURL != url {
                self.mediaImageView.image = nil
            }
            
            self.loadingURL = url
            
            imageLoader.load(url: url, completion: { url, image in
                if url == self.loadingURL {
                    self.mediaImageView.image = image
                }
            })
        } else {
            self.mediaImageView.image = nil
        }
    }
}

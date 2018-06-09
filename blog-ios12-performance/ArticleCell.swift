//
//  ArticleCell.swift
//  blog-ios12-performance
//
//  Created by ttillage on 6/9/18.
//  Copyright © 2018 CapTech. All rights reserved.
//

import UIKit

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
    
    func configureWith(article: Article) {
        self.bodyLabel.text = article.title
        if let publishedDate = article.publishedAtDate {
            self.dateLabel.text = configuredString(using: publishedDate)
        } else {
            self.dateLabel.text = "Invalid Date"
        }
        
        self.loadingURL = nil
        self.mediaImageView.image = nil
        
        if let url = article.urlToImage {
            self.loadingURL = url
            ImageLoader.load(url: url, completion: { url, image in
                if url == self.loadingURL {
                    self.mediaImageView.image = image
                }
            })
        }
    }
    
    func configuredString(using date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        return dateFormatter.string(from: date)
    }
}

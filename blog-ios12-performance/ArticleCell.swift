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
        self.dateLabel.text = configuredDate(using: article.publishedAt)
        
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
    
    func configuredDate(using string: String?) -> String {
        guard let string = string else { return "No Date Provided" }
        let isoDateFormatter = ISO8601DateFormatter()
        guard let date = isoDateFormatter.date(from: string) else { return "Invalid Date" }
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        return dateFormatter.string(from: date)
    }
}

//
//  ArticleCell.swift
//  blog-ios12-performance
//
//  Created by ttillage on 6/9/18.
//  Copyright © 2018 CapTech. All rights reserved.
//

import UIKit
import NaturalLanguage
import os.signpost

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
                    
                    let sId = OSSignpostID(log: SignpostLog.networking, object: imageLoader)
                    os_signpost(
                        .end,
                        log: SignpostLog.networking,
                        name: "Background Image",
                        signpostID: sId, "Finished with size %{xcode:size-in-bytes}llu", article.title)
                }
            })
        } else {
            self.mediaImageView.image = nil
        }
    }
    
}

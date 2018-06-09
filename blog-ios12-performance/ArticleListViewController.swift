//
//  ViewController.swift
//  blog-ios12-performance
//
//  Created by ttillage on 6/8/18.
//  Copyright © 2018 CapTech. All rights reserved.
//

import UIKit

final class ArticleListViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var spinner: UIActivityIndicatorView!
    
    var articles: [Article] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.articles = DiskCache.loadAll(type: Article.self)
        self.tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.reloadArticles()
    }
    
    func reloadArticles() {
        if self.articles.isEmpty {
            self.spinner.startAnimating()
        }
        Network.loadTopHeadlines(completion: { response in
            response.articles.forEach({
                DiskCache.save(model: $0, key: $0.cacheKey())
            })
            DispatchQueue.main.async {
                self.spinner.stopAnimating()
                self.articles = response.articles
                self.tableView.reloadData()
            }
        })
    }
}

extension ArticleListViewController : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.articles.isEmpty ? 0 : 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ArticleCell.reuseID, for: indexPath) as! ArticleCell
        cell.configureWith(article: self.articles[indexPath.row])
        return cell
    }
}

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
        self.dateLabel.text = article.publishedAt
        
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
}

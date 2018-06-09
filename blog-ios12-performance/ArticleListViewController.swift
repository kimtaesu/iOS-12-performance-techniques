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
    
    let imageLoader = ImageLoader()
    
    private(set) var articles: [Article]
    
    init(articles: [Article]) {
        self.articles = articles
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Top Headlines"
        self.tableView.register(UINib(nibName: "ArticleCell", bundle: nil), forCellReuseIdentifier: ArticleCell.reuseID)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.reloadFromCache()
        self.reloadFromAPI()
    }
    
    func reloadFromAPI() {
        if self.articles.isEmpty {
            self.spinner.startAnimating()
        }
        
        // Update from network
        Network.loadTopHeadlines(completion: { response in
            response.articles.forEach({
                DiskCache.save(model: $0, key: $0.cacheKey())
            })
            
            self.spinner.stopAnimating()
            self.articles = response.articles.sortedByPublishDate()
            self.tableView.reloadData()
        })
    }
    
    func reloadFromCache() {
        self.articles = DiskCache.loadAll(type: Article.self).sortedByPublishDate()
        self.tableView.reloadData()
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
        cell.configureWith(article: self.articles[indexPath.row], imageLoader: self.imageLoader)
        return cell
    }
}

private extension Array where Element == Article {
    
    func sortedByPublishDate() -> [Element] {
        return self.sorted(by: {
            if let d1 = $0.publishedAtDate, let d2 = $1.publishedAtDate {
                return d1 < d2
            } else if $1.publishedAtDate != nil {
                return false
            } else {
                return true
            }
        })
    }
}

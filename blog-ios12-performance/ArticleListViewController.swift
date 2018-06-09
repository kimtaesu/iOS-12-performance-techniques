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
        
        self.reloadArticles()
    }
    
    func reloadArticles() {
        // Update from cache
        self.articles = DiskCache.loadAll(type: Article.self)
        self.tableView.reloadData()
        
        if self.articles.isEmpty {
            self.spinner.startAnimating()
        }
        
        // Update from network
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

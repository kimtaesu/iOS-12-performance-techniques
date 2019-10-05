//
//  ViewController.swift
//  blog-ios12-performance
//
//  Created by ttillage on 6/8/18.
//  Copyright © 2018 CapTech. All rights reserved.
//

import UIKit
import os

final class ArticleListViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var spinner: UIActivityIndicatorView!
    
    let imageLoader = ImageLoader()
    
    var articles: [Article] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Top Headlines"
        self.tableView.register(UINib(nibName: "ArticleCell", bundle: nil), forCellReuseIdentifier: ArticleCell.reuseID)
        
        os_signpost(OSSignpostType.event, log: SignpostLog.pointsOfInterest, name: "View Did Load")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.reloadFromCache()
        
        os_signpost(OSSignpostType.event, log: SignpostLog.pointsOfInterest, name: "View Will Appear")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.reloadFromAPI()
        
        os_signpost(OSSignpostType.event, log: SignpostLog.pointsOfInterest, name: "View Did Appear")
    }
    
    func reloadFromAPI() {
        // Update from network
        Network.loadArticles(q: "apple", page: 1, completion: { response in
            self.articles = response.articles
            self.spinner.stopAnimating()
            self.tableView.reloadData()
            
            DiskCache.performAsync {
                DiskCache.save(model: response, key: "Response")
            }
        })
    }
    
    func reloadFromCache() {
        DiskCache.performAsync {
            if let response = DiskCache.load(type: ArticlesResponse.self, key: "Response") {
                DispatchQueue.main.async {
                    if self.spinner.isAnimating {
                        self.articles = response.articles
                        if !self.articles.isEmpty {
                            self.spinner.stopAnimating()
                        }
                        self.tableView.reloadData()
                    }
                }
            }
        }
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
        let uuid = UUID.ReferenceType()
        let article = self.articles[indexPath.row]
        
        let sId = OSSignpostID(log: SignpostLog.cellForRow, object: uuid)
        os_signpost(.begin, dso: "SignpostLog.cellForRow", log: SignpostLog.cellForRow, name: "SignpostLog.cellForRow", signpostID: sId, "%s", article.title)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ArticleCell.reuseID, for: indexPath) as! ArticleCell
        cell.configureWith(article: article, imageLoader: self.imageLoader)
        
        os_signpost(.end, log: SignpostLog.cellForRow, name: "Configure Cell", signpostID: OSSignpostID(log: SignpostLog.cellForRow, object: uuid))
        
        return cell
    }
    
}

extension ArticleListViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            os_signpost(OSSignpostType.event, log: SignpostLog.pointsOfInterest, name: "Will Display Cell")
        }
    }
}

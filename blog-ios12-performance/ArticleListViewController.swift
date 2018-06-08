//
//  ViewController.swift
//  blog-ios12-performance
//
//  Created by ttillage on 6/8/18.
//  Copyright © 2018 CapTech. All rights reserved.
//

import UIKit

final class ArticleListViewController: UITableViewController {
    
    var articles: [TempModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Network.loadTopHeadlines { (response) in
            print(response.totalResults)
        }
        
        let url = URL(string: "https://www.stripes.com/polopoly_fs/1.531847.1528489228!/image/image.jpg_gen/derivatives/landscape_490/image.jpg")!
        let model = TempModel(imageURL: url, date: "2018-06-08T21:06:54Z", body: "The Air Force grounded all B-1B Lancer heavy bombers as of Thursday to conduct a fleet-wide safety investigation in the wake of an emergency landing by a Lancer last month.")
        self.articles = Array(repeating: model, count: 100)
        
        self.tableView.reloadData()
    }
}

extension ArticleListViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.articles.isEmpty ? 0 : 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.articles.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ArticleCell.reuseID, for: indexPath) as! ArticleCell
        cell.configureWith(model: self.articles[indexPath.row])
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
    
    func configureWith(model: TempModel) {
        self.bodyLabel.text = model.body
        self.dateLabel.text = model.date
        
        self.loadingURL = model.imageURL
        ImageLoader.load(url: model.imageURL, completion: { url, image in
            if url == self.loadingURL {
                self.mediaImageView.image = image
            }
        })
    }
}

struct TempModel {
    let imageURL: URL
    let date: String
    let body: String
}

//
//  blog_ios12_performanceTests.swift
//  blog-ios12-performanceTests
//
//  Created by ttillage on 6/8/18.
//  Copyright © 2018 CapTech. All rights reserved.
//

import XCTest
@testable import blog_ios12_performance

class blog_ios12_performanceTests: XCTestCase {
    
    func testCellForRowPerformance() {
        let articlesVC = ArticleListViewController()
        
        articlesVC.articles = [dummyArticle]
        
        let dummyTableView = UITableView()
        dummyTableView.register(UINib(nibName: "ArticleCell", bundle: nil), forCellReuseIdentifier: ArticleCell.reuseID)
        
        self.measure {
            let _ = articlesVC.tableView(dummyTableView, cellForRowAt: IndexPath(row: 0, section: 0))
        }
    }
    
    let dummyArticle: Article = {
        let dummyArticleData =
        """
        {
            "title": "This App Works Great",
            "urlToImage": null,
            "publishedAt": null,
        }
        """.data(using: .utf8)!
        
        return try! JSONDecoder().decode(Article.self, from: dummyArticleData)
    }()
}

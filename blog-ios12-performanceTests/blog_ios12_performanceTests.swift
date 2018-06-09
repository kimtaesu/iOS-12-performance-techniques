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
    
    let dummyArticle: Article =
        Article(
            source: Article.Source(id: nil, name: "nothing"),
            author: "CapTech Consulting",
            title: "This App Works Great",
            description: nil,
            url: nil,
            urlToImage: nil,
            publishedAt: "2018-06-09T18:48:00Z",
            publishedAtDate: nil,
            displayDate: nil,
            nameHighlightedTitle: nil
        )
}

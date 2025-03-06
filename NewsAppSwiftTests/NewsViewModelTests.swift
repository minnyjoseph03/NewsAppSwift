//
//  NewsViewModelTests.swift
//  NewsAppSwiftTests
//
//  Created by Minny on 06/03/25.
//

import XCTest
@testable import NewsAppSwift

final class NewsViewModelTests: XCTestCase {
    
    var viewModel: NewsViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = NewsViewModel()
        viewModel.fetchNews()
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    func testFetchNews() {
        XCTAssertFalse(viewModel.articles.isEmpty, "Articles should not be empty after fetching news")
    }
    
    func testSearchArticles() {
        viewModel.searchArticles(with: "Tech")
        XCTAssertEqual(viewModel.filteredArticles.count, 1, "Should filter only articles containing 'Tech'")
        
        viewModel.searchArticles(with: "")
        XCTAssertEqual(viewModel.filteredArticles.count, viewModel.articles.count, "Empty search should return all articles")
    }
}

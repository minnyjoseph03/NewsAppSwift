//
//  NewsResponse.swift
//  NewsAppSwift
//
//  Created by Minny on 06/03/25.
//

import Foundation

struct Article: Codable {
    let title: String
    let description: String?
    let url: String
    let urlToImage: String?
    let author: String?
}

struct NewsResponse: Codable {
    let articles: [Article]
}

struct ArticleInfo: Codable {
    let likes: Int
    let comments: Int
}


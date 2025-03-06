//
//  NewsViewModel.swift
//  NewsAppSwift
//
//  Created by Minny on 06/03/25.
//

import Foundation
import Combine


class NewsViewModel {
    @Published var articles: [Article] = []
    @Published var filteredArticles: [Article] = []
    private var cancellables = Set<AnyCancellable>()
    var apiKey = "d8757841d4044dca9e756b1b081dd3a4"
    
    func fetchNews() {
        let urlString = "https://newsapi.org/v2/top-headlines?country=us&apiKey=\(apiKey)"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: NewsResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] response in
                self?.articles = response.articles
                self?.filteredArticles = response.articles
            })
            .store(in: &cancellables)
    }
    
    func searchArticles(with query: String) {
        if query.isEmpty {
            filteredArticles = articles
        } else {
            let formattedQuery = query.lowercased()
            filteredArticles = articles.filter { article in
                let title = article.title.lowercased()
                let description = article.description?.lowercased() ?? ""
                
                if formattedQuery.contains("\"") {
                    let exactMatch = formattedQuery.replacingOccurrences(of: "\"", with: "")
                    return title.contains(exactMatch) || description.contains(exactMatch)
                }
                
                let terms = formattedQuery.split(separator: " ")
                var includeTerms: [String] = []
                var excludeTerms: [String] = []
                var hasAndOperator = false
                var hasOrOperator = false
                
                for term in terms {
                    if term.starts(with: "+") {
                        includeTerms.append(String(term.dropFirst()))
                    } else if term.starts(with: "-") {
                        excludeTerms.append(String(term.dropFirst()))
                    } else if term.lowercased() == "and" {
                        hasAndOperator = true
                    } else if term.lowercased() == "or" {
                        hasOrOperator = true
                    } else {
                        includeTerms.append(String(term))
                    }
                }
                
                let matchesInclude = includeTerms.isEmpty || includeTerms.contains { title.contains($0) || description.contains($0) }
                let matchesExclude = excludeTerms.allSatisfy { !title.contains($0) && !description.contains($0) }
                
                if hasAndOperator {
                    return matchesInclude && matchesExclude
                } else if hasOrOperator {
                    return matchesInclude || matchesExclude
                } else {
                    return matchesInclude && matchesExclude
                }
            }
        }
    }
}

//
//  NewsDetailViewController.swift
//  NewsAppSwift
//
//  Created by Minny on 06/03/25.
//

import UIKit
import Combine

class NewsDetailViewController: UIViewController {
    private let article: Article
    private var likes: Int = 0
    private var comments: Int = 0
    private var cancellables = Set<AnyCancellable>()
    
    init(article: Article) {
        self.article = article
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "News Details"
        
        let scrollView = UIScrollView()
        let contentView = UIView()
        
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        if let imageUrl = article.urlToImage, let url = URL(string: imageUrl) {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url) {
                    DispatchQueue.main.async {
                        imageView.image = UIImage(data: data)
                    }
                }
            }
        } else {
            imageView.image = UIImage(systemName: "photo")
        }
        
        let titleLabel = UILabel()
        titleLabel.text = article.title
        titleLabel.font = UIFont.boldSystemFont(ofSize: 22)
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        
        let infoLabel = UILabel()
        infoLabel.text = "Likes: \(likes)  |  Comments: \(comments)"
        infoLabel.font = UIFont.systemFont(ofSize: 14)
        infoLabel.textColor = .gray
        infoLabel.textAlignment = .center
        
        let authorLabel = UILabel()
        authorLabel.text = "By: \(article.author ?? "Unknown")"
        authorLabel.font = UIFont.italicSystemFont(ofSize: 14)
        authorLabel.textAlignment = .center
        authorLabel.textColor = .darkGray
        
        let descriptionLabel = UILabel()
        descriptionLabel.text = article.description ?? "No content available"
        descriptionLabel.font = UIFont.systemFont(ofSize: 16)
        descriptionLabel.numberOfLines = 0
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(infoLabel)
        contentView.addSubview(authorLabel)
        contentView.addSubview(descriptionLabel)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        authorLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.9),
            imageView.heightAnchor.constraint(equalToConstant: 200),
            
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            infoLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            infoLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            infoLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            authorLabel.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: 8),
            authorLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            authorLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            descriptionLabel.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 16),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
        
        fetchArticleInfo { likes, comments in
            DispatchQueue.main.async {
                infoLabel.text = "Likes: \(likes)  |  Comments: \(comments)"
            }
        }
    }
    
    
    private func fetchArticleInfo(completion: @escaping (Int, Int) -> Void) {
        let articleID = article.url.replacingOccurrences(of: "https://", with: "").replacingOccurrences(of: "/", with: "-")
        let likesURL = URL(string: "https://cn-news-info-api.herokuapp.com/likes/\(articleID)")!
        let commentsURL = URL(string: "https://cn-news-info-api.herokuapp.com/comments/\(articleID)")!
        
        let likesPublisher = URLSession.shared.dataTaskPublisher(for: likesURL)
            .map { $0.data }
            .decode(type: ArticleInfo.self, decoder: JSONDecoder())
            .map { $0.likes }
            .replaceError(with: 0)
        
        let commentsPublisher = URLSession.shared.dataTaskPublisher(for: commentsURL)
            .map { $0.data }
            .decode(type: ArticleInfo.self, decoder: JSONDecoder())
            .map { $0.comments }
            .replaceError(with: 0)
        
        Publishers.CombineLatest(likesPublisher, commentsPublisher)
            .receive(on: DispatchQueue.main)
            .sink { likes, comments in
                completion(likes, comments)
            }
            .store(in: &cancellables)
    }
}

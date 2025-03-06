//
//  ViewController.swift
//  NewsAppSwift
//
//  Created by Minny on 06/03/25.
//

import UIKit
import Combine

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    private let tableView = UITableView()
       private let searchBar = UISearchBar()
       private var viewModel = NewsViewModel()
       private var cancellables = Set<AnyCancellable>()
       
       override func viewDidLoad() {
           super.viewDidLoad()
           setupUI()
           bindViewModel()
           viewModel.fetchNews()
       }
       
       private func setupUI() {
           title = "News"
           navigationController?.navigationBar.prefersLargeTitles = true
           view.backgroundColor = .systemBackground
           
           searchBar.delegate = self
           searchBar.placeholder = "Search articles"
           
           view.addSubview(searchBar)
           view.addSubview(tableView)
           
           searchBar.translatesAutoresizingMaskIntoConstraints = false
           tableView.translatesAutoresizingMaskIntoConstraints = false
           
           NSLayoutConstraint.activate([
               searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
               searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
               searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
               
               tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
               tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
               tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
               tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
           ])
           
           tableView.dataSource = self
           tableView.delegate = self
           tableView.estimatedRowHeight = 120
           tableView.rowHeight = UITableView.automaticDimension
           tableView.backgroundColor = .systemBackground
           tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: "NewsCell")
       }
       
       private func bindViewModel() {
           viewModel.$filteredArticles
               .receive(on: DispatchQueue.main)
               .sink { [weak self] _ in self?.tableView.reloadData() }
               .store(in: &cancellables)
       }
       
       func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
           viewModel.searchArticles(with: searchText)
       }
       
       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return viewModel.filteredArticles.count
       }
       
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as? NewsTableViewCell else {
                return UITableViewCell()
            }
            let article = viewModel.filteredArticles[indexPath.row]
            cell.configure(with: article)
            cell.backgroundColor = .systemBackground
            cell.accessoryType = .disclosureIndicator
            return cell
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            tableView.deselectRow(at: indexPath, animated: true)
            let article = viewModel.filteredArticles[indexPath.row]
            let detailVC = NewsDetailViewController(article: article)
            navigationController?.pushViewController(detailVC, animated: true)
        }
   }

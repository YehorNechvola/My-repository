//
//  SavedArticlesUIViewController.swift
//  Wall Street news
//
//  Created by Егор on 30.07.2022.
//

import UIKit

class SavedArticlesUIViewController: UIViewController {
    
    // MARK: - Properties
    
    var presenter: SavedArticlesPresenterProtocol!

    // MARK: - Outlets
    
    @IBOutlet private weak var savedArticlesTableView: UITableView!
    @IBOutlet private weak var infoForUserLabel: UILabel!
    
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cleanButton = UIBarButtonItem(title: "clean all", style: .plain, target: self, action: #selector(cleanItemTapped))
        navigationItem.rightBarButtonItem = cleanButton
        title = "Saved articles"
        showSavedArticles()
        infoForUserLabel.text = "You don't have any saved articles yet"
        showSavedArticles()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        Router.currentNavigationController = .second
        showSavedArticles()
        presenter.getSavedArticles()
        savedArticlesTableView.reloadData()
    }
    
    // MARK: - Methods

    private func setupTableView() {
        savedArticlesTableView.register(ArticleTableViewCell.nib, forCellReuseIdentifier: ArticleTableViewCell.identifier)
        savedArticlesTableView.delegate = self
        savedArticlesTableView.dataSource = self
    }
    
    @objc private func cleanItemTapped() {
        presenter.articles = []
        presenter.cleanAllArticles()
        savedArticlesTableView.reloadData()
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension SavedArticlesUIViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        160
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let arr = presenter.articles.uniqued()
        return arr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ArticleTableViewCell.identifier, for: indexPath) as! ArticleTableViewCell
        let arr = presenter.articles.uniqued()
        let article = arr[indexPath.row]
        cell.setup(title: article.title!, and: article.publishedAt!, with: article.author!)
        let image = UIImage(data: article.imageData ?? Data())
        cell.setup(image: image ?? UIImage())
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let article = presenter.articles[indexPath.row]
        let image = UIImage(data: article.imageData ?? Data())
        presenter.router.showArticleViewController(article: article, with: image!)
    }
}

// MARK: - SavedArticlesViewProtocol

extension SavedArticlesUIViewController: SavedArticlesViewProtocol {
    
    func showSavedArticles() {
        
        if !(savedArticlesTableView.numberOfRows(inSection: 0) == 0) {
            infoForUserLabel.isHidden = true
        } else {
            infoForUserLabel.isHidden = false
        }
    }
}

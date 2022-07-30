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
        
        setupTableView()
        showSavedArticles()
    }
    
    // MARK: - Methods

    private func setupTableView() {
        savedArticlesTableView.register(ArticleTableViewCell.nib, forCellReuseIdentifier: ArticleTableViewCell.identifier)
        savedArticlesTableView.delegate = self
        savedArticlesTableView.dataSource = self
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension SavedArticlesUIViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ArticleTableViewCell.identifier, for: indexPath) as! ArticleTableViewCell
        return cell
    }
}

// MARK: - SavedArticlesViewProtocol

extension SavedArticlesUIViewController: SavedArticlesViewProtocol {
    
    func showSavedArticles() {
        let articles = presenter.getSavedArticles()
        if articles == nil {
            infoForUserLabel.text = "You don't have any saved articles yet"
        } else {
            infoForUserLabel.isHidden = true
        }
    }
}

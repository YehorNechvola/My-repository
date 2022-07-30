//
//  JournalViewController.swift
//  Wall Street news
//
//  Created by Егор on 14.07.2022.
//

import UIKit

class JournalViewController: UIViewController {
    
    // MARK: - Properties
    
    var presenter: JournalViewPresenterProtocol!
    let activityIndicator = UIActivityIndicatorView()
    
    // MARK: - Outlets
    
    @IBOutlet private weak var journalTableView: UITableView!
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupActivityIndicator()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        title = "Articles"
        setupTableView()
    }
    
    // MARK: - Methods
    
    private func setupTableView() {
        journalTableView.delegate = self
        journalTableView.dataSource = self
        journalTableView.register(ArticleTableViewCell.nib, forCellReuseIdentifier: ArticleTableViewCell.identifier)
    }
    
    private func setupActivityIndicator() {
        activityIndicator.center = view.center
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
}

// MARK: - TableViewDelegate, TableViewDatasourse

extension JournalViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let journal = presenter.journal else { return 0 }
        return journal.articles?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let journal = presenter.journal else { return UITableViewCell() }
        let article = journal.articles?[indexPath.row]
        let image = presenter.images[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ArticleTableViewCell.identifier, for: indexPath) as! ArticleTableViewCell
        
        cell.setup(title: article?.title ?? "", and: article?.publishedAt ?? "", with: article?.author ?? "")
        cell.setup(image: image)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let journal = presenter.journal else { return }
        guard let article = journal.articles?[indexPath.row] else { return }
        let image = presenter.images[indexPath.row]
        presenter.router?.showArticleViewCOntroller(article: article, with: image)
    }
}

 // MARK: - JournalViewProtocol

extension JournalViewController: JournalViewProtocol {
    
    func succes() {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
        journalTableView.reloadData()
    }
    
    func failure(_ error: Error) {
        print(error)
    }
}

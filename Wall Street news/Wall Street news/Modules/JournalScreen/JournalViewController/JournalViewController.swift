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
    let refreshContol = UIRefreshControl()
    
    // MARK: - Outlets
    
    @IBOutlet private weak var journalTableView: UITableView!
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupActivityIndicator()
        setupRefreshControl()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        Router.currentNavigationController = .first
        setupTableView()
    }
    
    // MARK: - Methods
    
    private func setupTableView() {
        title = "Articles"
        journalTableView.delegate = self
        journalTableView.dataSource = self
        journalTableView.register(ArticleTableViewCell.nib, forCellReuseIdentifier: ArticleTableViewCell.identifier)
    }
    
    private func setupActivityIndicator() {
        view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.startAnimating()
    }
    
    private func setupRefreshControl() {
        journalTableView.addSubview(refreshContol)
        refreshContol.addTarget(self, action: #selector(refresh), for: .valueChanged)
    }
    
    @objc private func refresh() {
        presenter.getJournal()
        journalTableView.reloadData()
        refreshContol.endRefreshing()
    }
}

// MARK: - TableViewDelegate, TableViewDatasourse

extension JournalViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
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
        
        cell.delegate = self
        cell.setup(title: article?.title ?? "", and: article?.publishedAt ?? "", with: article?.author ?? "")
        cell.setup(image: image)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let journal = presenter.journal else { return }
        guard let article = journal.articles?[indexPath.row] else { return }
        let image = presenter.images[indexPath.row]
        presenter.router?.showArticleViewController(article: article, with: image)
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

// MARK: - ArticleTableViewCellProtocol

extension JournalViewController: ArticleTableViewCellProtocol {
    
    func saveArticle(in cell: ArticleTableViewCell) {
        guard let indexPath = journalTableView.indexPath(for: cell) else { return }
        guard let journal = presenter.journal else { return }
        guard let article = journal.articles?[indexPath.row] else { return }
        let image = presenter.images[indexPath.row]
        presenter.saveArticle(article: article, image: image)
    }
}



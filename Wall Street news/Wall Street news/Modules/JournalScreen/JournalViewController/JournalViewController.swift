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
    private let activityIndicator = UIActivityIndicatorView()
    private let refreshContol = UIRefreshControl()
    private var selectedButtonIndicies: [Int] = []
    
    // MARK: - Outlets
    
    @IBOutlet private weak var journalTableView: UITableView!
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        checkInternetConnection()
        setupActivityIndicator()
        setupRefreshControl()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        Router.currentNavigationController = .first
        selectedButtonIndicies = presenter.getSavedArticles()
        reloadDataIfNeeded(in: journalTableView)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        setDefaultButtonState()
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
        selectedButtonIndicies = presenter.getSavedArticles()
    }
    
    private func setDefaultButtonState() {
        selectedButtonIndicies = []
    }
    
    private func checkInternetConnection() {
        if !NetworkMonitor.shared.isConnected {
            showInternetConnectionAlert {
                self.presenter.getJournal()
            }
        }
    }
}

// MARK: - TableViewDelegate, TableViewDatasourse

extension JournalViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.heightForRow
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let journal = presenter.journal else { return 0 }
        return journal.articles?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let journal = presenter.journal else { return UITableViewCell() }
        let article = journal.articles?[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: ArticleTableViewCell.identifier, for: indexPath) as! ArticleTableViewCell
        
        cell.delegate = self
        cell.setup(title: article?.title ?? "", date: article?.publishedAt ?? "", author: article?.author ?? "")
        cell.setup(imageData: article?.imageData)
        cell.setTag(by: indexPath)
        cell.handleStateOfSaveButtons(with: selectedButtonIndicies)
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let journal = presenter.journal else { return }
        guard let article = journal.articles?[indexPath.row] else { return }
        presenter.tapOnArticle(article: article)
    }
}

 // MARK: - JournalViewProtocol

extension JournalViewController: JournalViewProtocol {
    func endRefreshingWhenNoUpdates() {
        refreshContol.endRefreshing()
    }
    
    func succes() {
        activityIndicator.stopAnimating()
        selectedButtonIndicies = presenter.getSavedArticles()
        UIView.transition(with: journalTableView,
                          duration: 0.5,
                          options: .transitionCrossDissolve) { self.journalTableView.reloadData() }
        if refreshContol.isRefreshing {
            refreshContol.endRefreshing()
        }
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
        presenter.saveArticle(article: article)
    }
    
    func saveTagOfPressedButton(sender: UIButton) {
        selectedButtonIndicies.append(sender.tag)
    }
}



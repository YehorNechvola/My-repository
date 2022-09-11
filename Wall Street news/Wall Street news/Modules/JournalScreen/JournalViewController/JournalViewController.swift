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
        
        checkInternetConnection()
        setupActivityIndicator()
        setupRefreshControl()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        selectedButtonIndicies = presenter.getSavedArticles()
        Router.currentNavigationController = .first
        setupTableView()
        journalTableView.reloadData()
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
        setDefaultButtonState()
        refreshContol.endRefreshing()
    }
    
    private func setDefaultButtonState() {
        selectedButtonIndicies = []
    }
    
    private func checkInternetConnection() {
        if !NetworkMonitor.shared.isConnected {
            showInternetConnectionAlert {
                self.presenter.getJournal()
                self.journalTableView.reloadData()
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
        let image = presenter.images[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ArticleTableViewCell.identifier, for: indexPath) as! ArticleTableViewCell
        
        cell.delegate = self
        cell.setup(title: article?.title ?? "", date: article?.publishedAt ?? "", author: article?.author ?? "")
        cell.setup(image: image)
        cell.setTag(by: indexPath)
        cell.handleStateOfSaveButtons(with: selectedButtonIndicies)
    
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
    func showAlertWhenThereAreNoUpdates() {
        let alert = UIAlertController(title: nil, message: "There are no new articles", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(alertAction)
        self.present(alert, animated: true)
    }
    
    func succes() {
        activityIndicator.stopAnimating()
        selectedButtonIndicies = presenter.getSavedArticles()
        UIView.transition(with: journalTableView,
                          duration: 0.5,
                          options: .transitionCrossDissolve) { self.journalTableView.reloadData() }
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
    
    func saveTagOfPressedButton(sender: UIButton) {
        selectedButtonIndicies.append(sender.tag)
    }
}



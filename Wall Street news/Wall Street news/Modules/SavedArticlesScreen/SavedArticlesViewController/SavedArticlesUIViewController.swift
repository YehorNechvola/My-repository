

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
        
        createRightBarButtonItem()
        setTitles()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        Router.currentNavigationController = .second
        presenter.getSavedArticles()
        showHideInfoLabelForUser()
        reloadDataIfNeeded(in: savedArticlesTableView)
    }
    
    // MARK: - Methods

    private func setupTableView() {
        savedArticlesTableView.register(ArticleTableViewCell.nib, forCellReuseIdentifier: ArticleTableViewCell.identifier)
        savedArticlesTableView.delegate = self
        savedArticlesTableView.dataSource = self
        savedArticlesTableView.reloadData()
    }
    
    private func createRightBarButtonItem() {
        let cleanButton = UIBarButtonItem(title: "clean", style: .plain, target: self, action: #selector(cleanItemTapped))
        navigationItem.rightBarButtonItem = cleanButton
    }
    
    @objc private func cleanItemTapped() {
        
        presenter.articles = []
        presenter.cleanAllArticles()
        
        UIView.transition(with: savedArticlesTableView,
                          duration: 0.5,
                          options: .transitionCrossDissolve) { self.savedArticlesTableView.reloadData() }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.infoForUserLabel.isHidden = false
        }
    }

    private func setTitles() {
        title = "Saved articles"
        infoForUserLabel.text = "You don't have any saved articles yet"
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension SavedArticlesUIViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        Constants.heightForRow
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ArticleTableViewCell.identifier, for: indexPath) as! ArticleTableViewCell
        cell.deleteArticleDelegate = self
        let article = presenter.articles[indexPath.row]
        cell.setup(title: article.title ?? "" , date: article.publishedAt ?? "", author: article.author ?? "")
        cell.setup(imageData: article.imageData)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let article = presenter.articles[indexPath.row]
        presenter.tapOnArticle(article: article)
    }
}

// MARK: - SavedArticlesViewProtocol

extension SavedArticlesUIViewController: SavedArticlesViewProtocol {
    
    func showHideInfoLabelForUser() {
        presenter.articles.count != 0 ? (infoForUserLabel.isHidden = true) : (infoForUserLabel.isHidden = false)
    }
}

// MARK: - DeleteArticleInTableViewCellProtocol

extension SavedArticlesUIViewController: DeleteArticleInTableViewCellProtocol {
    
    func deleteArticle(in cell: ArticleTableViewCell) {
        guard let indexPath = savedArticlesTableView.indexPath(for: cell) else { return }
        let article = presenter.articles[indexPath.row]
        presenter.deleteArticle(by: article.title ?? "no matches")
        presenter.getSavedArticles()
        savedArticlesTableView.deleteRows(at: [indexPath], with: .left)
        showHideInfoLabelForUser()
    }
}

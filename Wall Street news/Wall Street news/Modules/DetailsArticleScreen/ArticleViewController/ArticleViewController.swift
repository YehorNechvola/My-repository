//
//  ArticleViewController.swift
//  Wall Street news
//
//  Created by Егор on 17.07.2022.
//

import UIKit

class ArticleViewController: UIViewController {
    
    // MARK: - Properties
    
    var presenter: ArticleViewPresenterProtocol!
    
    // MARK: - Outlets
    
    @IBOutlet private weak var articleImageView: UIImageView!
    @IBOutlet private weak var titleAtricleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var authorLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Details"
        presenter.setArticle()
    }
    
    // MARK: - Methods
    
    private func setupLabels() {
        titleAtricleLabel.sizeToFit()
        descriptionLabel.sizeToFit()
        authorLabel.sizeToFit()
        dateLabel.sizeToFit()
    }
    
    // MARK: - Actions
    
    @IBAction private func readFullArticlePressed(_ sender: UIButton) {
        
        guard let url = self.presenter.article?.url else { return }
        self.presenter.router?.showFullArticleViewController(by: url)
    }
}

// MARK: - ArticleViewProtocol

extension ArticleViewController: ArticleViewProtocol {
    
    func setArticle(article: Article, with image: UIImage) {
        titleAtricleLabel.text = article.title
        articleImageView.image = image
        descriptionLabel.text = article.description
        authorLabel.text = article.author
        guard let date = article.publishedAt?.format() else { return }
        dateLabel.text = date
    }
}

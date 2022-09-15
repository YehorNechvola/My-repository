//
//  ArticlePresenter.swift
//  Wall Street news
//
//  Created by Егор on 17.07.2022.
//

import UIKit

// MARK: - Protocols

protocol ArticleViewProtocol: AnyObject {
    func setArticle(article: Article)
}

protocol ArticleViewPresenterProtocol: AnyObject {
    init(view: ArticleViewProtocol, router: RouterProtocol, article: Article)
    var router: RouterProtocol? { get set }
    var article: Article? { get set }
    func setArticle()
}

class ArticleViewPresenter: ArticleViewPresenterProtocol {
 
    // MARK: - Properties
    
    weak var view: ArticleViewProtocol?
    var router: RouterProtocol?
    var article: Article?
    
    // MARK: - Initializer
    
    required init(view: ArticleViewProtocol, router: RouterProtocol, article: Article) {
        self.view = view
        self.router = router
        self.article = article
    }
    
    // MARK: - Methods
    
    public func setArticle() {
        guard let article = article else { return }
        
        view?.setArticle(article: article)
    }
}

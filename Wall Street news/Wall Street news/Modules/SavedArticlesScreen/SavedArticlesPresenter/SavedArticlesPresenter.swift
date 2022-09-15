//
//  SavedArticlesPresenter.swift
//  Wall Street news
//
//  Created by Егор on 30.07.2022.
//

import Foundation

// MARK: - Protocols

protocol SavedArticlesViewProtocol: AnyObject {
    func showHideInfoLabelForUser()
}

protocol SavedArticlesPresenterProtocol: AnyObject {
    init(view: SavedArticlesViewProtocol, router: RouterProtocol, coreDataManager: CoreDataManagerProtocol)
    var articles: [Article] { get set }
    func getSavedArticles()
    func cleanAllArticles()
    func deleteArticle(by title: String)
    func tapOnArticle(article: Article)
}

class SavedArticlesPresenter: SavedArticlesPresenterProtocol {

    // MARK: - Properties
    
    weak var view: SavedArticlesViewProtocol?
    var router: RouterProtocol
    var coreDataManager: CoreDataManagerProtocol
    var articles: [Article] = []
    
    // MARK: - Inializer
    
    required init(view: SavedArticlesViewProtocol, router: RouterProtocol, coreDataManager: CoreDataManagerProtocol) {
        self.view = view
        self.router = router
        self.coreDataManager = coreDataManager
    }
    
    // MARK: - Methods
    
    func getSavedArticles()   {
        articles = coreDataManager.fetchArticles()
    }
    
    func cleanAllArticles() {
        coreDataManager.cleanAllObjects()
    }
    
    func deleteArticle(by title: String) {
        coreDataManager.deleteArticle(by: title)
    }
    
    func tapOnArticle(article: Article) {
        router.showArticleViewController(article: article)
    }
}

//
//  SavedArticlesPresenter.swift
//  Wall Street news
//
//  Created by Егор on 30.07.2022.
//

import Foundation

protocol SavedArticlesViewProtocol: AnyObject {
    func showHideInfoLabelForUser()
}

protocol SavedArticlesPresenterProtocol: AnyObject {
    init(view: SavedArticlesViewProtocol, router: RouterProtocol, coreDataManager: CoreDataManagerProtocol)
    func getSavedArticles()
    func cleanAllArticles()
    func deleteArticle(by title: String)
    var articles: [Article] { get set }
    var router: RouterProtocol { get set }
}

class SavedArticlesPresenter: SavedArticlesPresenterProtocol {

    weak var view: SavedArticlesViewProtocol?
    var router: RouterProtocol
    var coreDataManager: CoreDataManagerProtocol
    var articles: [Article] = []
    
    required init(view: SavedArticlesViewProtocol, router: RouterProtocol, coreDataManager: CoreDataManagerProtocol) {
        self.view = view
        self.router = router
        self.coreDataManager = coreDataManager
    }
    
    func getSavedArticles()   {
        articles = coreDataManager.fetchArticles()
    }
    
    func cleanAllArticles() {
        coreDataManager.cleanAllObjects()
    }
    
    func deleteArticle(by title: String) {
        coreDataManager.deleteArticle(by: title)
    }
}

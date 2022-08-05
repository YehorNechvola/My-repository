//
//  SavedArticlesPresenter.swift
//  Wall Street news
//
//  Created by Егор on 30.07.2022.
//

import Foundation

protocol SavedArticlesViewProtocol: AnyObject {
    func showSavedArticles()
}

protocol SavedArticlesPresenterProtocol: AnyObject {
    init(view: SavedArticlesViewProtocol, router: RouterProtocol, coreDataManager: CoreDataManagerProtocol)
    func getSavedArticles()
    func cleanAllArticles()
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
}

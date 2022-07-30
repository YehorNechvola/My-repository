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
    init(view: SavedArticlesViewProtocol, router: RouterProtocol)
    func getSavedArticles() -> [Article]?
}

class SavedArticlesPresenter: SavedArticlesPresenterProtocol {

    weak var view: SavedArticlesViewProtocol?
    var router: RouterProtocol
    
    required init(view: SavedArticlesViewProtocol, router: RouterProtocol) {
        self.view = view
        self.router = router
    }
    
    func getSavedArticles() -> [Article]? {
        return nil
    }
}

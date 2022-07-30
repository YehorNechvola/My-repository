//
//  FullArticlePresenter.swift
//  Wall Street news
//
//  Created by Егор on 30.07.2022.
//

import Foundation

protocol FullArticleViewProtocol: AnyObject {
    func showFullArticle()
}

protocol FullArticlePresenterProtocol: AnyObject {
    init(view: FullArticleViewProtocol, router: RouterProtocol, urlToArticle: String)
    var urlToArticle: String? { get set }
}

class FullArticlePresenter: FullArticlePresenterProtocol {
    
    weak var view: FullArticleViewProtocol?
    var router: RouterProtocol
    var urlToArticle: String?
    
    required init(view: FullArticleViewProtocol, router: RouterProtocol, urlToArticle: String) {
        self.view = view
        self.router = router
        self.urlToArticle = urlToArticle
    }
}

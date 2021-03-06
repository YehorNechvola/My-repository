//
//  ArticlePresenter.swift
//  Wall Street news
//
//  Created by Егор on 17.07.2022.
//

import UIKit

protocol ArticleViewProtocol: AnyObject {
    func setArticle(article: Article, with image: UIImage)
}

protocol ArticleViewPresenterProtocol: AnyObject {
    init(view: ArticleViewProtocol, router: RouterProtocol, article: Article, with image: UIImage)
    var article: Article? { get set }
    var imageArticle: UIImage? { get set }
    func setArticle()
}

class ArticleViewPresenter: ArticleViewPresenterProtocol {
 
    weak var view: ArticleViewProtocol?
    var router: RouterProtocol?
    var article: Article?
    var imageArticle: UIImage?
    
    required init(view: ArticleViewProtocol, router: RouterProtocol, article: Article, with image: UIImage) {
        self.view = view
        self.router = router
        self.article = article
        self.imageArticle = image
    }
    
    public func setArticle() {
        guard let article = article else { return }
        guard let image = imageArticle else { return }
        
        view?.setArticle(article: article, with: image)
    }
}

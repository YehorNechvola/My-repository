//
//  ModuleBuilder.swift
//  Wall Street news
//
//  Created by Егор on 15.07.2022.
//

import UIKit

protocol AssemblyBuilderProtocol: AnyObject {
    func createJournalModule(router: RouterProtocol) -> JournalViewController
    func createArticleModule(router: RouterProtocol, article: Article, with image: UIImage) -> ArticleViewController
    func createSavedArticleModule(router: RouterProtocol) -> SavedArticlesUIViewController
    func createFullArticleModule(router: RouterProtocol, urlToArticle: String) -> FullArticleViewController
}

class AssemblyBuilder: AssemblyBuilderProtocol {
    
    func createJournalModule(router: RouterProtocol) -> JournalViewController {
        let view = JournalViewController()
        let networkService = NetworkService()
        let presenter = JournalViewPresenter(view: view, router: router, networkService: networkService)
        view.presenter = presenter
        return view
    }
    
    func createArticleModule(router: RouterProtocol, article: Article, with image: UIImage) -> ArticleViewController {
        let view = ArticleViewController()
        let presenter = ArticleViewPresenter(view: view, router: router, article: article, with: image)
        view.presenter = presenter
        return view
    }
    
    func createSavedArticleModule(router: RouterProtocol) -> SavedArticlesUIViewController {
        let view = SavedArticlesUIViewController()
        let presenter = SavedArticlesPresenter(view: view, router: router)
        view.presenter = presenter
        return view
    }
    
    func createFullArticleModule(router: RouterProtocol, urlToArticle: String) -> FullArticleViewController {
        let view = FullArticleViewController()
        let presenter = FullArticlePresenter(view: view, router: router, urlToArticle: urlToArticle)
        view.presenter = presenter
        return view
    }
}

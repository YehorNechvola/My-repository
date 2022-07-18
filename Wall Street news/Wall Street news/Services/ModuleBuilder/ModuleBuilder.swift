//
//  ModuleBuilder.swift
//  Wall Street news
//
//  Created by Егор on 15.07.2022.
//

import UIKit

protocol ModuleBuilderProtocol: AnyObject {
    static func createJournalModule() -> JournalViewController
    static func createArticleModule(article: Article) -> ArticleViewController
}

class ModuleBuilder: ModuleBuilderProtocol {
    
    static func createJournalModule() -> JournalViewController {
        let view = JournalViewController()
        let networkService = NetworkService()
        let presenter = JournalViewPresenter(view: view, networkService: networkService)
        view.presenter = presenter
        return view
    }
    
    static func createArticleModule(article: Article) -> ArticleViewController {
        let view = ArticleViewController()
        let presenter = ArticleViewPresenter(view: view, article: article)
        view.presenter = presenter
        return view
    }
}

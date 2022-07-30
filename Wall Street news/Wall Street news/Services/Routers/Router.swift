//
//  JournalRouter.swift
//  Wall Street news
//
//  Created by Егор on 20.07.2022.
//

import UIKit

protocol RouterMainProtocol: AnyObject {
    var firstNavigationController: UINavigationController? { get set }
    var secondNavigationController: UINavigationController? { get set }
    var assemblyBuilder: AssemblyBuilderProtocol? { get set }
}

protocol RouterProtocol: RouterMainProtocol {
    func initialJournalViewController()
    func showArticleViewController(article: Article, with image: UIImage)
    func initialSavedArticlesViewController()
    func showFullArticleViewController(by urlToArticle: String)
}

class Router: RouterProtocol {
    
    var firstNavigationController: UINavigationController?
    var secondNavigationController: UINavigationController?
    var assemblyBuilder: AssemblyBuilderProtocol?
    
    init(navigationControllers: [UINavigationController], assemblyBuilder: AssemblyBuilderProtocol) {
        firstNavigationController = navigationControllers[0]
        secondNavigationController = navigationControllers[1]
        firstNavigationController?.tabBarItem = UITabBarItem(tabBarSystemItem: .mostRecent, tag: 0)
        secondNavigationController?.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 1)
        self.assemblyBuilder = assemblyBuilder
    }
    
    func initialJournalViewController() {
        if let journalViewController = assemblyBuilder?.createJournalModule(router: self) {
            firstNavigationController?.viewControllers = [journalViewController]
        }
    }
    
    func showArticleViewController(article: Article, with image: UIImage) {
        if let articleViewController = assemblyBuilder?.createArticleModule(router: self, article: article, with: image) {
            firstNavigationController?.pushViewController(articleViewController, animated: true)
        }
    }
    
    func initialSavedArticlesViewController() {
        if let savedArticlesViewController = assemblyBuilder?.createSavedArticleModule(router: self) {
            secondNavigationController?.viewControllers = [savedArticlesViewController]
        }
    }
    
    func showFullArticleViewController(by urlToArticle: String) {
        
        if let fullArticleViewController = assemblyBuilder?.createFullArticleModule(router: self, urlToArticle: urlToArticle) {
            firstNavigationController?.pushViewController(fullArticleViewController, animated: true)
        }
    }
}

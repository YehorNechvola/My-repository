//
//  JournalRouter.swift
//  Wall Street news
//
//  Created by Егор on 20.07.2022.
//

import UIKit

enum NavigationControllers {
    case first
    case second
}

// MARK: - Protocols

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
    
    //MARK: - Properties
    
    static var currentNavigationController: NavigationControllers = .first
    
    var firstNavigationController: UINavigationController?
    var secondNavigationController: UINavigationController?
    var assemblyBuilder: AssemblyBuilderProtocol?
    
    //MARK: - Initializer
    
    init(navigationControllers: [UINavigationController], assemblyBuilder: AssemblyBuilderProtocol) {
        firstNavigationController = navigationControllers[0]
        secondNavigationController = navigationControllers[1]
        firstNavigationController?.tabBarItem = UITabBarItem(tabBarSystemItem: .mostRecent, tag: 0)
        secondNavigationController?.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 1)
        self.assemblyBuilder = assemblyBuilder
    }
    
    //MARK: - Methods
    
    func initialJournalViewController() {
        if let journalViewController = assemblyBuilder?.createJournalModule(router: self) {
            firstNavigationController?.viewControllers = [journalViewController]
        }
    }
    
    func showArticleViewController(article: Article, with image: UIImage) {
        if let articleViewController = assemblyBuilder?.createArticleModule(router: self, article: article, with: image) {
            
            switch Router.currentNavigationController {
            case .first:
                firstNavigationController?.pushViewController(articleViewController, animated: true)
            case .second:
                secondNavigationController?.pushViewController(articleViewController, animated: true)
            }
        }
    }
    
    func initialSavedArticlesViewController() {
        if let savedArticlesViewController = assemblyBuilder?.createSavedArticleModule(router: self) {
            secondNavigationController?.viewControllers = [savedArticlesViewController]
        }
    }
    
    func showFullArticleViewController(by urlToArticle: String) {
        
        if let fullArticleViewController = assemblyBuilder?.createFullArticleModule(router: self, urlToArticle: urlToArticle) {
            
            switch Router.currentNavigationController {
            case .first:
                firstNavigationController?.pushViewController(fullArticleViewController, animated: true)
            case .second:
                secondNavigationController?.pushViewController(fullArticleViewController, animated: true)
            }
        }
    }
}

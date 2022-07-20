//
//  JournalRouter.swift
//  Wall Street news
//
//  Created by Егор on 20.07.2022.
//

import UIKit

protocol RouterMainProtocol: AnyObject {
    var navigationController: UINavigationController? { get set }
    var assemblyBuilder: AssemblyBuilderProtocol? { get set }
}

protocol RouterProtocol: RouterMainProtocol {
    func initialJournalViewController()
    func showArticleViewCOntroller(article: Article, with image: UIImage)
}

class Router: RouterProtocol {
    var navigationController: UINavigationController?
    var assemblyBuilder: AssemblyBuilderProtocol?
    
    init(navigationController: UINavigationController, assemblyBuilder: AssemblyBuilderProtocol) {
        self.navigationController = navigationController
        self.assemblyBuilder = assemblyBuilder
    }
    
    func initialJournalViewController() {
        if let journalViewController = assemblyBuilder?.createJournalModule(router: self) {
            navigationController?.viewControllers = [journalViewController]
        }
    }
    
    func showArticleViewCOntroller(article: Article, with image: UIImage) {
        if let articleViewController = assemblyBuilder?.createArticleModule(router: self, article: article, with: image) {
            print(article)
            navigationController?.pushViewController(articleViewController, animated: true)
        }
    }
}

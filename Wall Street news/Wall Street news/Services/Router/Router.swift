

import UIKit

enum NavigationControllers {
    case first
    case second
}

// MARK: - Protocols

protocol RouterMainProtocol: AnyObject {
    var mainNavigationController: UINavigationController? { get set }
    var firstNavigationController: UINavigationController? { get set }
    var secondNavigationController: UINavigationController? { get set }
    var assemblyBuilder: AssemblyBuilderProtocol? { get set }
}

protocol RouterProtocol: RouterMainProtocol {
    func initialJournalViewController()
    func showArticleViewController(article: Article)
    func initialSavedArticlesViewController()
    func showFullArticleViewController(by urlToArticle: String)
    func popViewController()
}

class Router: RouterProtocol {
    
    //MARK: - Properties
    
    static var currentNavigationController: NavigationControllers = .first
    
    var mainNavigationController: UINavigationController?
    var firstNavigationController: UINavigationController?
    var secondNavigationController: UINavigationController?
    var assemblyBuilder: AssemblyBuilderProtocol?
    
    //MARK: - Initializer
    
    init(mainNavigationController: UINavigationController,
         navigationControllers: [UINavigationController],
         assemblyBuilder: AssemblyBuilderProtocol) {
        
        self.mainNavigationController = mainNavigationController
        self.assemblyBuilder = assemblyBuilder
        firstNavigationController = navigationControllers[0]
        secondNavigationController = navigationControllers[1]
        firstNavigationController?.tabBarItem = UITabBarItem(tabBarSystemItem: .mostRecent, tag: 0)
        secondNavigationController?.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 1)
        self.mainNavigationController?.isNavigationBarHidden = true
    }
    
    //MARK: - Methods
    
    func initialJournalViewController() {
        if let journalViewController = assemblyBuilder?.createJournalModule(router: self) {
            firstNavigationController?.viewControllers = [journalViewController]
        }
    }
    
    func showArticleViewController(article: Article) {
        if let articleViewController = assemblyBuilder?.createArticleModule(router: self, article: article) {
            
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
            mainNavigationController?.pushViewController(fullArticleViewController, animated: true)
        }
    }
    
    func popViewController() {
        mainNavigationController?.popViewController(animated: true)
    }
}

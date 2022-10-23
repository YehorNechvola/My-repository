

import UIKit

//MARK: - Entry point helper

extension SceneDelegate {
    
    func makeEntryPoint(windowScene: UIWindowScene) {
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        
        let mainNavigationController = UINavigationController()
        let tabBarController = UITabBarController()
        tabBarController.tabBar.tintColor = .black
        
        let firstNavigationController = UINavigationController()
        let secondNavigationController = UINavigationController()
        mainNavigationController.viewControllers = [tabBarController]
        let navigationControllers = [firstNavigationController, secondNavigationController]
        tabBarController.viewControllers = navigationControllers
        
        let assemblyBuilder = AssemblyBuilder()
        let router = Router(mainNavigationController: mainNavigationController,
                            navigationControllers: navigationControllers,
                            assemblyBuilder: assemblyBuilder)
        
        router.initialJournalViewController()
        router.initialSavedArticlesViewController()
        window?.rootViewController = mainNavigationController
        window?.makeKeyAndVisible()
    }
}

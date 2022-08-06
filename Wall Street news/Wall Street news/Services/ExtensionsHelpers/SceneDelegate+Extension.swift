//
//  SceneDelegate+Extension.swift
//  Wall Street news
//
//  Created by Егор on 30.07.2022.
//

import UIKit

extension SceneDelegate {
    
    func makeEntryPoint(windowScene: UIWindowScene) {
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        
        let tabBarController = UITabBarController()
        tabBarController.tabBar.tintColor = .black
        let firstNavigationController = UINavigationController()
        let secondNavigationController = UINavigationController()
        let navigationControllers = [firstNavigationController, secondNavigationController]
        tabBarController.viewControllers = navigationControllers
        let assemblyBuilder = AssemblyBuilder()
        let router = Router(navigationControllers: navigationControllers, assemblyBuilder: assemblyBuilder)
        router.initialJournalViewController()
        router.initialSavedArticlesViewController()
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
    }
}

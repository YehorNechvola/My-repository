//
//  ModuleBuilder.swift
//  Wall Street news
//
//  Created by Егор on 15.07.2022.
//

import UIKit

protocol ModuleBuilderProtocol: AnyObject {
    static func createJournalModule() -> UIViewController
}

class ModuleBuilder: ModuleBuilderProtocol {
    
    static func createJournalModule() -> UIViewController {
        let view = JournalViewController()
        let networkService = NetworkService()
        let presenter = JournalViewPresenter(view: view, networkService: networkService)
        view.presenter = presenter
        return view
    }
}

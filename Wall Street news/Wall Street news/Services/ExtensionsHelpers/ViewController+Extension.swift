//
//  ViewController+Extension.swift
//  Wall Street news
//
//  Created by Егор on 15.10.2022.
//

import UIKit

// MARK: - Reload data in tableview helper

extension UIViewController {
    
    func reloadDataIfNeeded(in tableview: UITableView) {
        if CasesToReloadTableView.stateOfAction == .deleteArticle {
            tableview.reloadData()
            CasesToReloadTableView.stateOfAction = .withoutChanges
        }
    }
}

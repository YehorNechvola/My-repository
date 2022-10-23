

import UIKit

// MARK: - Reload data in tableview helper

extension UIViewController {
    
    func reloadDataIfNeeded(in tableview: UITableView) {
        
        if CasesToReloadTableView.stateOfAction != .withoutChanges {
            tableview.reloadData()
            CasesToReloadTableView.stateOfAction = .withoutChanges
        }
    }
}

//
//  Extension+UIVIewController.swift
//  Wall Street news
//
//  Created by Егор on 05.09.2022.
//

import UIKit

// MARK: - Intentet connection message helper

extension UIViewController {
    
    func showInternetConnectionAlert(completion: @escaping() -> Void) {
        let alertAction = UIAlertAction(title: "OK", style: .default)
        let alert = UIAlertController(title: nil, message: "Check internet connection!", preferredStyle: .alert)
        alert.addAction(alertAction)
        self.present(alert, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            completion()
        }
    }
}

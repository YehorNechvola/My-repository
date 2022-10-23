

import UIKit

// MARK: - Intentet connection message helper

extension UIViewController {
    
    func showInternetConnectionAlert(completion: (() -> Void)?) {
        let alertAction = UIAlertAction(title: "OK", style: .default)
        let alert = UIAlertController(title: nil, message: "Check internet connection!", preferredStyle: .alert)
        alert.addAction(alertAction)
        self.present(alert, animated: true)
        guard let completion = completion else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            completion()
        }
    }
}

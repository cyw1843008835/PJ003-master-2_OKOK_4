import Foundation
import UIKit

extension UIViewController {
    func okDialog(title: String, message: String? = nil) {
        let alert: UIAlertController = UIAlertController(title: title,
                                                         message: message,
                                                         preferredStyle: UIAlertController.Style.alert)
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK",
                                                         style: UIAlertAction.Style.default)
        alert.addAction(defaultAction)
        present(alert, animated: true)
    }

    func addProgressIndicator() -> UIActivityIndicatorView {
        let indicator = UIActivityIndicatorView()
        indicator.center = view.center
        indicator.hidesWhenStopped = true
//        indicator.style = .whiteLarge
        indicator.color = UIColor.black

        view.addSubview(indicator)

        return indicator
    }
}

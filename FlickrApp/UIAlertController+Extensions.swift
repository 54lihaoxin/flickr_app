//
//  UIAlertController+Extensions.swift
//  FlickrApp
//
//  Created by Haoxin Li on 3/2/19.
//  Copyright © 2019 Haoxin Li. All rights reserved.
//

import UIKit

extension UIAlertController {
    static func presentErrorAlert(message: String?, fromViewController presentingViewController: UIViewController) {
        let alert = UIAlertController(title: "TITLE.SORRY".localized(), message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "BUTTON.OK".localized(), style: .default, handler: nil))
        DispatchQueue.main.async {
            presentingViewController.present(alert, animated: true, completion: nil)
        }
    }
}

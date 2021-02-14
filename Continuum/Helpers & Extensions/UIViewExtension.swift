//
//  UIViewExtension.swift
//  Continuum
//
//  Created by Devin Flora on 2/14/21.
//  Copyright © 2021 trevorAdcock. All rights reserved.
//

import UIKit

extension UIViewController {
    func presentSimpleAlertWith(title: String, message: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "OK", style: .cancel)
        alertController.addAction(dismissAction)
        present(alertController, animated: true)
    }
}//End of Extension

//
//  ConnectionCheck.swift
//  WordsApp
//
//  Created by Batuhan Demircioğlu on 1.06.2023.
//

import UIKit
import NetworkPackage

class NetworkUtils {
    static func checkConnection(in viewController: UIViewController, retryButtonTapped: @escaping () -> Void) {
        if !NetworkUtility.checkNetworkConnectivity() {
            // Handle no network connection
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "No Internet Connection", message: "Please check your internet connection and try again.", preferredStyle: .alert)
                let retryAction = UIAlertAction(title: "Retry", style: .default) { _ in
                    retryButtonTapped()
                }
                alert.addAction(retryAction)
                viewController.present(alert, animated: true, completion: nil)
            }
            return
        }
    }
    
    static func retryButtonTapped(in viewController: UIViewController) {
        if NetworkUtility.checkNetworkConnectivity() {
            viewController.dismiss(animated: true) {
                // Proceed with loading the view or performing any necessary actions
            }
        } else {
            let alert = UIAlertController(title: "No Internet Connection", message: "Please check your internet connection and try again.", preferredStyle: .alert)
            let retryAction = UIAlertAction(title: "Retry", style: .default) { _ in
                retryButtonTapped(in: viewController)
            }
            alert.addAction(retryAction)
            viewController.present(alert, animated: true, completion: nil)
        }
    }
}


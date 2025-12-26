//
//  StatusBarColor.swift
//  SQLite_test
//
//  Created by IT09F-Public6-MAC on 2024/9/27.
//

import Foundation
import UIKit

extension UIViewController {
    public func setStatusBarBackgroundColor(_ color: UIColor) {
        if #available(iOS 13.0, *) {
            // get the window scene and status bar manager for iOS>13.0
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let statusBarManager = windowScene.statusBarManager
            else {
                return
            }
            // get the status bar height
            let statusBarHeight: CGFloat = statusBarManager.statusBarFrame.size.height

            let statusbarView = UIView()
            // change your color
            statusbarView.backgroundColor = color
            view.addSubview(statusbarView)
            statusbarView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                statusbarView.topAnchor.constraint(equalTo: view.topAnchor),
                statusbarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                statusbarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                statusbarView.heightAnchor.constraint(equalToConstant: statusBarHeight)
            ])
            
        } else {
            let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView
            statusBar?.backgroundColor = color
        }
    }
}

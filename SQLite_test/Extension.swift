//
//  extension.swift
//  SQLite_test
//
//  Created by IT09F-Public6-MAC on 2024/10/8.
//

import Foundation
import UIKit
import SQLite3

extension UIView {
    
    func showToast(message: String, duration: Double) {
        let toastLabel = UILabel(frame: CGRect(x: self.frame.size.width / 2 - 75,
                                               y: self.frame.size.height - 100,
                                               width: 150, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center
        toastLabel.font = UIFont.systemFont(ofSize: 14)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds = true
        
        self.addSubview(toastLabel)
        
        // 設置動畫讓Toast提示逐漸消失
        UIView.animate(withDuration: 0.5, delay: duration, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }) { (isCompleted) in
            toastLabel.removeFromSuperview()
        }
    }
    
}

extension UIViewController {
    
    func setLoading(vc: UIViewController, activityIndicator: UIActivityIndicatorView) {
        activityIndicator.color = .gray
        activityIndicator.hidesWhenStopped = true
        vc.view.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { make in
            make.edges.equalTo(vc.view.safeAreaLayoutGuide)
        }
    }
    
    func showLoading(activityIndicator: UIActivityIndicatorView) {
        activityIndicator.startAnimating()
    }
    
    func hideLoading(activityIndicator: UIActivityIndicatorView) {
        activityIndicator.stopAnimating()
    }
    
    func commonSetup() {
        self.view.backgroundColor = UIColor(named: "MenuBgColor")
        self.title = "農村地方美食"
        self.navigationItem.backButtonTitle = ""
    }
    
    func showTwoBtnAlert(title: String, message: String, cancelAction: UIAlertAction, confirmAction: UIAlertAction) {
        // 創建提示框
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // 將按鈕添加到提示框
        alert.addAction(cancelAction)
        alert.addAction(confirmAction)
        
        // 呈現提示框
        present(alert, animated: true, completion: nil)
    }
    
    func showOneBtnAlert(title: String, message: String, confirmAction: UIAlertAction) {
        // 創建提示框
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // 將按鈕添加到提示框
        alert.addAction(confirmAction)
        
        // 呈現提示框
        present(alert, animated: true, completion: nil)
    }
    
    func addGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    func showActionSheet(in viewController: UIViewController, noteItem: NoteInfo, completion: @escaping (NoteSettingType, NoteInfo) -> Void) {
        let actionSheet = UIAlertController(title: "選擇操作", message: nil, preferredStyle: .actionSheet)
        
        let editAction = UIAlertAction(title: "編輯", style: .default) { _ in
            completion(.edit, noteItem)
        }
        
        let deleteAction = UIAlertAction(title: "刪除", style: .destructive) { _ in
            completion(.delete, noteItem)
        }
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        
        actionSheet.addAction(editAction)
        actionSheet.addAction(deleteAction)
        actionSheet.addAction(cancelAction)
        
        // 因為在 iPad 上，Action Sheet 必須有一個 popover 的位置
        if let popoverController = actionSheet.popoverPresentationController {
            popoverController.sourceView = viewController.view
            popoverController.sourceRect = CGRect(x: viewController.view.bounds.midX, y: viewController.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        viewController.present(actionSheet, animated: true, completion: nil)
    }
    
}

extension DatabaseModel {
    
    static func checkValueIsNull(statement: OpaquePointer?, index: Int32) -> String {
        guard let value = sqlite3_column_text(statement, index) else { return "" }
        return String(cString: value)
    }
    
}

extension UIImage {
    func resized(to size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        draw(in: CGRect(origin: .zero, size: size))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage
    }
}

enum NoteSettingType {
    case edit
    case delete
}

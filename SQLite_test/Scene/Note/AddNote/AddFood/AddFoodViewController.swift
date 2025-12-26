//
//  AddFoodViewController.swift
//  SQLite_test
//
//  Created by IT09F-Public6-MAC on 2024/11/6.
//

import UIKit
import SnapKit

class AddFoodViewController: UIViewController {
    
    var completionHandler: ((LocalFoodDB?) -> Void)?

    private lazy var segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["Menu", "Favorite"])
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
        return segmentedControl
    }()
    
    private lazy var menuViewController: MenuViewController = {
        let viewController = MenuViewController(type: .addFood)
        addChild(viewController)
        viewController.didMove(toParent: self)
        viewController.completionHandler = { item in
            self.completionHandler?(item)
            self.dismiss(animated: true)
        }
        return viewController
    }()
    
    private lazy var favoriteViewController: FavoriteViewController = {
        let viewController = FavoriteViewController(type: .addFood)
        addChild(viewController)
        viewController.didMove(toParent: self)
        viewController.completionHandler = { item in
            self.completionHandler?(item)
            self.dismiss(animated: true)
        }
        return viewController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        // 添加 UISegmentedControl 到視圖
        view.addSubview(segmentedControl)
        segmentedControl.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.centerX.equalToSuperview()
        }
        
        // 顯示初始頁面
        displayCurrentViewController(menuViewController)
    }
    
    @objc private func segmentChanged() {
        if segmentedControl.selectedSegmentIndex == 0 {
            displayCurrentViewController(menuViewController)
        } else {
            displayCurrentViewController(favoriteViewController)
        }
    }
    
    private func displayCurrentViewController(_ viewController: UIViewController) {
        // 移除當前的子視圖控制器
        for child in children {
            child.view.removeFromSuperview()
            child.removeFromParent()
        }
        
        // 添加新子視圖控制器
        view.addSubview(viewController.view)
        viewController.view.snp.makeConstraints { make in
            make.top.equalTo(segmentedControl.snp.bottom).offset(10)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
}

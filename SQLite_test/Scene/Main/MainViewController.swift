//
//  MainViewController.swift
//  SQLite_test
//
//  Created by IT09F-Public6-MAC on 2024/9/27.
//

import UIKit
import SnapKit
import Charts

class MainViewController: UIViewController {
    
    private var chart: BarChartView?
    
    private lazy var menuViewController = {
        let vc = MenuViewController(type: .main)
        let navigationVC = UINavigationController(rootViewController: vc)
        return navigationVC
    }()
    
    private lazy var favoriteViewController = {
        let vc = FavoriteViewController(type: .main)
        let navigationVC = UINavigationController(rootViewController: vc)
        return navigationVC
    }()
    
    private lazy var noteViewController = {
        let vc = NoteViewController()
        let navigationVC = UINavigationController(rootViewController: vc)
        return navigationVC
    }()
    
    private lazy var menuBtn = {
        let button = UIButton()
        button.setTitle("所有美食", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(showMenu), for: .touchUpInside)
        return button
    }()
    
    private lazy var favoriteBtn = {
        let button = UIButton()
        button.setTitle("收藏美食", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(showFavorites), for: .touchUpInside)
        return button
    }()
    
    private lazy var noteBtn = {
        let button = UIButton()
        button.setTitle("我的日記", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(showNote), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor(named: "NavigationBarColor")
        
        view.addSubview(menuBtn)
        view.addSubview(favoriteBtn)
        view.addSubview(noteBtn)
        
        menuBtn.snp.makeConstraints { make in
            make.left.equalTo(self.view.snp.left)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
            make.width.equalTo(view.frame.width / 3)
            make.height.equalTo(40)
        }
        
        favoriteBtn.snp.makeConstraints { make in
            make.left.equalTo(menuBtn.snp.right)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
            make.width.equalTo(view.frame.width / 3)
            make.height.equalTo(40)
        }
        
        noteBtn.snp.makeConstraints { make in
            make.left.equalTo(favoriteBtn.snp.right)
            make.right.equalTo(self.view.snp.right)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
            make.width.equalTo(view.frame.width / 3)
            make.height.equalTo(40)
        }
        
        setNavigationBarColor()
        transition(to: menuViewController)
        updateButtonStyles(selectedButton: menuBtn, deselectedButton: [favoriteBtn, noteBtn])
    }
    
    // 展示 MenuViewController
    @objc private func showMenu() {
        updateButtonStyles(selectedButton: menuBtn, deselectedButton: [favoriteBtn, noteBtn])
        transition(to: menuViewController)
    }
    
    // 展示 FavoriteViewController
    @objc private func showFavorites() {
        updateButtonStyles(selectedButton: favoriteBtn, deselectedButton: [menuBtn, noteBtn])
        transition(to: favoriteViewController)
    }
    
    @objc private func showNote() {
        updateButtonStyles(selectedButton: noteBtn, deselectedButton: [menuBtn, favoriteBtn])
        transition(to: noteViewController)
    }
    
    // 子视图控制器切换
    private func transition(to newController: UINavigationController) {
        // 移除当前子视图控制器
        for child in children {
            child.willMove(toParent: nil)
            child.view.removeFromSuperview()
            child.removeFromParent()
        }
        
        // 添加新的子视图控制器
        addChild(newController)
        view.addSubview(newController.view)
        
        // 设置子视图控制器的视图位置
        newController.view.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top)
            make.left.equalTo(view.snp.left)
            make.right.equalTo(view.snp.right)
            make.bottom.equalTo(menuBtn.snp.top) // 按钮上方显示视图控制器的内容
        }
        
        newController.didMove(toParent: self)
    }
    
    // 更新按钮的样式
    private func updateButtonStyles(selectedButton: UIButton, deselectedButton: [UIButton]) {
        // 选中的按钮样式
        selectedButton.backgroundColor = UIColor(named: "MainSelectBtn")
        
        _ = deselectedButton.map {
            $0.backgroundColor = UIColor(named: "MainUnSelectBtn")
        }
    }
    
    private func setNavigationBarColor() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground() // 设置不透明背景
        appearance.backgroundColor = UIColor(named: "NavigationBarColor") // 设定背景颜色
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white] // 设置标题颜色
        UINavigationBar.appearance().tintColor = UIColor.white
        
        menuViewController.navigationBar.standardAppearance = appearance
        menuViewController.navigationBar.scrollEdgeAppearance = appearance
        
        favoriteViewController.navigationBar.standardAppearance = appearance
        favoriteViewController.navigationBar.scrollEdgeAppearance = appearance
        
        noteViewController.navigationBar.standardAppearance = appearance
        noteViewController.navigationBar.scrollEdgeAppearance = appearance
    }
    
}

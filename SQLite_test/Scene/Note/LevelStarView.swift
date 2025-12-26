//
//  LevelStarView.swift
//  SQLite_test
//
//  Created by IT09F-Public6-MAC on 2024/11/5.
//

import Foundation
import UIKit
import SnapKit

class LevelStarView: UIView {
    
    var starButtons: [UIButton] = []
    var rating: Int = 0 { // 初始值為1星
        didSet {
            updateStarSelection()
        }
    }
    
    var isRating: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStarButtons()
        updateStarSelection()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupStarButtons() {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 8
        self.addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
        
        for i in 1...5 {
            let button = UIButton()
            button.setImage(UIImage(named: "unSelectStar"), for: .normal) // 空星
            button.setImage(UIImage(named: "star"), for: .selected) // 填滿星
            button.tag = i
            button.addTarget(self, action: #selector(starButtonTapped), for: .touchDown)
            
            button.snp.makeConstraints { make in
                make.height.equalTo(25)
                make.width.equalTo(25)
            }
            
            stackView.addArrangedSubview(button)
            starButtons.append(button)
        }
    }
    
    @objc func starButtonTapped(_ sender: UIButton) {
        if isRating != true { return }
        if rating != sender.tag {
            rating = sender.tag
        }
    }
    
    func updateStarSelection() {
        for button in starButtons {
            button.isSelected = button.tag <= rating
        }
    }
    
}


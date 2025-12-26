//
//  FavoriteollectionViewCell.swift
//  SQLite_test
//
//  Created by IT09F-Public6-MAC on 2024/10/1.
//

import UIKit

class FavoriteCollectionViewCell: UICollectionViewCell {
    
    private var width: Int?
    
    lazy var menuImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 20.0)
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    
    private func setupUI() {
        self.backgroundColor = .clear
        self.addSubview(menuImageView)
        self.addSubview(nameLabel)
        
        menuImageView.snp.makeConstraints { make in
            make.top.equalTo(self.snp.top)
            make.right.equalTo(self.snp.right)
            make.left.equalTo(self.snp.left)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(menuImageView.snp.bottom)
            make.left.equalTo(self)
            make.right.equalTo(self)
            make.bottom.equalTo(self.snp.bottom)
            make.height.equalTo(40)
        }
        
    }

}

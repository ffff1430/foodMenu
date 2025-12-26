//
//  MenuTableViewCell.swift
//  SQLite_test
//
//  Created by IT09F-Public6-MAC on 2024/9/30.
//

import UIKit
import SnapKit

class MenuTableViewCell: UITableViewCell {
    
    weak var delegate: MenuTableViewCellDelegate?
    
    private var index: Int?
    
    private lazy var menuContentView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 1.0
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 15
        view.layer.borderColor = CGColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1)
        view.backgroundColor = .clear
        return view
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 14.0)
        return label
    }()
    
    private lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    lazy var picImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    lazy var heartBtn: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(heartBtnTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var introductionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12.0)
        label.numberOfLines = 0
        return label
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.picImage.image = nil
    }
    
    private func setupUI() {
        self.backgroundColor = .clear
        self.selectionStyle = .none
        self.contentView.isUserInteractionEnabled = true
        
        self.addSubview(menuContentView)
        menuContentView.addSubview(nameLabel)
        menuContentView.addSubview(heartBtn)
        menuContentView.addSubview(lineView)
        menuContentView.addSubview(picImage)
        menuContentView.addSubview(introductionLabel)
        
        menuContentView.snp.makeConstraints { make in
            make.top.equalTo(self).offset(10)
            make.left.equalTo(self)
            make.right.equalTo(self)
            make.bottom.equalTo(self).offset(-10)
            make.width.equalTo(self.frame.width)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(menuContentView.snp.top).offset(10)
            make.left.equalTo(menuContentView.snp.left).offset(10)
        }
        
        heartBtn.snp.makeConstraints { make in
            make.centerY.equalTo(nameLabel.snp.centerY)
            make.right.equalTo(menuContentView.snp.right).offset(-10)
            make.width.equalTo(20)
            make.height.equalTo(20)
        }
        
        lineView.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(5)
            make.left.equalTo(nameLabel.snp.left)
            make.right.equalTo(heartBtn.snp.right)
            make.height.equalTo(1)
        }
        
        picImage.snp.makeConstraints { make in
            make.top.equalTo(lineView.snp.bottom).offset(5)
            make.left.equalTo(lineView.snp.left)
            make.bottom.equalTo(menuContentView.snp.bottom).offset(-15)
            make.height.equalTo(self.frame.width * 0.3)
            make.width.equalTo(self.frame.width * 0.3)
        }
        
        picImage.layer.masksToBounds = true
        picImage.layer.cornerRadius = self.frame.width * 0.3 / 2
        
        introductionLabel.snp.makeConstraints { make in
            make.top.equalTo(picImage.snp.top)
            make.left.equalTo(picImage.snp.right).offset(10)
            make.bottom.equalTo(menuContentView.snp.bottom)
            make.right.equalTo(lineView.snp.right)
        }
        
    }
    
    @objc func heartBtnTapped() {
        if heartBtn.image(for: .normal) == UIImage(named: "unSelectHeart") {
            heartBtn.setImage(UIImage(named: "selectHeart"), for: .normal)
            // 通知MainView心形已被选中
            delegate?.didTapHeartButton(isSelected: true, index: self.index ?? 0)
        } else {
            heartBtn.setImage(UIImage(named: "unSelectHeart"), for: .normal)
            // 通知MainView心形已取消选中
            delegate?.didTapHeartButton(isSelected: false, index: self.index ?? 0)
        }
    }
    
    private func setupGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleCellTap))
        tapGesture.cancelsTouchesInView = false // 允許 cell 繼續接收觸摸事件
        self.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleCellTap() {
        print("Cell tapped")
    }
    
    func fetchIndex(index: Int) {
        self.index = index
    }
    
}

protocol MenuTableViewCellDelegate: AnyObject {
    func didTapHeartButton(isSelected: Bool, index: Int)
}

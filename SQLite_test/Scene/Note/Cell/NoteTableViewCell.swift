//
//  NoteTableViewCell.swift
//  SQLite_test
//
//  Created by IT09F-Public6-MAC on 2024/11/1.
//

import UIKit

class NoteTableViewCell: UITableViewCell {
    
    private var index: Int?
    
    var settingBtnHandler: (() -> Void)?
    
    private lazy var noteContentView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 1.0
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 15
        view.layer.borderColor = CGColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1)
        view.backgroundColor = .clear
        return view
    }()
    
    lazy var dateLabel: UILabel = {
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
    
    lazy var settingBtn: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(settingBtnTapped), for: .touchUpInside)
        button.setImage(UIImage(named: "setting"), for: .normal)
        return button
    }()
    
    lazy var introductionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16.0)
        label.numberOfLines = 0
        return label
    }()
    
    lazy var levelStarView: LevelStarView = {
        let view = LevelStarView()
        return view
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 20.0)
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
        
        self.addSubview(noteContentView)
        noteContentView.addSubview(dateLabel)
        noteContentView.addSubview(settingBtn)
        noteContentView.addSubview(lineView)
        noteContentView.addSubview(picImage)
        noteContentView.addSubview(levelStarView)
        noteContentView.addSubview(nameLabel)
        noteContentView.addSubview(introductionLabel)
        
        noteContentView.snp.makeConstraints { make in
            make.top.equalTo(self).offset(10)
            make.left.equalTo(self)
            make.right.equalTo(self)
            make.bottom.equalTo(self).offset(-10)
            make.width.equalTo(self.frame.width)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(noteContentView.snp.top).offset(10)
            make.left.equalTo(noteContentView.snp.left).offset(10)
            make.height.equalTo(17)
        }
        
        settingBtn.snp.makeConstraints { make in
            make.centerY.equalTo(dateLabel.snp.centerY)
            make.right.equalTo(noteContentView.snp.right).offset(-10)
            make.width.equalTo(20)
            make.height.equalTo(20)
        }
        
        lineView.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(10)
            make.left.equalTo(dateLabel.snp.left)
            make.right.equalTo(settingBtn.snp.right)
            make.height.equalTo(1)
        }
        
        picImage.snp.makeConstraints { make in
            make.top.equalTo(lineView.snp.bottom).offset(5)
            make.left.equalTo(lineView.snp.left)
            make.height.equalTo(self.frame.width * 0.3)
            make.width.equalTo(self.frame.width * 0.3)
        }
        
        picImage.layer.masksToBounds = true
        picImage.layer.cornerRadius = self.frame.width * 0.3 / 2
        
        levelStarView.snp.makeConstraints { make in
            make.top.equalTo(picImage.snp.top)
            make.left.equalTo(picImage.snp.right).offset(10)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(levelStarView.snp.bottom).offset(10)
            make.left.equalTo(levelStarView.snp.left)
        }
        
        introductionLabel.snp.makeConstraints { make in
            make.top.equalTo(picImage.snp.bottom).offset(10)
            make.left.equalTo(picImage.snp.left)
            make.bottom.equalTo(self.snp.bottom).offset(-20)
            make.right.equalTo(lineView.snp.right)
        }
        
    }
    
    @objc func settingBtnTapped() {
        settingBtnHandler?()
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

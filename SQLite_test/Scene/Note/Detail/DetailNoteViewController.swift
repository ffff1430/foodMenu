//
//  DetailNoteViewController.swift
//  SQLite_test
//
//  Created by IT09F-Public6-MAC on 2024/11/6.
//

import UIKit

class DetailNoteViewController: UIViewController {
    
    private var noteItem: NoteInfo? {
        didSet {
            updateUI()
        }
    }
    
    private var viewModel: DetailNoteViewModel?
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    private lazy var foodImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private lazy var levelStarView: LevelStarView = {
        let levelStarView = LevelStarView()
        return levelStarView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 20.0)
        return label
    }()
    
    private lazy var addressLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 20.0)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var reviewLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 20.0)
        label.numberOfLines = 0
        return label
    }()
    
    init(noteItem: NoteInfo, viewModel: DetailNoteViewModel) {
        self.noteItem = noteItem
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        updateUI()
    }
    
    private func setupUI() {
        commonSetup()
        
        if let originalImage = UIImage(named: "setting"),
           let resizedImage = originalImage.resized(to: CGSize(width: 24, height: 24)) {
            let rightBarButton = UIBarButtonItem(image: resizedImage.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(rightBarButtonTapped))
            navigationItem.rightBarButtonItem = rightBarButton
        }
        
        view.addSubview(scrollView)
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.left.equalTo(self.view)
            make.right.equalTo(self.view)
            make.bottom.equalTo(self.view)
        }
        
        scrollViewContent()
    }
    
    private func updateUI() {
        dateLabel.text = noteItem?.date
        levelStarView.rating = Int(noteItem?.level ?? "") ?? 0
        reviewLabel.text = noteItem?.review
        print("addTime: \(noteItem?.addDate)")
        if let id = noteItem?.foodID {
            viewModel?.getFoodDBInfo(id: id, completion: { food in
                self.nameLabel.text = food?.name ?? ""
                self.addressLabel.text = food?.address ?? ""
                self.foodImageView.sd_setImage(with: URL(string: food?.picURL ?? ""), placeholderImage: UIImage(named: "doggo"))
            })
        }
    }
    
    private func scrollViewContent() {
        scrollView.addSubview(foodImageView)
        scrollView.addSubview(dateLabel)
        scrollView.addSubview(levelStarView)
        scrollView.addSubview(nameLabel)
        scrollView.addSubview(addressLabel)
        scrollView.addSubview(reviewLabel)
        
        foodImageView.snp.makeConstraints { make in
            make.top.equalTo(scrollView).offset(20)
            make.centerX.equalTo(scrollView)
            make.width.equalTo(self.view.frame.width * 0.4)
            make.height.equalTo(self.view.frame.width * 0.4)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(foodImageView.snp.bottom).offset(30)
            make.left.equalTo(self.view).offset(20)
        }
        
        levelStarView.snp.makeConstraints { make in
            make.centerY.equalTo(dateLabel)
            make.right.equalTo(self.view).offset(-20)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(30)
            make.left.equalTo(self.view).offset(30)
            make.right.equalTo(self.view).offset(-30)
        }
        
        addressLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(15)
            make.left.equalTo(self.view).offset(30)
            make.right.equalTo(self.view).offset(-30)
        }
        
        reviewLabel.snp.makeConstraints { make in
            make.top.equalTo(addressLabel.snp.bottom).offset(15)
            make.left.equalTo(self.view).offset(30)
            make.right.equalTo(self.view).offset(-30)
        }
    }
    
    @objc func rightBarButtonTapped() {
        if let noteItem = noteItem {
            self.showActionSheet(in: self, noteItem: noteItem) { type, noteItem in
                switch type {
                case .edit:
                    let vc = AddNoteViewController(addNoteType: .edit, viewModel: AddNoteViewModel(), noteItem: noteItem)
                    vc.completionHandler = { noteInfo in
                        self.noteItem = noteInfo
                    }
                    self.navigationController?.pushViewController(vc, animated: false)
                case .delete:
                    self.viewModel?.deleteNote(model: noteItem) {
                        self.navigationController?.popViewController(animated: false)
                    }
                }
            }
        }
    }
    
}

//
//  DetailViewController.swift
//  SQLite_test
//
//  Created by IT09F-Public6-MAC on 2024/9/30.
//

import UIKit
import SnapKit
import SDWebImage

class DetailViewController: UIViewController {
    
    private var foodItem: LocalFoodDB?
    
    var completionHandler: ((LocalFoodDB?) -> Void)?
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    private lazy var foodImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.sd_setImage(with: URL(string: foodItem?.picURL ?? ""), placeholderImage: UIImage(named: "doggo"))
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 20.0)
        label.text = foodItem?.name
        return label
    }()
    
    private lazy var introductionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12.0)
        label.numberOfLines = 0
        label.text = foodItem?.hostWords
        return label
    }()
    
    private lazy var locationImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.image = UIImage(named: "location")
        return imageView
    }()
    
    private lazy var locationLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12.0)
        label.text = foodItem?.address
        return label
    }()
    
    private lazy var phoneImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.image = UIImage(named: "phone")
        return imageView
    }()
    
    private lazy var phoneBtn: UIButton = {
        let button = UIButton()
        button.contentHorizontalAlignment = .left
        button.setTitleColor(UIColor.blue, for: .normal)
        button.addTarget(self, action: #selector(showAlert), for: .touchUpInside)
        button.setTitle(foodItem?.tel, for: .normal)
        return button
    }()
    
    private lazy var linkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "link")
        return imageView
    }()
    
    private lazy var linkBtn: UIButton = {
        let button = UIButton()
        button.setTitle("官方網站", for: .normal)
        button.contentHorizontalAlignment = .left
        button.setTitleColor(UIColor.blue, for: .normal)
        button.addTarget(self, action: #selector(openLinkBtnTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var heartBtn: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(heartBtnTapped), for: .touchUpInside)
        let heartStatus = foodItem?.isFavorite ?? false
        button.setImage(heartStatus ? UIImage(resource: .selectHeart) : UIImage(resource: .unSelectHeart), for: .normal)
        return button
    }()
    
    private lazy var creditCardImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(resource: .creditCard)
        if foodItem?.creditCard ?? false {
            imageView.isHidden = false
        } else {
            imageView.isHidden = true
        }
        return imageView
    }()
    
    private lazy var travelCardImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.image = UIImage(resource: .travelCard)
        if foodItem?.travelCard ?? false {
            imageView.isHidden = false
        } else {
            imageView.isHidden = true
        }
        return imageView
    }()
    
    init(foodItem: LocalFoodDB) {
        self.foodItem = foodItem
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.isMovingFromParent {
            completionHandler?(foodItem)
        }
    }
    
    private func setupUI() {
        commonSetup()
        
        view.addSubview(scrollView)
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: 900)
        
        scrollViewContent()
    }
    
    private func scrollViewContent() {
        scrollView.addSubview(foodImageView)
        scrollView.addSubview(nameLabel)
        scrollView.addSubview(heartBtn)
        scrollView.addSubview(introductionLabel)
        scrollView.addSubview(locationImageView)
        scrollView.addSubview(locationLabel)
        scrollView.addSubview(phoneImageView)
        scrollView.addSubview(phoneBtn)
        scrollView.addSubview(linkImageView)
        scrollView.addSubview(linkBtn)
        scrollView.addSubview(creditCardImage)
        scrollView.addSubview(travelCardImage)
        
        foodImageView.snp.makeConstraints { make in
            make.top.equalTo(scrollView).offset(15)
            make.centerX.equalTo(scrollView)
            make.width.equalTo(self.view.frame.width * 0.4)
            make.height.equalTo(self.view.frame.width * 0.4)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(foodImageView.snp.bottom).offset(10)
            make.centerX.equalTo(scrollView)
            make.width.equalTo(self.view.frame.width * 0.9)
        }
        
        heartBtn.snp.makeConstraints { make in
            make.top.equalTo(foodImageView)
            make.right.equalTo(nameLabel)
            make.width.equalTo(30)
            make.height.equalTo(30)
        }
        
        introductionLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(5)
            make.left.equalTo(nameLabel)
            make.right.equalTo(nameLabel)
        }
        
        locationImageView.snp.makeConstraints { make in
            make.top.equalTo(introductionLabel.snp.bottom).offset(10)
            make.left.equalTo(introductionLabel)
            make.width.equalTo(15)
            make.height.equalTo(15)
        }
        
        locationLabel.snp.makeConstraints { make in
            make.centerY.equalTo(locationImageView)
            make.left.equalTo(locationImageView.snp.right).offset(10)
            make.right.equalTo(introductionLabel)
        }
        
        phoneImageView.snp.makeConstraints { make in
            make.top.equalTo(locationImageView.snp.bottom).offset(5)
            make.left.equalTo(locationImageView)
            make.width.equalTo(15)
            make.height.equalTo(15)
        }
        
        phoneBtn.snp.makeConstraints { make in
            make.centerY.equalTo(phoneImageView)
            make.left.equalTo(phoneImageView.snp.right).offset(10)
            make.right.equalTo(introductionLabel)
            make.height.equalTo(15)
        }
        
        linkImageView.snp.makeConstraints { make in
            make.top.equalTo(phoneImageView.snp.bottom).offset(5)
            make.left.equalTo(phoneImageView)
            make.width.equalTo(15)
            make.height.equalTo(15)
        }
        
        linkBtn.snp.makeConstraints { make in
            make.centerY.equalTo(linkImageView)
            make.left.equalTo(linkImageView.snp.right).offset(10)
            make.right.equalTo(introductionLabel)
            make.height.equalTo(15)
        }
        
        creditCardImage.snp.makeConstraints { make in
            make.top.equalTo(linkBtn.snp.bottom).offset(40)
            make.right.equalTo(self.view).offset(-10)
            make.height.equalTo(30)
            make.width.equalTo(30)
        }
        
        travelCardImage.snp.makeConstraints { make in
            make.centerY.equalTo(creditCardImage)
            make.right.equalTo(creditCardImage.snp.left).offset(-10)
            make.height.equalTo(30)
            make.width.equalTo(30)
        }
    
    }
    
    @objc func heartBtnTapped() {
        if heartBtn.image(for: .normal) == UIImage(named: "unSelectHeart") {
            heartBtn.setImage(UIImage(named: "selectHeart"), for: .normal)
            // 通知MainView心形已被选中
            foodItem?.isFavorite = true
            updateHeartStatus(status: true)
        } else {
            heartBtn.setImage(UIImage(named: "unSelectHeart"), for: .normal)
            // 通知MainView心形已取消选中
            foodItem?.isFavorite = false
            updateHeartStatus(status: false)
        }
    }
    
    @objc func openLinkBtnTapped() {
        if let url = URL(string: foodItem?.url ?? "") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    @objc func showAlert() {
        // 添加取消按鈕，style 設置為 .cancel
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        
        // 添加確認按鈕，style 設置為 .default
        let confirmAction = UIAlertAction(title: "確認", style: .default, handler: { _ in
            let phoneNumber = self.foodItem?.tel ?? ""
            if let phoneURL = URL(string: "tel://\(phoneNumber)"),
               UIApplication.shared.canOpenURL(phoneURL) {
                UIApplication.shared.open(phoneURL, options: [:], completionHandler: nil)
            } else {
                self.view.showToast(message: "無法撥打電話", duration: 0.5)
            }
        })
        
        self.showTwoBtnAlert(title: "", 
                             message: "即將撥出電話給餐廳名稱\n電話：\(foodItem?.tel ?? "")",
                             cancelAction: cancelAction,
                             confirmAction: confirmAction)
    }
    
    private func updateHeartStatus(status: Bool) {
        foodItem?.isFavorite = status
        if let foodItem = foodItem {
            FoodDB.shared.updateIsFavorite(model: foodItem) { result in
                switch result {
                case .success(_):
                    break
                case .failure(let error):
                    let confirmAction = UIAlertAction(title: "確認", style: .cancel, handler: nil)
                    self.showOneBtnAlert(title: "錯誤",
                                         message: "\(error)",
                                         confirmAction: confirmAction)
                }
                
            }
        }
    }
    
}

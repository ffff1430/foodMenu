//
//  FavoriteViewController.swift
//  SQLite_test
//
//  Created by IT09F-Public6-MAC on 2024/9/27.
//

import UIKit
import Combine
import SnapKit
import SDWebImage

class FavoriteViewController: UIViewController {
    
    private var viewModel: FavoriteViewModel?
    private var cancellables = Set<AnyCancellable>()
    private var foodItems: [LocalFoodDB] = []
    private var isPick = false
    private var filteredItems: [LocalFoodDB] = []
    private var methodType: MethodType?
    
    var completionHandler: ((LocalFoodDB?) -> Void)?
    
    private lazy var cityPicker: UIPickerView = {
        let picker = UIPickerView()
        return picker
    }()
    
    private lazy var cityTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "全部"
        textField.font = .systemFont(ofSize: 12.0)
        return textField
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: CGRect(x: 0,
                                                            y: 0,
                                                            width: 0,
                                                            height: 0),
                                              collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    init(type: MethodType) {
        self.methodType = type
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        bindViewModel()
    }
    
    private func setupUI() {
        commonSetup()
        initPicker()
        initCollectionView()
    }
    
    private func bindViewModel() {
        viewModel = FavoriteViewModel()
        
        viewModel?.fetchFavoriteFood(filter: filteredItems)
        
        viewModel?.completionResultHandler = { result in
            switch result {
            case .success(let success):
                print(success)
            case .failure(let error):
                let confirmAction = UIAlertAction(title: "確認", style: .cancel, handler: nil)
                self.showOneBtnAlert(title: "錯誤",
                                     message: error,
                                     confirmAction: confirmAction)
            }
        }
        
        viewModel?.$foodItems
            .receive(on: DispatchQueue.main)
            .sink { [weak self] foodItems in
                self?.foodItems = foodItems
                self?.collectionView.reloadData()
            }
            .store(in: &cancellables)
        
        viewModel?.$filterItems
            .receive(on: DispatchQueue.main)
            .sink { [weak self] foodItems in
                self?.filteredItems = foodItems
                if foodItems.isEmpty {
                    self?.isPick = false
                    self?.cityTextField.text = ""
                    self?.cityPicker.selectRow(0, inComponent: 0, animated: false)
                }
                self?.collectionView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    private func initPicker() {
        view.addSubview(cityTextField)
        
        cityTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            make.left.equalTo(view.snp.left).offset(20)
            make.right.equalTo(view.snp.right).offset(-20)
            make.height.equalTo(30)
        }
        
        cityTextField.inputView = cityPicker
        
        cityPicker.delegate = self
        cityPicker.dataSource = self
        
        // 添加工具欄
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "完成", style: .plain, target: self, action: #selector(donePressed))
        toolbar.setItems([flexibleSpace, doneButton], animated: false)
        cityTextField.inputAccessoryView = toolbar
    }
    
    @objc func donePressed() {
        // 隱藏鍵盤
        cityTextField.resignFirstResponder()
        viewModel?.cityList(city: cityTextField.text ?? "", foodItems: foodItems) { items, isPick in
            DispatchQueue.main.async {
                self.isPick = isPick
                self.filteredItems = items
                self.collectionView.reloadData()
            }
        }
    }
    
    private func initCollectionView() {
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(FavoriteCollectionViewCell.self, forCellWithReuseIdentifier: "collectionCell")
        
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(cityTextField.snp.bottom).offset(10)
            make.left.equalTo(self.cityTextField).offset(20)
            make.right.equalTo(self.cityTextField).offset(-20)
            make.bottom.equalTo(self.view).offset(-10)
        }
        
    }
    
}

extension FavoriteViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return (viewModel?.uniqueCities.count ?? 0) + 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var cityPickerList = viewModel?.uniqueCities
        cityPickerList?.insert("全部", at: 0)
        return cityPickerList?[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        var cityPickerList = viewModel?.uniqueCities
        cityPickerList?.insert("全部", at: 0)
        cityTextField.text = cityPickerList?[row]
    }
    
}

extension FavoriteViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isPick ? filteredItems.count : foodItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as? FavoriteCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.nameLabel.text = isPick ? filteredItems[indexPath.row].name : foodItems[indexPath.row].name
        cell.menuImageView.sd_setImage(with: URL(
            string: isPick ? filteredItems[indexPath.row].picURL : foodItems[indexPath.row].picURL
        ), placeholderImage: UIImage(named: "doggo"))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 100) / 2
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let item = viewModel?.getCurrentIDItem(id: (isPick ? filteredItems[indexPath.row].id : foodItems[indexPath.row].id) ?? 0) {
            if methodType == .main {
                let vc = DetailViewController(foodItem: item)
                self.navigationController?.pushViewController(vc, animated: false)
            } else {
                completionHandler?(item)
            }
        }
    }
    
}

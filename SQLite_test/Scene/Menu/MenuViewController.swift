//
//  MenuViewController.swift
//  SQLite_test
//
//  Created by IT09F-Public6-MAC on 2024/9/27.
//

import UIKit
import Combine
import SDWebImage

class MenuViewController: UIViewController {
    
    private var viewModel: MenuViewModel?
    private var cancellables = Set<AnyCancellable>()
    private var foodItems: [LocalFoodDB] = []
    private var isSearching = false
    private var isPicking = false
    private var filteredItems: [LocalFoodDB] = []
    private var methodType: MethodType?
    
    var completionHandler: ((LocalFoodDB?) -> Void)?
    
    private var activityIndicator = UIActivityIndicatorView(style: .large)
    
    private lazy var cityPicker: UIPickerView = {
        let picker = UIPickerView()
        return picker
    }()
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.searchBarStyle = .minimal
        return searchBar
    }()
    
    private lazy var cityTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "全部"
        textField.font = .systemFont(ofSize: 12.0)
        return textField
    }()
    
    private lazy var menuTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        return tableView
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
        addGesture()
        bindViewModel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel?.fetchFoodDB(filter: filteredItems)
    }
    
    private func setupUI() {
        commonSetup()
        
        let rightBarButton = UIBarButtonItem(image: .refresh, style: .plain, target: self, action: #selector(rightBarButtonTapped))
        navigationItem.rightBarButtonItem = rightBarButton
        
        setLoading(vc: self, activityIndicator: activityIndicator)
        initPicker()
        initSearchBar()
        initTableView()
    }
    
    @objc func rightBarButtonTapped() {
        isSearching = false
        isPicking = false
        filteredItems.removeAll()
        
        // 重置TextField
        self.cityTextField.text = ""
        self.searchBar.text = ""
        // 重置PickerView
        self.cityPicker.selectRow(0, inComponent: 0, animated: false)
        self.menuTableView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
        self.menuTableView.reloadData()
        view.endEditing(true)
    }
    
    private func bindViewModel() {
        viewModel = MenuViewModel()
        
        let url = "https://data.moa.gov.tw/Service/OpenData/ODwsv/ODwsvTravelFood.aspx"
        
        viewModel?.getLocalFoodInfo(url: url) { result in
            let confirmAction = UIAlertAction(title: "確認", style: .cancel, handler: nil)
            self.showOneBtnAlert(title: "錯誤",
                                 message: "\(result)",
                                 confirmAction: confirmAction)
        }
        
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
                self?.menuTableView.reloadData()
            }
            .store(in: &cancellables)
        
        viewModel?.$filterItems
            .receive(on: DispatchQueue.main)
            .sink { [weak self] foodItems in
                self?.filteredItems = foodItems
                self?.menuTableView.reloadData()
            }
            .store(in: &cancellables)
        
        viewModel?.$isShowLoading
            .receive(on: DispatchQueue.main)
            .sink { loading in
                if loading {
                    self.showLoading(activityIndicator: self.activityIndicator)
                } else {
                    self.hideLoading(activityIndicator: self.activityIndicator)
                }
            }
            .store(in: &cancellables)
        
    }
    
    private func initPicker() {
        view.addSubview(cityTextField)
        
        cityTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            make.left.equalTo(view.snp.left).offset(20)
            make.width.equalTo(view.frame.width * 0.9 * 0.3)
            make.height.equalTo(30)
        }
        
        cityTextField.inputView = cityPicker
        
        cityPicker.delegate = self
        cityPicker.dataSource = self
        
        // 添加工具欄
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        // 在按鈕前面加入彈性空間，使按鈕靠右
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "完成", style: .plain, target: self, action: #selector(donePressed))
        toolbar.setItems([flexibleSpace, doneButton], animated: false)
        cityTextField.inputAccessoryView = toolbar
    }
    
    private func initSearchBar() {
        view.addSubview(searchBar)
        
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            make.left.equalTo(cityTextField.snp.right).offset(10)
            make.right.equalTo(view.snp.right).offset(-20)
            make.width.equalTo(view.frame.width * 0.9 * 0.7)
            make.height.equalTo(30)
        }
        
        searchBar.delegate = self
    }
    
    private func initTableView() {
        view.addSubview(menuTableView)
        
        menuTableView.snp.makeConstraints { make in
            make.top.equalTo(cityTextField.snp.bottom).offset(15)
            make.left.equalTo(cityTextField.snp.left)
            make.right.equalTo(searchBar.snp.right)
            make.bottom.equalTo(self.view.snp.bottom).offset(-15)
        }
        menuTableView.delegate = self
        menuTableView.dataSource = self
        menuTableView.showsVerticalScrollIndicator = false
        menuTableView.separatorStyle = .none
        menuTableView.register(MenuTableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    @objc func donePressed() {
        // 隱藏鍵盤
        cityTextField.resignFirstResponder()
        if (cityTextField.text != "") {
            isPicking = true
        }
        viewModel?.updateFilterItems(action: .pick, foodItems: foodItems, searchText: searchBar.text ?? "", city: cityTextField.text ?? "")
    }
    
    private func checkCacheSizeAndClearIfNeeded() {
        let maxCacheSize: UInt = 20 * 1024 * 1024
        let cache = SDImageCache.shared
        let currentCacheSize = cache.totalDiskSize()
        
        if currentCacheSize > maxCacheSize {
            cache.clearMemory()
            cache.clearDisk(onCompletion: {
                self.menuTableView.reloadData()  // 清除後重新載入
            })
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.checkCacheSizeAndClearIfNeeded()
    }
    
}

extension MenuViewController: UIPickerViewDelegate, UIPickerViewDataSource {
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

extension MenuViewController: UITableViewDelegate, UITableViewDataSource, MenuTableViewCellDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearching || isPicking ? filteredItems.count : foodItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? MenuTableViewCell else {
            return UITableViewCell()
        }
        cell.nameLabel.text = isSearching || isPicking ? filteredItems[indexPath.row].name : foodItems[indexPath.row].name
        cell.picImage.sd_setImage(with: URL(
            string: isSearching || isPicking ? filteredItems[indexPath.row].picURL : foodItems[indexPath.row].picURL
        ), placeholderImage: UIImage(named: "doggo"))
        cell.introductionLabel.text = isSearching || isPicking ? filteredItems[indexPath.row].hostWords :  foodItems[indexPath.row].hostWords
        viewModel?.checkHeartStatus(index: indexPath.row, filterList: filteredItems, foodList: foodItems, isSearching: isSearching, isPicking: isPicking) { result in
            cell.heartBtn.setImage(result ? UIImage(named: "selectHeart") : UIImage(named: "unSelectHeart"),
                                   for: .normal)
        }
        cell.fetchIndex(index: indexPath.row)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if methodType == .main {
            let vc = DetailViewController(foodItem: isSearching || isPicking ? filteredItems[indexPath.row] : foodItems[indexPath.row])
            vc.completionHandler = { food in
                self.viewModel?.updateSpecificItem(item: food!, isSearching: self.isSearching, isPicking: self.isPicking)
            }
            self.navigationController?.pushViewController(vc, animated: false)
        } else {
            completionHandler?(isSearching || isPicking ? filteredItems[indexPath.row] : foodItems[indexPath.row])
        }
    }
    
    func didTapHeartButton(isSelected: Bool, index: Int) {
        viewModel?.updateIsFavoriteInfo(isFavorite: isSelected,
                                        item: isSearching || isPicking ? filteredItems[index] : foodItems[index]) {
            self.viewModel?.fetchFoodDB(filter: self.filteredItems)
        }
    }
    
}

extension MenuViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            isSearching = false
            viewModel?.updateFilterItems(action: .search, foodItems: foodItems, searchText: searchText, city: cityTextField.text ?? "")
        } else {
            isSearching = true
            viewModel?.updateFilterItems(action: .search, foodItems: foodItems, searchText: searchText, city: cityTextField.text ?? "")
        }
        menuTableView.reloadData()
    }
       
}

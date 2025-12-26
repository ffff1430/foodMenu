//
//  AddNoteViewController.swift
//  SQLite_test
//
//  Created by IT09F-Public6-MAC on 2024/11/5.
//

import UIKit
import SnapKit

class AddNoteViewController: UIViewController {
    
    private var foodItem: LocalFoodDB?
    private var viewModel: AddNoteViewModel?
    private var date: String?
    private var addNoteType: AddNoteType?
    private var noteItem: NoteInfo?
    var completionHandler: ((NoteInfo) -> Void)?
    
    private lazy var dateTitle: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16.0)
        label.text = "日期："
        return label
    }()
    
    private lazy var dateTextField: UITextField = {
        let textField = UITextField()
        textField.font = .systemFont(ofSize: 16.0)
        textField.text = " 請選擇日期 "
        textField.layer.borderWidth = 1
        textField.layer.borderColor = CGColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1)
        textField.layer.cornerRadius = 5
        return textField
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.locale = Locale(identifier: "zh_Hant_TW")
        let currentDate = Date()
        var dateComponents = DateComponents()
        dateComponents.year = -20
        let minDate = Calendar.current.date(byAdding: dateComponents, to: currentDate)
        datePicker.minimumDate = minDate
        datePicker.maximumDate = currentDate
        return datePicker
    }()
    
    private lazy var nameTitle: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16.0)
        label.text = "餐廳："
        return label
    }()
    
    private lazy var nameBtn: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .systemFont(ofSize: 16.0)
        button.setTitle(" 請選擇餐廳 ", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.borderWidth = 1
        button.layer.borderColor = CGColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1)
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(presentAddFoodView), for: .touchUpInside)
        return button
    }()
    
    private lazy var levelTitle: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16.0)
        label.text = "評分："
        return label
    }()
    
    lazy var levelStarView: LevelStarView = {
        let view = LevelStarView()
        view.isRating = true
        return view
    }()
    
    private lazy var reviewTitle: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16.0)
        label.text = "心得："
        return label
    }()
    
    private lazy var reviewTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = UIColor(named: "MenuBgColor")
        textView.layer.borderWidth = 1
        textView.layer.borderColor = CGColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1)
        textView.layer.cornerRadius = 5
        return textView
    }()
    
    private lazy var saveBtn: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(named: "SaveBtnColor")
        button.layer.cornerRadius = 5
        button.setTitle("儲存", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(savePressed), for: .touchUpInside)
        return button
    }()
    
    init(addNoteType: AddNoteType, viewModel: AddNoteViewModel) {
        self.addNoteType = addNoteType
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    init(addNoteType: AddNoteType, viewModel: AddNoteViewModel, noteItem: NoteInfo) {
        self.addNoteType = addNoteType
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
        addGesture()
        bindViewModel()
    }
    
    private func bindViewModel() {
        
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
    }
    
    private func setupUI() {
        commonSetup()
        self.title = "新增我的日記"
        
        view.addSubview(dateTitle)
        view.addSubview(dateTextField)
        view.addSubview(nameTitle)
        view.addSubview(nameBtn)
        view.addSubview(levelTitle)
        view.addSubview(levelStarView)
        view.addSubview(reviewTitle)
        view.addSubview(saveBtn)
        view.addSubview(reviewTextView)
        
        dateTitle.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(20)
            make.left.equalTo(self.view).offset(20)
        }
        
        dateTextField.snp.makeConstraints { make in
            make.centerY.equalTo(dateTitle)
            make.left.equalTo(dateTitle.snp.right).offset(10)
            make.height.equalTo(32)
        }
        
        nameTitle.snp.makeConstraints { make in
            make.left.equalTo(dateTitle)
            make.top.equalTo(dateTitle.snp.bottom).offset(20)
        }
        
        nameBtn.snp.makeConstraints { make in
            make.centerY.equalTo(nameTitle)
            make.left.equalTo(nameTitle.snp.right).offset(10)
        }
        
        levelTitle.snp.makeConstraints { make in
            make.left.equalTo(dateTitle)
            make.top.equalTo(nameTitle.snp.bottom).offset(20)
        }
        
        levelStarView.snp.makeConstraints { make in
            make.centerY.equalTo(levelTitle)
            make.left.equalTo(levelTitle.snp.right).offset(10)
        }
        
        reviewTitle.snp.makeConstraints { make in
            make.left.equalTo(dateTitle)
            make.top.equalTo(levelTitle.snp.bottom).offset(20)
        }
        
        saveBtn.snp.makeConstraints { make in
            make.left.equalTo(dateTitle)
            make.bottom.equalTo(self.view).offset(-20)
            make.right.equalTo(self.view).offset(-20)
            make.height.equalTo(40)
        }
        
        reviewTextView.snp.makeConstraints { make in
            make.left.equalTo(dateTitle)
            make.top.equalTo(reviewTitle.snp.bottom).offset(10)
            make.right.equalTo(self.view).offset(-20)
            make.bottom.equalTo(saveBtn.snp.top).offset(-20)
        }
        
        initDatePicker()
        
        if let noteItem = noteItem {
            if noteItem.date != "" {
                dateTextField.text = " " + noteItem.date + " "
            }
            if let id = noteItem.foodID {
                viewModel?.getFoodDBInfo(id: id, completion: { food in
                    if let food = food {
                        self.nameBtn.setTitle(" " + food.name + " ", for: .normal)
                    }
                })
            }
            levelStarView.rating = Int(noteItem.level) ?? 0
            reviewTextView.text = noteItem.review
        }
    }
    
    private func initDatePicker() {
        dateTextField.inputView = datePicker
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        // 在按鈕前面加入彈性空間，使按鈕靠右
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "完成", style: .plain, target: self, action: #selector(donePressed))
        toolbar.setItems([flexibleSpace, doneButton], animated: true)
        dateTextField.inputAccessoryView = toolbar
    }
    
    // 當日期變化時，更新 TextField 的文本
    @objc func dateChanged() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy年MM月dd日"
        date = dateFormatter.string(from: datePicker.date)
        dateTextField.text = " " + dateFormatter.string(from: datePicker.date) + " "
    }
    
    // 當完成按鈕按下時，關閉日期選擇器
    @objc func donePressed() {
        dateTextField.resignFirstResponder()
    }
    
    @objc func presentAddFoodView() {
        let vc = AddFoodViewController()
        vc.completionHandler = { item in
            self.nameBtn.setTitle(" " + (item?.name ?? "") + " ", for: .normal)
            self.foodItem = item
        }
        present(vc, animated: true)
    }
    
    @objc func savePressed() {
        if addNoteType == .insert {
            let noteInfo = NoteInfo(level: String(levelStarView.rating),
                                    date: date ?? "",
                                    review: reviewTextView.text,
                                    foodID: foodItem?.id)
            viewModel?.insertNoteToDB(note: noteInfo) {
                self.navigationController?.popViewController(animated: false)
            }
        } else {
            let noteInfo = NoteInfo(id: noteItem?.id,
                                    level: String(levelStarView.rating),
                                    date: date == nil ? noteItem?.date ?? "" : date ?? "",
                                    addDate: noteItem?.addDate ?? "",
                                    review: reviewTextView.text,
                                    foodID: foodItem == nil ? noteItem?.id : foodItem?.id)
            viewModel?.updateNoteDB(model: noteInfo) {
                self.completionHandler?(noteInfo)
                self.navigationController?.popViewController(animated: false)
            }
        }
    }
    
}

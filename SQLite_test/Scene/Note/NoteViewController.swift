//
//  NoteViewController.swift
//  SQLite_test
//
//  Created by IT09F-Public6-MAC on 2024/11/1.
//

import UIKit
import SnapKit
import Combine
import SDWebImage

class NoteViewController: UIViewController {
    
    private var viewModel: NoteViewModel?
    private var cancellables = Set<AnyCancellable>()
    private var noteItems: [NoteInfo] = []
    
    private lazy var noteTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.rowHeight = UITableView.automaticDimension
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        bindViewModel()
    }
    
    private func setupUI() {
        commonSetup()
        
        let rightBarButton = UIBarButtonItem(image: .add, style: .plain, target: self, action: #selector(rightBarButtonTapped))
        navigationItem.rightBarButtonItem = rightBarButton
        
        view.addSubview(noteTableView)
        
        noteTableView.snp.makeConstraints { make in
            make.top.equalTo(self.view)
            make.left.equalTo(self.view).offset(15)
            make.right.equalTo(self.view).offset(-15)
            make.bottom.equalTo(self.view)
        }
        
        noteTableView.delegate = self
        noteTableView.dataSource = self
        noteTableView.showsVerticalScrollIndicator = false
        noteTableView.separatorStyle = .none
        noteTableView.register(NoteTableViewCell.self, forCellReuseIdentifier: "NoteCell")
    }
    
    private func bindViewModel() {
        viewModel = NoteViewModel()
        
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
        
        viewModel?.createNoteTable()
        
        viewModel?.$noteItems
            .receive(on: DispatchQueue.main)
            .sink { [weak self] noteItems in
                print(noteItems)
                self?.noteItems = noteItems
                self?.noteTableView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    @objc func rightBarButtonTapped() {
        let vc = AddNoteViewController(addNoteType: .insert, viewModel: AddNoteViewModel())
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
}

extension NoteViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return noteItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath) as? NoteTableViewCell else {
            return UITableViewCell()
        }
        cell.dateLabel.text = noteItems[indexPath.row].date
        viewModel?.getFoodDBInfo(id: noteItems[indexPath.row].foodID ?? 0, completion: { food in
            cell.picImage.sd_setImage(with: URL(string: food?.picURL ?? ""), placeholderImage: UIImage(named: "doggo"))
            cell.nameLabel.text = food?.name ?? ""
        })
        cell.levelStarView.rating = Int(noteItems[indexPath.row].level) ?? 0
        cell.introductionLabel.text = noteItems[indexPath.row].review
        
        cell.settingBtnHandler = {
            self.showActionSheet(in: self, noteItem: self.noteItems[indexPath.row]) { type, noteItem in
                switch type {
                case .edit:
                    let vc = AddNoteViewController(addNoteType: .edit, viewModel: AddNoteViewModel(), noteItem: noteItem)
                    self.navigationController?.pushViewController(vc, animated: false)
                case .delete:
                    self.viewModel?.deleteNote(model: noteItem)
                }
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailNoteViewController(noteItem: noteItems[indexPath.row], viewModel: DetailNoteViewModel())
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
}

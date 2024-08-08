//
//  ToDoListVC.swift
//  ToDoListApp
//
//  Created by Robert Loo on 11/07/24.
//

import UIKit

enum ToDoListDisplayType {
    case list
    case addNewTask
}

class ToDoListVC: UIViewController {

    //MARK: - IBOutlets
    @IBOutlet weak var tblToDoList: UITableView!
    
    //MARK: - Variables
    private var arrToDoListDisplayType: [ToDoListDisplayType] = [.list]
    private var arrToDoList = [ModelToDoList]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerCell()
        self.getToDoListData()
        self.hideKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setTitleToBar(title: "\(Date().currentDate())\nHi, These are your daily tasks",
                           isLargeDisplayEnable: true,
                           isNormalTitle: false)
    }
    
    @IBAction func btnAdd(_ sender: UIButton) {
        self.arrToDoListDisplayType = [.list, .addNewTask]
        DispatchQueue.main.async {
            self.tblToDoList.reloadData()
        }
    }
}

extension ToDoListVC {
    private func getToDoListData() {
        DBHelperModel.shared.getToDoListData { arrToDoList, error in
            if let error = error {
                print("--- error : ", error.localizedDescription)
            } else if let arrToDoList = arrToDoList {
                self.arrToDoList = arrToDoList.sorted(by: { $0.date! > $1.date! })
                DispatchQueue.main.async {
                    self.tblToDoList.reloadData()
                }
            }
        }
    }
}

extension ToDoListVC: UITableViewDelegate, UITableViewDataSource {
    private func registerCell() {
        self.tblToDoList.delegate = self
        self.tblToDoList.dataSource = self
        let nib = UINib(nibName: "ToDoListCell", bundle: nil)
        self.tblToDoList.register(nib, forCellReuseIdentifier: "ToDoListCell")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.arrToDoListDisplayType.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch self.arrToDoListDisplayType[section] {
        case .list:
            return self.arrToDoList.count
        case .addNewTask:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch self.arrToDoListDisplayType[indexPath.section] {
        case .list:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoListCell", for: indexPath) as! ToDoListCell
            let dict = self.arrToDoList[indexPath.row]
            
            cell.tfTitle.isHidden = true
            cell.lblTitle.isHidden = false
            cell.updateTextStyle(isSelected: dict.isSelected, title: dict.title)
            if dict.isSelected {
                cell.btnCheckMark.isSelected = true
            } else {
                cell.btnCheckMark.isSelected = false
            }
            
            cell.btnClosureItemSelected = { sender in
                if (dict.isSelected == false) {
                    DBHelperModel.shared.updateToDoListData(id: dict.id, newTitle: dict.title ?? "", newDate: Date(), isSelected: true)
                    self.tblToDoList.reloadData()
                }
            }
            
            return cell
        case .addNewTask:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoListCell", for: indexPath) as! ToDoListCell
            
            cell.tfTitle.isHidden = false
            cell.lblTitle.isHidden = true
            cell.tfTitle.tag = indexPath.row
            cell.tfTitle.delegate = self  // Set delegate to self
            cell.btnCheckMark.isSelected = false

            return cell
        }
    }
    
    // Implement swipe to delete
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let todoItem = self.arrToDoList[indexPath.row]
            DBHelperModel.shared.deleteWithId(id: todoItem.id)
            self.arrToDoList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}

extension ToDoListVC: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.arrToDoListDisplayType = [.list]
        if let newText = textField.text {
            DBHelperModel.shared.insertToDoListData(isSelected: false, date: Date(), title: newText)
            self.getToDoListData()
        } else {
            self.tblToDoList.reloadData()
        }
        textField.text = ""
    }
}

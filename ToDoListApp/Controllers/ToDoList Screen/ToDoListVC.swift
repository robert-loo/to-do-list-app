//
//  ToDoListVC.swift
//  ToDoListApp
//
//  Created by Robert Loo on 11/07/24.
//

import UIKit

// Enum to differentiate between displaying the to-do list and adding a new task
enum ToDoListDisplayType {
    case list
    case addNewTask
}

class ToDoListVC: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var tblToDoList: UITableView!
    
    // MARK: - Variables
    private var arrToDoListDisplayType: [ToDoListDisplayType] = [.list] // Array to manage display types
    private var arrToDoList = [ModelToDoList]() // Array to store to-do list items
    private var isAddingNewTask = false // Flag to check if a new task is being added
    private var editingIndexPath: IndexPath? // IndexPath for the cell being edited

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerCell() // Register custom cell
        self.getToDoListData() // Fetch initial to-do list data
        self.hideKeyboardWhenTappedAround() // Hide keyboard when tapping around
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setTitleToBar(
            title: "\(Date().currentDate())\nHi, These are your daily tasks",
            isLargeDisplayEnable: true,
            isNormalTitle: false
        ) // Set the title of the navigation bar
    }
    
    // MARK: - IBActions
    @IBAction func btnAdd(_ sender: UIButton) {
        self.view.resignFirstResponder() // This will dismiss the textfield
        self.isAddingNewTask = true
        self.arrToDoListDisplayType = [.addNewTask, .list] // Switch display to show add new task
        DispatchQueue.main.async {
            self.tblToDoList.reloadData() // Reload table view to reflect changes
        }
    }
}

// MARK: - Data Fetching
extension ToDoListVC {
    private func getToDoListData() {
        DBHelperModel.shared.getToDoListData { [weak self] arrToDoList, error in
            if let error = error {
                print("--- error : ", error.localizedDescription)
            } else if let arrToDoList = arrToDoList {
                self?.arrToDoList = arrToDoList.sorted(by: { $0.date! > $1.date! }) // Sort by date
                DispatchQueue.main.async {
                    self?.tblToDoList.reloadData() // Reload table view with new data
                }
            }
        }
    }
}

// MARK: - UITableViewDelegate & UITableViewDataSource
extension ToDoListVC: UITableViewDelegate, UITableViewDataSource {
    private func registerCell() {
        self.tblToDoList.delegate = self
        self.tblToDoList.dataSource = self
        let nib = UINib(nibName: "ToDoListCell", bundle: nil)
        self.tblToDoList.register(nib, forCellReuseIdentifier: "ToDoListCell")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.arrToDoListDisplayType.count // Number of sections based on display types
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch self.arrToDoListDisplayType[section] {
        case .list:
            return arrToDoList.count // Number of rows for the to-do list
        case .addNewTask:
            return 1 // One row for adding a new task
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch self.arrToDoListDisplayType[indexPath.section] {
        case .list:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoListCell", for: indexPath) as? ToDoListCell else {
                return UITableViewCell()
            }
            let dict = arrToDoList[indexPath.row]
            
            cell.tfTitle.text = dict.title
            cell.tfTitle.tag = indexPath.row
            cell.tfTitle.delegate = self // Set delegate to self for text field
            cell.tfTitle.addTarget(self, action: #selector(didBeginEditing), for: .editingDidBegin) // Add target for editing start
            cell.updateTextStyle(isSelected: dict.isSelected, title: dict.title) // Update text style based on selection
            
            // Set checkmark button state
            cell.btnCheckMark.isSelected = dict.isSelected
            
            // Closure for handling checkmark button tap
            cell.btnClosureItemSelected = { [weak self] sender in
                let isSelected = !dict.isSelected
                DBHelperModel.shared.updateToDoListData(
                    id: dict.id,
                    newTitle: dict.title ?? "",
                    newDate: Date(),
                    isSelected: isSelected
                )
                self?.tblToDoList.reloadData() // Reload data to reflect changes
            }
            
            return cell
            
        case .addNewTask:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoListCell", for: indexPath) as? ToDoListCell else {
                return UITableViewCell()
            }
            
            cell.tfTitle.text = ""
            cell.tfTitle.tag = indexPath.row
            cell.tfTitle.delegate = self  // Set delegate to self
            cell.btnCheckMark.isSelected = false
            
            return cell
        }
    }
    
    // Handle the beginning of text field editing
    @objc func didBeginEditing(_ textField: UITextField) {
        self.editingIndexPath = IndexPath(row: textField.tag, section: 0)
    }
    
    // Implement swipe to delete functionality
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let todoItem = self.arrToDoList[indexPath.row]
            DBHelperModel.shared.deleteWithId(id: todoItem.id) // Delete item from database
            self.arrToDoList.remove(at: indexPath.row) // Remove item from array
            tableView.deleteRows(at: [indexPath], with: .automatic) // Update table view
        }
    }
    
    // Handle row selection
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.editingIndexPath = indexPath
        if let cell = tableView.cellForRow(at: indexPath) as? ToDoListCell {
            cell.tfTitle.becomeFirstResponder() // Make the text field the first responder
        }
    }
}

// MARK: - UITextFieldDelegate
extension ToDoListVC: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return !(arrToDoList[safe: textField.tag]?.isSelected ?? false)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if self.isAddingNewTask {
            if let newText = textField.text, !newText.isEmpty {
                DBHelperModel.shared.insertToDoListData(isSelected: false, date: Date(), title: newText) // Insert new task into database
                self.getToDoListData() // Fetch updated data
            }
            self.isAddingNewTask = false
            self.arrToDoListDisplayType = [.list] // Reset display type
            self.tblToDoList.reloadData()
        } else if let editingIndexPath = self.editingIndexPath {
            let dict = self.arrToDoList[editingIndexPath.row]
            if let newText = textField.text, !newText.isEmpty, newText.lowercased() != dict.title?.lowercased() {
                DBHelperModel.shared.updateToDoListData(
                    id: dict.id,
                    newTitle: newText,
                    newDate: Date(),
                    isSelected: dict.isSelected
                ) // Update task in database
                self.getToDoListData() // Fetch updated data
            } else {
                self.tblToDoList.reloadData() // Reload data to reflect changes
            }
            self.editingIndexPath = nil
        }
        textField.text = ""
    }
}

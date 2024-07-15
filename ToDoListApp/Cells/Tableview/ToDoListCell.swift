//
//  ToDoListCell.swift
//  ToDoListApp
//
//

import UIKit

class ToDoListCell: UITableViewCell {
    
    //MARK: - IBOutlets
    @IBOutlet weak var btnCheckMark: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var tfTitle: UITextField!
    
    //MARK: - Variables
    var btnClosureItemSelected: ((UIButton) -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // Method to update the strikethrough style
    func updateTextStyle(isSelected: Bool, title: String?) {
        guard let title = title else { return }
        if isSelected {
            lblTitle.setStrikethrough(text: title)
        } else {
            lblTitle.attributedText = NSAttributedString(string: title)
        }
    }

    @IBAction func btnActionCheckMark(_ sender: UIButton) {
        if let closure = self.btnClosureItemSelected {
            closure(sender)
        }
    }
}

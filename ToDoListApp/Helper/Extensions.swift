//
//  Extensions.swift
//  ToDoListApp
//
//  Created by Robert Loo on 11/07/24.
//

import UIKit
import Foundation

extension UIViewController {
    
    var className: String {
        return NSStringFromClass(self.classForCoder).components(separatedBy: ".").last!;
    }
    
    func setTitleToBar(title: String, isLargeDisplayEnable: Bool, isNormalTitle: Bool) {
        if isNormalTitle {
            navigationItem.largeTitleDisplayMode = .automatic
            navigationController?.navigationBar.prefersLargeTitles = true
            self.navigationItem.title = title
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Chalkboard SE Regular", size: 17.0)!]
            self.navigationController?.view.tintColor = .black
        } else {
            self.navigationItem.enableMultilineTitle()
            navigationItem.largeTitleDisplayMode = .automatic
            // Customize large title font size
            let customFont = UIFont.systemFont(ofSize: 25, weight: .bold) // Replace with your desired font and size
            let fontMetrics = UIFontMetrics(forTextStyle: .largeTitle)
            let customFontMetrics = fontMetrics.scaledFont(for: customFont)

            self.navigationController?.navigationBar.largeTitleTextAttributes = [
                NSAttributedString.Key.font: customFontMetrics
            ]
            self.navigationController?.view.tintColor = .black
            navigationController?.navigationBar.prefersLargeTitles = true
            self.navigationItem.title = title
        }
    }
}

extension Date {
    func currentDate() -> String {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d, yyyy"
        let date = Date()
        return dateFormatter.string(from: date)
    }
}

extension UINavigationItem {
   func enableMultilineTitle() {
      setValue(true, forKey: "__largeTitleTwoLineMode")
   }
}

// Put this piece of code anywhere you like
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension UILabel {
    func setStrikethrough(text: String) {
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: text)
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
        self.attributedText = attributeString
    }
}

extension UIViewController {
    func setupNavigationMultilineTitle() {
        guard let navigationBar = self.navigationController?.navigationBar else { return }
        for sview in navigationBar.subviews {
            for ssview in sview.subviews {
                guard let label = ssview as? UILabel else { break }
                if label.text == self.title {
                    label.numberOfLines = 0
                    label.lineBreakMode = .byWordWrapping
                    label.sizeToFit()
                    UIView.animate(withDuration: 0.3, animations: {
                        navigationBar.frame.size.height = 57 + label.frame.height
                    })
                }
            }
        }
    }
}

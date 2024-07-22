//
//  UIView.swift
//  ToDoListApp
//
//  Created by Robert Loo on 11/07/24.
//

import UIKit
import Foundation

extension UIView {
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            //            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var topCornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            //            layer.masksToBounds = newValue > 0
            layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        }
    }
    
    @IBInspectable var bottomCornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            //            layer.masksToBounds = newValue > 0
            layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
            // could we please try to remove these force unwraps? Maybe nil coalescing with a default value could be a good solution.
        }
        set {
            layer.borderColor = newValue?.withAlphaComponent(0.7).cgColor
        }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.masksToBounds = false
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.masksToBounds = false
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.masksToBounds = false
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable
    var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }
    
    @IBInspectable
    var isShowShadow: Bool {
        get {
            return self.isShowShadow
        }
        set {
            if newValue {
                layer.applySketchShadow()
            }
        }
    }
    
    func setCornerRadiusWithoutRightSideBottom() {
        self.layer.cornerRadius = 15
        self.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner,.layerMinXMaxYCorner]
    }
    
    func setCornerRadiusWithoutLeftSideBottom() {
        self.layer.cornerRadius = 15
        self.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner,.layerMaxXMaxYCorner]
    }
    
}

// MARK:- extension CALayer
extension CALayer {
    func applySketchShadow(color: UIColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.08), alpha: Float = 1.0, x: CGFloat = 0, y: CGFloat = 4, blur: CGFloat = 40, spread: CGFloat = 0){
        DispatchQueue.main.async { [self] in
            shadowColor = color.cgColor
            shadowOpacity = alpha
            shadowOffset = CGSize(width: x, height: y)
            shadowRadius = blur / 2.0
            if spread == 0 {
                shadowPath = nil
            } else {
                let dx = -spread
                let rect = bounds.insetBy(dx: dx, dy: dx)
                shadowPath = UIBezierPath(rect: rect).cgPath
            }
        }
    }
}

//
//  UITextFieldExtension.swift
//  MyNetwork
//
//  Created by Guillermo on 20/05/23.
//

import UIKit

extension UITextField {

    func setBottomBorder(borderColor: UIColor?) {
        self.borderStyle = .none
        self.layer.backgroundColor = UIColor.white.cgColor
        
        let border = CALayer()
        let width = CGFloat(2.0)
        border.borderColor = (borderColor ?? UIColor.clear).cgColor 
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width, height: self.frame.size.height)
        
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
}


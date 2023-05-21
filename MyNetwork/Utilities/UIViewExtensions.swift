//
//  UIViewExtensions.swift
//  MyNetwork
//
//  Created by Guillermo on 20/05/23.
//

import UIKit

extension UIView {
    func addShadow(color: UIColor = .black, opacity: Float = 0.5, offset: CGSize = CGSize(width: 0, height: 2), radius: CGFloat = 2.0) {
            layer.shadowColor = color.cgColor
            layer.shadowOpacity = opacity
            layer.shadowOffset = offset
            layer.shadowRadius = radius
            layer.masksToBounds = false
        }
}

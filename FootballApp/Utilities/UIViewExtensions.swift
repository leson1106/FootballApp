//
//  UIViewExtensions.swift
//  FootBallApp
//
//  Created by Son Le on 18/01/2024.
//

import UIKit

extension UIView {
    func makeRoundedCorner(radius: CGFloat, borderColor: UIColor? = nil, borderWidth: CGFloat = 1) {
        clipsToBounds = true
        layer.cornerRadius = radius
        if let borderColor {
            layer.borderColor = borderColor.cgColor
            layer.borderWidth = borderWidth
        }
    }
}

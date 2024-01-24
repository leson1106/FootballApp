//
//  UIImageViewExtensions.swift
//  FootBallApp
//
//  Created by Son Le on 18/01/2024.
//

import UIKit
import Nuke

extension UIImageView {
    func loadImage(url: URL?, placeholder: UIImage? = nil) {
        let options = ImageLoadingOptions(
            placeholder: placeholder,
            transition: .fadeIn(duration: 0.25)
        )
        Nuke.loadImage(with: url, options: options, into: self)
    }
}

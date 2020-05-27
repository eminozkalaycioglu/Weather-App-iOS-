//
//  UICollectionViewCellExtension.swift
//  WeatherApp
//
//  Created by Emin on 25.05.2020.
//  Copyright © 2020 Emin. All rights reserved.
//

import Foundation
import UIKit

extension UICollectionViewCell {
    
    func setShadow(color: UIColor, opacity: Float, shadowRadius: CGFloat, cornerRadius: CGFloat) {
        
        self.layer.cornerRadius = cornerRadius
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.clear.cgColor

        self.layer.backgroundColor = UIColor.clear.cgColor
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = CGSize(width: 2.0, height: 4.0)
        self.layer.shadowRadius = shadowRadius
        self.layer.shadowOpacity = opacity
        self.layer.masksToBounds = false
    }
}

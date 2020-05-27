//
//  UIViewExtension.swift
//  WeatherApp
//
//  Created by Emin on 25.05.2020.
//  Copyright © 2020 Emin. All rights reserved.
//

import Foundation
import UIKit
extension UIView {
    func setShadow(color: UIColor, opacity: Float, radius: CGFloat) {
        self.layer.shadowColor = color.cgColor
        self.layer.masksToBounds = false
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowRadius = radius
        
    }
    
    func doCircle() {
        self.layer.cornerRadius = self.frame.size.width/2
        self.clipsToBounds = true
    }
    
    func getGradientLayer(colors: [String], targetView: UIView) {
        
        for layer in (self.layer.sublayers ?? []){
            if let layer1 = layer as? CAGradientLayer{
                layer1.removeFromSuperlayer()
            }
        }
        
        var cgColors: [CGColor] = [CGColor]()
        
        for color in colors {
            cgColors.append(color.hexStringToUIColor().cgColor)
        }
        
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.colors = cgColors
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = targetView.bounds
        
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
}




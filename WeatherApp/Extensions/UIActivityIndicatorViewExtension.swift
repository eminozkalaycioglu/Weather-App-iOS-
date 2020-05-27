//
//  UIActivityIndicatorViewExtension.swift
//  WeatherApp
//
//  Created by Emin on 25.05.2020.
//  Copyright © 2020 Emin. All rights reserved.
//

import Foundation
import UIKit
extension UIActivityIndicatorView {
    
    convenience init(activityIndicatorStyle: UIActivityIndicatorView.Style, color: UIColor, placeInTheCenterOf parentView: UIView) {
        self.init(style: activityIndicatorStyle)
        center = parentView.center
        self.color = color
        parentView.addSubview(self)
    }
}

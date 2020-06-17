//
//  HourlyForecastCollectionViewCell.swift
//  WeatherApp
//
//  Created by Emin on 27.05.2020.
//  Copyright © 2020 Emin. All rights reserved.
//

import UIKit

class HourlyForecastCollectionViewCell: UICollectionViewCell {
    
    let colors = [
            "#006064", //yeşil
            "#ff6f00", //turuncu
            "#1565c0", //mavi
            "#b71c1c", //kırmızı
            "#aa00ff", //mor
            "#aeea00", //f yeşil
            "#73433d", //kahve
            "#19d3cd"  //trk
                  
    ]
    private var iconStr: String! {
        didSet {
            self.weatherIconImageView.image = UIImage(named: iconStr)
            self.weatherIconImageView.image = self.weatherIconImageView.image?.withRenderingMode(.alwaysTemplate)
            self.weatherIconImageView.tintColor = self.colors[self.colorIndex].hexStringToUIColor()
        }
    }
    private var colorIndex: Int!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var weatherIconImageView: UIImageView!
    @IBOutlet weak var tempLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func setImageStr(str: String) {
        self.iconStr = str
    }
    
    func setColorIndex(_ index: Int) {
        self.colorIndex = index
    }
    

}

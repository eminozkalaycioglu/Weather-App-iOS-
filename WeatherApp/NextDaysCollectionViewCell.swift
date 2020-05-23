//
//  NextDaysCollectionViewCell.swift
//  WeatherApp
//
//  Created by Emin on 18.05.2020.
//  Copyright © 2020 Emin. All rights reserved.
//

import UIKit

class NextDaysCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var weatherIcon: UIImageView!
    
    
    @IBOutlet weak var cloudView: UIView!
    @IBOutlet weak var baseView: BaseView!
    @IBOutlet weak var morningTempOfDay: UILabel!
    @IBOutlet weak var nightTempOfDay: UILabel!
    @IBOutlet weak var tempOfDay: UILabel!
    @IBOutlet weak var nameOfDayLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.weatherIcon.image = self.weatherIcon.image?.withRenderingMode(.alwaysTemplate)
        self.weatherIcon.tintColor = UIColor.white
        self.cloudView.backgroundColor = UIColor(patternImage: UIImage(named: "cloud")!)
        // Initialization code
    }

}

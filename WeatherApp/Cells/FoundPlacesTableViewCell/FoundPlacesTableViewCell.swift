//
//  FoundPlacesTableViewCell.swift
//  WeatherApp
//
//  Created by Emin on 28.03.2020.
//  Copyright © 2020 Emin. All rights reserved.
//

import UIKit

class FoundPlacesTableViewCell: UITableViewCell {

    @IBOutlet weak var secondPartOfAddress: UILabel!
    @IBOutlet weak var firsstPartOfAddress: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

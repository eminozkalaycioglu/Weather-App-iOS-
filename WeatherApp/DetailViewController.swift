//
//  DetailViewController.swift
//  WeatherApp
//
//  Created by Emin on 23.05.2020.
//  Copyright © 2020 Emin. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var dismissImageView: UIImageView!
    @IBOutlet weak var dismissView: UIView!
    @IBOutlet weak var baseView: BaseView!
    @IBOutlet weak var testLabel: UILabel!
    
    private var forecast: [ForecastList]?
    private var baseViewGradientColors: [String]?
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(actionClose(_:))))
        self.view.frame = UIScreen.main.bounds
        self.setComponents()


    }
  
    
    @objc func actionClose(_ tap:UITapGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func setForecast(forecast: [ForecastList]) {
        self.forecast = forecast
    }
    
    func setBaseViewGradientColors(colors: [String]) {
        self.baseViewGradientColors = colors
    }
    
    func setComponents() {
        self.testLabel.text = DateToDay.shared.getNameOfDay(dayOfWeek: DateToDay.shared.getDayOfWeek((self.forecast?[0].dtTxt)!)!)
        
        if let colors = self.baseViewGradientColors {
            self.baseView.getGradientLayer(colors: colors, targetView: self.view)
        }
        else {
            self.baseView.backgroundColor = UIColor.blue
        }
        
        self.dismissView.doCircle()
        self.dismissView.setShadow(color: UIColor.gray, opacity: 0.6, radius: 5)
//        self.dismissView.layer.shadowColor = UIColor.gray.cgColor
//        self.dismissView.layer.masksToBounds = false
//        self.dismissView.layer.shadowOpacity = 0.6
//
//        self.dismissView.layer.shadowOffset = CGSize.zero
//        self.dismissView.layer.shadowRadius = 5
        
        self.dismissImageView.image = self.dismissImageView.image?.withRenderingMode(.alwaysTemplate)
        self.dismissImageView.tintColor = "#FF0090".hexStringToUIColor()
    }
    
  
    
    

}



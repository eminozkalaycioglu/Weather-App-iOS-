//
//  DetailViewController.swift
//  WeatherApp
//
//  Created by Emin on 23.05.2020.
//  Copyright © 2020 Emin. All rights reserved.
//

import UIKit
import Hero

class DetailViewController: UIViewController {

    @IBOutlet weak var hourlyForecastCollectionView: UICollectionView!
    @IBOutlet weak var dismissImageView: UIImageView!
    @IBOutlet weak var dismissView: UIView!
    @IBOutlet weak var baseView: BaseView!
    @IBOutlet weak var weatherIconImageView: UIImageView!
    @IBOutlet weak var testLabel: UILabel!
    
    @IBOutlet weak var tempOfDayLabel: UILabel!
    @IBOutlet weak var tempOfNightLabel: UILabel!
    @IBOutlet weak var tempOfMorningLabel: UILabel!
    
    private var forecast: [ForecastList]?
    private var baseViewGradientColors: [String]?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dismissView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(actionClose(_:))))
        self.setupCollectionViews()
        self.hero.isEnabled = true
        self.baseView.hero.id = "selectedCell"
        self.baseView.hero.modifiers = [.translate(y:100)]
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.dismissView.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.dismissView.isHidden = false
        
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.setLayout()
    }
    
    
    @objc func actionClose(_ tap:UITapGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func setupCollectionViews() {
        
        self.hourlyForecastCollectionView.delegate = self
        self.hourlyForecastCollectionView.dataSource = self
        self.hourlyForecastCollectionView.register(UINib(nibName: "HourlyForecastCollectionViewCell", bundle: nil),
                                               forCellWithReuseIdentifier: "HourlyForecastCollectionViewCell")
        self.hourlyForecastCollectionView.showsHorizontalScrollIndicator = false
        self.hourlyForecastCollectionView.showsVerticalScrollIndicator = false
        self.setupNextDaysCollectionViewLayout()
        
    }
    
    func setupNextDaysCollectionViewLayout() {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 4)
        self.hourlyForecastCollectionView.setCollectionViewLayout(layout, animated: true)
        
    }
    
    func setForecast(forecast: [ForecastList]) {
        self.forecast = forecast
    }
    
    func setBaseViewGradientColors(colors: [String]) {
        self.baseViewGradientColors = colors
    }
    
    private func setLayout() {
        self.view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.75)
        
        self.tempOfNightLabel.font = self.tempOfNightLabel.font.withSize(self.tempOfDayLabel.font.pointSize/2)
        self.tempOfMorningLabel.font = self.tempOfMorningLabel.font.withSize(self.tempOfDayLabel.font.pointSize/2)

        if let date = self.forecast?[0].dtTxt?.stringToDate() {
            self.testLabel.text = DateToDay.shared.getNameOfDayFromDate(date: date)
        }
        var weatherIcon = "searchButton"
        var tempOfDay: Float = 0
        var tempOfNight: Float = 0
        var tempOfMorning: Float = 0
        for item in self.forecast! {
            if item.dtTxt?.stringToDate().getHour() == 12 {
                weatherIcon = "a" + (item.weather?.first?.icon ?? "")
                tempOfDay = item.main?.temp ?? 0
                
            }
            if item.dtTxt?.stringToDate().getHour() == 9 {
                tempOfMorning = item.main?.temp ?? 0

            }
            if item.dtTxt?.stringToDate().getHour() == 21 {
                tempOfNight = item.main?.temp ?? 0

            }
            
        }
        
        self.tempOfDayLabel.text = String(Int(tempOfDay)) + "°"
        self.tempOfNightLabel.text = String(Int(tempOfNight)) + "°"
        self.tempOfMorningLabel.text = String(Int(tempOfMorning)) + "°"
        
        self.weatherIconImageView.image = UIImage(named: weatherIcon)
        
        if let colors = self.baseViewGradientColors {
            self.baseView.getGradientLayer(colors: colors, targetView: self.view)
        }
        else {
            self.baseView.backgroundColor = UIColor.blue
        }

        self.dismissView.doCircle()
        self.dismissView.setShadow(color: UIColor.gray, opacity: 0.6, radius: 5)
        
        let path = UIBezierPath(roundedRect:self.baseView.bounds, byRoundingCorners:[.topRight, .topLeft], cornerRadii: CGSize(width: 40, height: 40))
        let maskLayer = CAShapeLayer()

        maskLayer.path = path.cgPath
        self.baseView.layer.mask = maskLayer

        self.dismissImageView.image = self.dismissImageView.image?.withRenderingMode(.alwaysTemplate)
        self.dismissImageView.tintColor = "#FF0090".hexStringToUIColor()
    }
    
}

extension DetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.forecast?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HourlyForecastCollectionViewCell", for:indexPath) as! HourlyForecastCollectionViewCell
        let hourAndMinute = self.forecast?[indexPath.row].dtTxt?.stringToDate().getHourAndMinute()
        if let hour = hourAndMinute?.hour, let minute = hourAndMinute?.minute {
            cell.timeLabel.text = String(format: "%02ld:%02ld", hour, minute)
        }
        else {
            cell.timeLabel.text = ""
        }
        
        let icon = "a" + (self.forecast?[indexPath.row].weather?[0].icon ?? "")
        
        cell.setColorIndex(indexPath.row)
        cell.setImageStr(str: icon)
        
        if let temp = self.forecast?[indexPath.row].main?.temp {
            cell.tempLabel.text = String(Int(temp)) + "°"
        }
        else {
            cell.tempLabel.text = "°"
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 50, height: 80)
    }
    
}

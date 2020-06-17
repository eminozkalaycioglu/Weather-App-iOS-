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

    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var hourlyForecastCollectionView: UICollectionView!
    @IBOutlet weak var dismissImageView: UIImageView!
    @IBOutlet weak var dismissView: UIView!
    @IBOutlet weak var baseView: BaseView!
    @IBOutlet weak var weatherIconImageView: UIImageView!
    @IBOutlet weak var tempOfDayLabel: UILabel!
    @IBOutlet weak var tempOfNightLabel: UILabel!
    @IBOutlet weak var tempOfMorningLabel: UILabel!
    
    private var baseViewGradientColors: [String]?
    
    lazy var viewModel: DetailViewModel = {
        return DetailViewModel()
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dismissView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(actionClose(_:))))
        self.setupCollectionViews()
        self.hero.isEnabled = true
        self.baseView.hero.id = "selectedCell"
        self.baseView.hero.modifiers = [.translate(y:100)]
        
        self.viewModel.hourIs12Closure = {
            [weak self] (_ temp: Int, _ weatherIcon: String) in
            DispatchQueue.main.async {
                self?.weatherIconImageView.image = UIImage(named: weatherIcon)
                self?.tempOfDayLabel.text = String(temp) + "°"
            }
            
        }
        
        self.viewModel.hourIs9Closure = {
            [weak self] (_ temp: Int) in
            DispatchQueue.main.async {
                self?.tempOfMorningLabel.text = String(temp) + "°"
            }
            
        }
        
        self.viewModel.hourIs21Closure = {
            [weak self] (_ temp: Int) in
            DispatchQueue.main.async {
                self?.tempOfNightLabel.text = String(temp) + "°"
            }
            
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.dismissView.isHidden = true
        self.hideMainForecast(true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.dismissView.isHidden = false
        self.hideMainForecast(false)
        
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
    
    func hideMainForecast(_ status: Bool) {
        
        self.weatherIconImageView.isHidden = status
        self.tempOfDayLabel.isHidden = status
        self.tempOfNightLabel.isHidden = status
        self.tempOfMorningLabel.isHidden = status
    }
    func setBaseViewGradientColors(colors: [String]) {
        self.baseViewGradientColors = colors
    }
    
    private func setLayout() {
        self.view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.75)
        
        self.tempOfNightLabel.font = self.tempOfNightLabel.font.withSize(self.tempOfDayLabel.font.pointSize/2)
        self.tempOfMorningLabel.font = self.tempOfMorningLabel.font.withSize(self.tempOfDayLabel.font.pointSize/2)

        self.dayLabel.text = self.viewModel.getNameOfDay()

        self.viewModel.setMainForecast()
        
        if let colors = self.baseViewGradientColors {
            self.baseView.getGradientLayer(colors: colors, targetView: self.view)
        }
        else {
            self.baseView.backgroundColor = UIColor.blue
        }

        self.dismissView.makeCircle()
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
        return self.viewModel.getForecastCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HourlyForecastCollectionViewCell", for:indexPath) as! HourlyForecastCollectionViewCell
        let hourAndMinute = self.viewModel.getHourAndMinute(at: indexPath)
        
        if let hour = hourAndMinute?.hour, let minute = hourAndMinute?.minute {
            cell.timeLabel.text = String(format: "%02ld:%02ld", hour, minute)
        }
        else {
            cell.timeLabel.text = ""
        }
        
        let icon = self.viewModel.getSpecificForecastWeatherIcon(at: indexPath)
        
        cell.setColorIndex(indexPath.row)
        cell.setImageStr(str: icon)
        
        if let temp = self.viewModel.getSpecificForecastTemp(at: indexPath) {
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

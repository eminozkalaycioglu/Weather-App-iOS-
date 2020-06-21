//
//  ViewController.swift
//  WeatherApp
//
//  Created by Emin on 22.03.2020.
//  Copyright © 2020 Emin. All rights reserved.
//

import UIKit
import CoreLocation
import Hero

class ViewController: UIViewController, UIViewControllerTransitioningDelegate {

    @IBOutlet weak var selectedPlaceLabel: UILabel!
    @IBOutlet weak var searchButtonOutlet: UIButton!
    
    @IBOutlet weak var todayForecastViewWidth: NSLayoutConstraint!
    @IBOutlet weak var collectionViewsViewHeight: NSLayoutConstraint!
    @IBOutlet weak var collectionViewsView: UIView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var todayHumidityLabel: UILabel!
    @IBOutlet weak var todayWeatherLabel: UILabel!
    @IBOutlet weak var todayTempLabel: UILabel!
    @IBOutlet weak var todayForecastView: BaseView!
    @IBOutlet weak var numberOfNextForecastLabel: UILabel!
    @IBOutlet weak var nextDaysCollectionView: UICollectionView!
    
    lazy var viewModel: MainViewModel = {
        return MainViewModel()
    }()
    
    var activityIndicator: UIActivityIndicatorView?
    var selectedCell: NextDaysCollectionViewCell?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.isAnimating(true)
        self.viewModel.getWeatherInfo()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.collectionViewsViewHeight.constant = self.getMaxCollectionViewCellHeight() + 80

        let widthLimit = UIScreen.main.bounds.width - 32
        if self.todayForecastView.frame.size.height <= widthLimit{
            self.todayForecastView.addConstraint(NSLayoutConstraint(item: self.todayForecastView!, attribute: .height, relatedBy: .equal, toItem: self.todayForecastView, attribute: .width, multiplier: 1, constant: 0))

        }
        else {
            let widthConstraint = NSLayoutConstraint(item: self.todayForecastView!, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: widthLimit)
            self.todayForecastView.addConstraint(widthConstraint)
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        self.definesPresentationContext = true
        
        self.activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge, color: .gray,  placeInTheCenterOf: view)
        self.isAnimating(true)
        self.todayForecastView.backgroundColor = "5D50FE".hexStringToUIColor()
        
        self.viewModel.setTodayForecastViewClosure = { [weak self] () in
            DispatchQueue.main.async {
                self?.setTodayForecastView()
            }
        }
        self.viewModel.reloadDataNextDaysCollectionViewClosure = { [weak self] () in
            DispatchQueue.main.async {
                self?.nextDaysCollectionView.reloadData()
            }
        }
        
        self.viewModel.setAnimateClosure = {
            [weak self] (_ status: Bool) in
            DispatchQueue.main.async {
                self?.isAnimating(status)
            }
        }
        
        self.viewModel.setSelectedPlaceLabelTextClosure = {
            [weak self] ( _ administrative: String, countryCode: String) in
            DispatchQueue.main.async {
                self?.selectedPlaceLabel.text = administrative + ", " + countryCode
            }
        }
        
        self.setupLocationManager()
//        self.viewModel.getDefaultPlace()
        self.setupCollectionViews()
        
    }
    
    func isAnimating( _ status : Bool) {
        
        if status {
            self.activityIndicator?.startAnimating()
        }
        else {
            self.activityIndicator?.stopAnimating()
        }
        self.mainView.isHidden = status

    }
    func setupLocationManager() {
        self.viewModel.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.viewModel.locationManager.delegate = self
        self.viewModel.locationManager.requestWhenInUseAuthorization()
    }
    
    func setupCollectionViews() {
        
        self.nextDaysCollectionView.delegate = self
        self.nextDaysCollectionView.dataSource = self
        self.nextDaysCollectionView.register(UINib(nibName: "NextDaysCollectionViewCell", bundle: nil),
                                               forCellWithReuseIdentifier: "NextDaysCollectionViewCell")
        self.nextDaysCollectionView.showsHorizontalScrollIndicator = false
        self.nextDaysCollectionView.showsVerticalScrollIndicator = false
        
        self.setupNextDaysCollectionViewLayout()
        
    }
    
    func setupNextDaysCollectionViewLayout() {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 16, right: 0)
        self.nextDaysCollectionView.setCollectionViewLayout(layout, animated: true)
        
    }
    
    func setTodayForecastView() {
        
        let todayForecast = self.viewModel.getTodayForecast()
        self.todayTempLabel.text = "\(Int(todayForecast.main?.temp ?? 0))°"
        self.todayWeatherLabel.text = "\(todayForecast.weather?[0].main ?? "")"
        self.todayHumidityLabel.text = "%\(todayForecast.main?.humidity ?? 0)"
    }
    
    func getMaxCollectionViewCellHeight() -> CGFloat{
        var height = UIScreen.main.bounds.height/3
        if height > 260 {
            height = 260
        }
        return height
    }
    
    
    @IBAction func searchButtonAction(_ sender: Any) {
        
        let searchVC = SearchPlaceViewController()
        searchVC.modalPresentationStyle = .fullScreen
        self.present(searchVC, animated: true, completion: nil)
        
    }
    
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.numberOfNextForecastLabel.text = "Next \(self.viewModel.getExtractedForecastListCount()) Days"
        return self.viewModel.getExtractedForecastListCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NextDaysCollectionViewCell", for:indexPath) as! NextDaysCollectionViewCell
        
        let temperatures = self.viewModel.getExtractedForecastList(at: indexPath)
        if let date = temperatures?.forecastOfDay?.dtTxt?.stringToDate() {
            cell.nameOfDayLabel.text = DateToDay.shared.getNameOfDayFromDate(date: date)
        }
        
        var iconString: String!
        if let icon = temperatures?.forecastOfDay?.weather?[0].icon {
            iconString = "a" + icon
        }
        else {
            iconString = "noIcon"
        }
        let image = UIImage(named: iconString)
        
        cell.baseView.getGradientLayer(colors: self.viewModel.getColors(at: indexPath), targetView: cell)
        cell.weatherIcon.image = image
        cell.tempOfDay.text = "\(Int(temperatures?.forecastOfDay?.main?.temp ?? 0))°"
        cell.nightTempOfDay.text = "\(Int(temperatures?.nightForecastOfDay?.main?.temp ?? 0))°"
        cell.morningTempOfDay.text = "\(Int(temperatures?.morningForecastOfDay?.main?.temp ?? 0))°"
        
        cell.setShadow(color: (self.viewModel.getColors(at: indexPath).last?.hexStringToUIColor() ?? UIColor.yellow), opacity: 3.0, shadowRadius: 6.0, cornerRadius: cell.baseView.layer.cornerRadius)


        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 191, height: self.getMaxCollectionViewCellHeight())
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedCell?.hero.id = nil
        self.selectedCell = collectionView.cellForItem(at: indexPath) as? NextDaysCollectionViewCell
        self.selectedCell?.hero.id = "selectedCell"
        let detailVC = DetailViewController()
        detailVC.setBaseViewGradientColors(colors: self.viewModel.getColors(at: indexPath))
        detailVC.viewModel.setForecast(forecast: self.viewModel.getSpecificDayForecast(at: indexPath) ?? [ForecastList]())
        detailVC.modalPresentationStyle = .overFullScreen
        
        self.present(detailVC, animated: true, completion: nil)
        
    }
    
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.viewModel.getDefaultPlace()
    }
}

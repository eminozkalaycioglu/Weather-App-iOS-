//
//  ViewController.swift
//  WeatherApp
//
//  Created by Emin on 22.03.2020.
//  Copyright © 2020 Emin. All rights reserved.
//

import UIKit
import BubbleTransition

class ViewController: UIViewController {

    @IBOutlet weak var selectedPlaceLabel: UILabel!
    @IBOutlet weak var searchButtonOutlet: UIButton!
    
    @IBOutlet weak var collectionViewsView: UIView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var todayHumidityLabel: UILabel!
    @IBOutlet weak var todayWeatherLabel: UILabel!
    @IBOutlet weak var todayTempLabel: UILabel!
    @IBOutlet weak var todayForecastView: BaseView!
    @IBOutlet weak var numberOfNextForecastLabel: UILabel!
    @IBOutlet weak var nextDaysCollectionView: UICollectionView!
    
    
    let transition = BubbleTransition()
    var activityIndicator: UIActivityIndicatorView?
    var forecastModel: ForecastModel?
    var extractedForecastList: [ExtractedForecast]?
    let colorsArray: [[String]] = [
        ["#FFE000","#799F0C"],
        ["#FF0099","#493240"],
        ["#000000","#0f9b0f"],
        ["#f12711","#f5af19"]
        
    ]
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.isAnimating(true)
        self.getWeatherInfo()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionViewsView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height*100/100)
        self.activityIndicator = UIActivityIndicatorView(activityIndicatorStyle:.whiteLarge, color: .gray,  placeInTheCenterOf: view)
        self.isAnimating(true)

        self.todayForecastView.backgroundColor = "5D50FE".hexStringToUIColor()
        self.getDefaultPlace()
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
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 0)
        self.nextDaysCollectionView.setCollectionViewLayout(layout, animated: true)
        
    }
    
    func getDefaultPlace() {
        ServiceManager.shared.getPlaces(query: PlaceData.shared.defaultQuery) { (result) in
            
            switch result {
            case .success(let response):
                PlaceData.shared.place = response.hits?[0]
                self.getWeatherInfo()
                
            case .failure(let error):
                debugPrint(error.localizedDescription)
                
            }
            
        }
    }
    
    func getWeatherInfo() {
        
        guard let lat = PlaceData.shared.place?.geoloc?.lat, let lon = PlaceData.shared.place?.geoloc?.lng else { return }
        
        ServiceManager.shared.getWeather(lat: lat, lon: lon) { (result) in
            switch result {
            case .success(let response):
                
                self.forecastModel = response
                self.extractedForecastList = self.extractForecast(forecast: response)
                self.getTodayForecast()
                self.nextDaysCollectionView.reloadData()
                self.isAnimating(false)
                
            case .failure(let error):
                print(error)
            }
        }
        self.selectedPlaceLabel.text = (PlaceData.shared.place?.administrative?[0] ?? "") + ", " + (PlaceData.shared.place?.countryCode?.uppercased() ?? "")
        
    }
    
    func getTodayForecast() {
        let todayForecast = self.findTodayForecast(forecast: self.forecastModel ?? ForecastModel())
        self.todayTempLabel.text = "\(Int(todayForecast.main?.temp ?? 0))°"
        self.todayWeatherLabel.text = "\(todayForecast.weather?[0].main ?? "")"
        self.todayHumidityLabel.text = "%\(todayForecast.main?.humidity ?? 0)"
    }
    
    func findTodayForecast(forecast: ForecastModel) -> ForecastList {
        
        let dateOfToday = forecast.list?[0].dtTxt?.stringToDate()
        
        for forecastItem in forecast.list! {
            if dateOfToday?.daysBetweenDates(endDate: (forecastItem.dtTxt?.stringToDate())!) == 0 && forecastItem.dtTxt?.stringToDate().getHour() == 12 {
                return forecastItem
            }
        }
        return (forecast.list?[0])!
        
        
    }
    
    func extractForecast(forecast: ForecastModel) -> [ExtractedForecast] {
        var tempForecast = forecast
        
        let dateOfToday = tempForecast.list?[0].dtTxt?.stringToDate()
        while (dateOfToday?.daysBetweenDates(endDate: (tempForecast.list?[0].dtTxt?.stringToDate())!))! < 1 {
            tempForecast.list?.remove(at: 0)
            
        }
        var extractedList: [ExtractedForecast] = [ExtractedForecast()]
        extractedList.remove(at: 0)
        var extracted: ExtractedForecast = ExtractedForecast()
        for tempForecasts in tempForecast.list! {
            if tempForecasts.dtTxt?.stringToDate().getHour() == 12 {
                extracted.forecastOfDay = tempForecasts
                continue
            }
            if tempForecasts.dtTxt?.stringToDate().getHour() == 6 {
                extracted.morningForecastOfDay = tempForecasts
                continue
            }
            if tempForecasts.dtTxt?.stringToDate().getHour() == 21 {
                extracted.nightForecastOfDay = tempForecasts
                extractedList.append(extracted)
                
            }
            
        }
        
        return extractedList
        
    }
    
    
    
    @IBAction func searchButtonAction(_ sender: Any) {
        
        let searchVC = SearchPlaceViewController()
        self.present(searchVC, animated: true, completion: nil)
    }
    
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.numberOfNextForecastLabel.text = "Next \(self.extractedForecastList?.count ?? 0) Days"
        return self.extractedForecastList?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NextDaysCollectionViewCell", for:indexPath) as! NextDaysCollectionViewCell
        
        let temperatures = self.extractedForecastList?[indexPath.row]
        
        let date = temperatures?.forecastOfDay?.dtTxt ?? ""
        
        let dayOfWeek = DateToDay.shared.getDayOfWeek(date) ?? 10
        
        let nameOfDay = DateToDay.shared.getNameOfDay(dayOfWeek: dayOfWeek)
        
        
        
        cell.baseView.layer.insertSublayer(self.getGradientLayer(colors: self.colorsArray[indexPath.row], targetView: cell), at: 0)
        let icon = temperatures?.forecastOfDay?.weather?[0].icon ?? "searchButton"
        
        cell.weatherIcon.image = UIImage(named: "a" + icon )
        
        cell.nameOfDayLabel.text = nameOfDay
        cell.tempOfDay.text = "\(Int(temperatures?.forecastOfDay?.main?.temp ?? 0))°"
        cell.nightTempOfDay.text = "\(Int(temperatures?.nightForecastOfDay?.main?.temp ?? 0))°"
        cell.morningTempOfDay.text = "\(Int(temperatures?.morningForecastOfDay?.main?.temp ?? 0))°"

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 191, height: 252 )
        
    }
    
    
}

extension ViewController {
    func getGradientLayer(colors: [String], targetView: UIView) -> CAGradientLayer {
        var cgColors: [CGColor] = [CGColor]()
        
        for color in colors {
            cgColors.append(color.hexStringToUIColor().cgColor)
        }
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.colors = cgColors
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = targetView.bounds
        
        return gradientLayer
    }
    
    
}

extension ViewController:UIViewControllerTransitioningDelegate {
    
}

extension UIActivityIndicatorView {
    
    convenience init(activityIndicatorStyle: UIActivityIndicatorView.Style, color: UIColor, placeInTheCenterOf parentView: UIView) {
        self.init(style: activityIndicatorStyle)
        center = parentView.center
        self.color = color
        parentView.addSubview(self)
    }
}



//
//  ViewController.swift
//  WeatherApp
//
//  Created by Emin on 22.03.2020.
//  Copyright © 2020 Emin. All rights reserved.
//

import UIKit
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
    
    var activityIndicator: UIActivityIndicatorView?
    var forecastModel: ForecastModel?
    var extractedForecastList: [ExtractedForecast]?
    var nextDaysForecastList: [[ForecastList]]?
    let colorsArray: [[String]] = [
        ["#FF416C","#FF4B2B"],
        ["#9370DB","#2F0743"],
        ["#6DCA98","#005528"],
        ["#f5af19","#f12711"],
        ["#FF416C","#FF4B2B"],
        ["#9370DB","#2F0743"],
        ["#6DCA98","#005528"],
        ["#f5af19","#f12711"]
        
    ]
    
    var selectedCell: NextDaysCollectionViewCell?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.isAnimating(true)
                
                
        self.getWeatherInfo()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.collectionViewsViewHeight.constant = self.getCollectionViewCellHeight() + 80

        let widthLimit = UIScreen.main.bounds.width - 32
        if self.todayForecastView.frame.size.height <= widthLimit{
            self.todayForecastView.addConstraint(NSLayoutConstraint(item: self.todayForecastView, attribute: .height, relatedBy: .equal, toItem: self.todayForecastView, attribute: .width, multiplier: 1, constant: 0))

        }
        else {
            let widthConstraint = NSLayoutConstraint(item: self.todayForecastView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: widthLimit)
            self.todayForecastView.addConstraint(widthConstraint)
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.definesPresentationContext = true
        
        self.activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge, color: .gray,  placeInTheCenterOf: view)
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
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 16, right: 0)
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
                self.nextDaysForecastList = self.extractForecastAsNextDays(forecast: response)
                self.setTodayForecastView()
                self.nextDaysCollectionView.reloadData()
                self.isAnimating(false)
                
            case .failure(let error):
                print(error)
            }
        }
        self.selectedPlaceLabel.text = (PlaceData.shared.place?.administrative?[0] ?? "") + ", " + (PlaceData.shared.place?.countryCode?.uppercased() ?? "")
        
    }
    
    func setTodayForecastView() {
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
    
    func extractForecastAsNextDays(forecast: ForecastModel) -> [[ForecastList]] {
        var tempForecast = forecast
        
        let dateOfToday = tempForecast.list?[0].dtTxt?.stringToDate()
        while (dateOfToday?.daysBetweenDates(endDate: (tempForecast.list?[0].dtTxt?.stringToDate())!))! < 1 {
            tempForecast.list?.remove(at: 0)
        }
        
        var extractedList = [[ForecastList()]]
        extractedList.remove(at: 0)
        var extracted = [ForecastList()]
        extracted.remove(at: 0)
        
        for item in tempForecast.list! {
            if extractedList.count == self.extractedForecastList?.count {
                break
            }
            extracted.append(item)
            
            if item.dtTxt?.stringToDate().getHour() == 21  {
                extractedList.append(extracted)
                extracted.removeAll()
            }
        }
        
        return extractedList
        
    }
    
    @IBAction func searchButtonAction(_ sender: Any) {
        
        let searchVC = SearchPlaceViewController()
        searchVC.modalPresentationStyle = .fullScreen
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
        if let date = temperatures?.forecastOfDay?.dtTxt?.stringToDate() {
            cell.nameOfDayLabel.text = DateToDay.shared.getNameOfDayFromDate(date: date)
        }
        
        let icon = temperatures?.forecastOfDay?.weather?[0].icon ?? "searchButton"
        let image = UIImage(named: "a" + icon)
        cell.baseView.getGradientLayer(colors: self.colorsArray[indexPath.row], targetView: cell)
        cell.weatherIcon.image = image
        cell.tempOfDay.text = "\(Int(temperatures?.forecastOfDay?.main?.temp ?? 0))°"
        cell.nightTempOfDay.text = "\(Int(temperatures?.nightForecastOfDay?.main?.temp ?? 0))°"
        cell.morningTempOfDay.text = "\(Int(temperatures?.morningForecastOfDay?.main?.temp ?? 0))°"
        
        cell.setShadow(color: (self.colorsArray[indexPath.row].last?.hexStringToUIColor() ?? UIColor.yellow), opacity: 3.0, shadowRadius: 6.0, cornerRadius: cell.baseView.layer.cornerRadius)


        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        return CGSize(width: 191, height: self.getCollectionViewCellHeight())
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedCell?.hero.id = nil
        self.selectedCell = collectionView.cellForItem(at: indexPath) as? NextDaysCollectionViewCell
        
        let detailVC = DetailViewController()

        detailVC.setBaseViewGradientColors(colors: self.colorsArray[indexPath.row])
        detailVC.setForecast(forecast: self.nextDaysForecastList?[indexPath.row] ?? [ForecastList]())
        detailVC.modalPresentationStyle = .overFullScreen
        
        self.selectedCell?.hero.id = "selectedCell"
        self.present(detailVC, animated: true, completion: nil)
        
    }
    
}

extension ViewController {
    func getCollectionViewCellHeight() -> CGFloat{
        var height = UIScreen.main.bounds.height/3
        if height > 260 {
            height = 260
        }
        return height
    }
}

//
//  ViewController.swift
//  Swift_05
//
//  Created by 陈孟迪 on 2017/11/27.
//  Copyright © 2017年 陈孟迪. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController,CLLocationManagerDelegate {

    var label : UILabel?
    var locationManager : CLLocationManager?
    var location : CLLocation?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        label = UILabel.init(frame: CGRect.init(x: 0, y: 100, width: self.view.frame.size.width, height: 200))
        label?.textAlignment = .center
        label?.textColor = UIColor.black
        label?.numberOfLines = 0
        label?.font = UIFont.systemFont(ofSize: 15)
        self.view.addSubview((label)!)
        
        let button:UIButton = UIButton.init(type: UIButtonType.custom)
        button.frame = CGRect.init(x: (self.view.frame.size.width-100)/2, y: 400, width: 100, height: 50)
        button.setTitle("获取位置", for: .normal)
        button.backgroundColor = UIColor.gray
        button.setTitleColor(UIColor.black, for: .normal)
        self.view.addSubview(button)
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(action(sender:)), for: .touchUpInside)
        
    }
    
    @objc func action(sender:UIButton) {
        
        locationManager = CLLocationManager.init()
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.distanceFilter = 10
        locationManager?.delegate = self
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.startUpdatingLocation()
    }
  
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(locations)
        let loc:CLLocation = locations[locations.count-1]
        location = locations.last
        
        if loc.horizontalAccuracy > 0 {
            let lat =  String.init(format: "%.1f", (location?.coordinate.latitude)!)
            let long = String.init(format: "%.1f", (location?.coordinate.longitude)!)
            print(String.init(format: "lat:%@,long:%@", lat,long))
            //将经纬度转换成城市名
            let geocoder:CLGeocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(location!, completionHandler: { (placemark, error) in
               
                if error == nil{
                    let array = placemark! as NSArray
                    let mark = array.firstObject as! CLPlacemark
                    
                    //城市
                    let city:String = (mark.addressDictionary! as NSDictionary).value(forKey: "City") as! String
                    //国家
                    let country:NSString = (mark.addressDictionary! as NSDictionary).value(forKey: "Country") as! NSString
                    //国家编码
                    let countryCode:NSString = (mark.addressDictionary! as NSDictionary).value(forKey: "CountryCode") as! NSString
                    //街道位置
                    let formattedAddressLines : NSString = ((mark.addressDictionary! as NSDictionary).value(forKey: "FormattedAddressLines") as AnyObject).firstObject as! NSString
                    //具体位置
                    let name:String = ((mark.addressDictionary! as NSDictionary).value(forKey: "Name") as! NSString) as String
                    //省
                    let state:String = (mark.addressDictionary! as NSDictionary).value(forKey: "State") as! String
                    //区
                    let subLocality:NSString = (mark.addressDictionary! as NSDictionary).value(forKey: "SubLocality") as! NSString
                    
                    print(String.init(format: "城市：%@,国家：%@,国家编码：%@,街道位置：%@,具体位置：%@,省：%@,区：%@", city,country,countryCode,formattedAddressLines,name,state,subLocality))
                    self.label?.text = String.init(format: "%@%@",formattedAddressLines,name)
                }else{
                    print(error!)
                }
                
            })
            
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
    }
}


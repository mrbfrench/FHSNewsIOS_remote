//
//  WeatherViewController.swift
//  FHSNewsIOS
//
//  Created by Zachary Keffaber on 3/9/23.
//

import UIKit

class WeatherViewController: UIViewController {

    var currentTemp: UILabel?
    
    func getArticlesInfo() {
        
        //weather Info: http://76.139.70.221:3000/api/weather
        let url = URL(string: "http://76.139.70.221:3000/api/weather")!

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        //var output: AnyObject?//[String: AnyObject]?
        //output = nil

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                print("ok, we're here now")
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? AnyObject {
                        print(json)
                        print("success!")
                        var temp = (json["current_temp"] as! NSNumber).stringValue
                        temp += "°"
                        print(temp)
                        DispatchQueue.main.async {
                          self.currentTemp!.text = temp
                        }
                    } else {
                        print("Not JSON...")
                    }
                } catch {
                    print("Something went wrong")
                }
            } else if let error = error {
                print("HTTP Request Failed \(error)")
            }
        }

        task.resume()
        
        //return output
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let l = CAGradientLayer()
        
        l.frame = self.view.bounds
        l.colors = [UIColor.systemBlue.cgColor, UIColor.white.cgColor]
        l.startPoint = CGPoint(x: 0, y: 0)
        l.endPoint = CGPoint(x: 1, y: 1)
        
        self.view.layer.insertSublayer(l, at: 0)
        //TODO: Replacement for SF Symbols
        if #available(iOS 13.0, *) {
            let cityName = UILabel.init()
            cityName.text = "Fishers, Indiana"
            cityName.font = UIFont.systemFont(ofSize: 32, weight: .medium)
            cityName.frame = CGRect(x: 10, y: 20, width: self.view.bounds.width - 20, height: 32)
            cityName.textAlignment = .center
            self.view.addSubview(cityName)
            let cloudImage = UIImageView.init(image: UIImage(systemName: "cloud.sun.fill")?.withRenderingMode(.alwaysOriginal))
            cloudImage.frame = CGRect(x: 20, y: 60, width: self.view.bounds.width - 40, height: 180)
            
            self.view.addSubview(cloudImage)
            currentTemp = UILabel.init()
            currentTemp?.text = "72°"
            currentTemp?.font = UIFont.systemFont(ofSize: 50, weight: .medium)
            currentTemp?.frame = CGRect(x: 10, y: 250, width: self.view.bounds.width - 20, height: 50)
            currentTemp?.textAlignment = .center
            self.view.addSubview(currentTemp!)
            getArticlesInfo()
        } else {
            // Fallback on earlier versions
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

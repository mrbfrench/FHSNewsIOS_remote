//
//  WeatherViewController.swift
//  FHSNewsIOS
//
//  Created by Z Keffaber (0xilis) on 3/9/23.
//

import UIKit

class WeatherViewController: UIViewController {

    var currentTemp: UILabel?
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    /*func getArticlesInfo() {
        
        //weather Info: http://76.139.70.221:3000/api/weather
        //let url = URL(string: "http://76.139.70.221:3000/api/weather")! //this is the URL to the weather API
        let url = URL(string: "https://dev-api.fhs-news.org/api/home")!

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        //var output: AnyObject?//[String: AnyObject]?
        //output = nil

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                print("ok, we're here now")
                let data2 = data
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? AnyObject {
                        print(json)
                        print("success!")
                        //TODO: Follow llsc12's advice and stop using old NS types and use Foundation types instead, ex NSNumber becomes int/float
                        //This code gets "current_temp" from the JSON response that is returned from the API, and converts it to a nsstring, then appends degree symbol to it and sets it as the label
                        //i.e. Gets temperature from weather API, sets it as label
                        //TODO: Fallback if the API JSON request doesn't contain current_temp
                        var temp = (json["current_temp"] as! NSNumber).stringValue
                        temp += "°"
                        print(temp)
                        DispatchQueue.main.async {
                          self.currentTemp!.text = temp
                        }
                    } else {
                        print("Not JSON...")
                        DispatchQueue.main.async {
                            let alert = UIAlertController.init(title: "Error", message: "Failed to get weather info from the API. The server is either currently down or you're disconnected from internet.", preferredStyle: .alert)
                            self.present(alert, animated: true)
                        }
                    }
                    let result = try JSONSerialization.jsonObject(with: data, options: [.mutableContainers])
                    let resultArray = result as! NSMutableArray //->This should always work
                    //print(resultArray) //->shows output...
                    for (NSDictionary dict in resultArray) {
                        print(dict)
                    }
                    for dict in (resultArray as NSArray as! [NSDictionary]) {
                        let keyExists = dict["current_temp"] != nil
                        if (keyExists) {
                            var temp = (dict["current_temp"] as! NSNumber).stringValue
                            temp += "°"
                            print(temp)
                            DispatchQueue.main.async {
                              self.currentTemp!.text = temp
                            }
                        }
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
    }*/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let l = CAGradientLayer()
        
        l.frame = self.view.bounds
        l.colors = [UIColor.systemBlue.cgColor, UIColor.white.cgColor]
        l.startPoint = CGPoint(x: 0, y: 0)
        l.endPoint = CGPoint(x: 1, y: 1)
        
        self.view.layer.insertSublayer(l, at: 0)
        let cityName = UILabel.init()
        cityName.text = "Fishers, Indiana"
        cityName.font = UIFont.systemFont(ofSize: 32, weight: .medium)
        cityName.frame = CGRect(x: 10, y: 20, width: self.view.bounds.width - 20, height: 32)
        cityName.textAlignment = .center
        cityName.textColor = .white
        self.view.addSubview(cityName)
        var cloudImageFrame = CGRect(x: 20, y: 60, width: self.view.bounds.width - 40, height: 180)
        //don't stretch cloud image to over 180
        if cloudImageFrame.size.width > 250 {
            cloudImageFrame.size.width = 250
            cloudImageFrame.origin.x = (self.view.bounds.width / 2) - 125
        }
        let cloudImage = UIImageView.init()
        //You may notice how we are not using SF Symbols natively. This is because SF Symbols are not supported on iOS 12 and below. However to my knowledge, Apple is fine if we embed them in our app for older iOS versions, so that's what we are doing.
        cloudImage.image = UIImage.init(named: "cloud.sun.fill2x")
        cloudImage.frame = cloudImageFrame
            
        self.view.addSubview(cloudImage)
        currentTemp = UILabel.init()
        //TODO: Add an actual alert and don't show current temperature rather than just say it is 72° if API request fails
        //EDIT: Well OK now I have added an alert
        //currentTemp?.text = "72°"
        currentTemp?.text = "Loading..."
        currentTemp?.font = UIFont.systemFont(ofSize: 50, weight: .medium)
        currentTemp?.frame = CGRect(x: 10, y: 250, width: self.view.bounds.width - 20, height: 50)
        currentTemp?.textAlignment = .center
        currentTemp?.textColor = .white
        self.view.addSubview(currentTemp!)
        
        
        //let apiHandler = FHSNewsAPIHandler.sharedInstance
        let apiHandler = globalAPIHandler
        apiHandler.loadAPIInfo { result in
            switch result {
                case .success(let apiResponse):
                    // Update UI with apiResponse
                    let apiHandlerErrorCode = apiHandler.errorCode
                    if apiHandlerErrorCode == 2 {
                    
                        DispatchQueue.main.async {
                            self.currentTemp?.text = "Connect to Internet"
                    
                            //show an error alert
                            let alertController = UIAlertController(title: "FHS News", message: "FHS News has had troubles getting the weather information - maybe your device is not connected or our servers are down?", preferredStyle: .alert)

                            let okAction = UIAlertAction(title: "OK", style: .default) { alert in
                            // Handle OK Action
                            }

                            alertController.addAction(okAction)

                            self.present(alertController, animated: true, completion: nil)
                        }
                    } else {
                    
                        let cachedApiInfo = apiResponse
                        for apiDictionary in cachedApiInfo {
                            if let currentTempValue = apiDictionary["current_temp"] as? Double {
                                DispatchQueue.main.async {
                                    self.currentTemp?.text = String(currentTempValue) + "°"
                                }
                            }
                        }
                    
                        if apiHandlerErrorCode == 1 {
                            //show an error alert
                            DispatchQueue.main.async {
                                let alertController = UIAlertController(title: "FHS News", message: "FHS News has had troubles getting the weather information - maybe your device is not connected or our servers are down? Showing the last saved information...", preferredStyle: .alert)

                                let okAction = UIAlertAction(title: "OK", style: .default) { alert in
                                    // Handle OK Action
                                }

                                alertController.addAction(okAction)

                                self.present(alertController, animated: true, completion: nil)
                            }
                        }
                    }
                    break
                case .failure(let error):
                    // Handle error
                    print("Error in WeatherViewController(1): \(error)")
                    break
            }
        }
        /*let myQueue = DispatchQueue(label: "com.snooliek.fhsnews-afterrequest")
        myQueue.async {
            print("after request")
            print(apiHandler.cachedApiInfo)
        }*/
        
        //Setting the navigaiton controller to have FHS news as the title, color, etc
        self.navigationController?.title = "FHS News"
        if #available(iOS 13.0, *) {
            self.navigationController?.navigationBar.backgroundColor = .white //.systemBackground
            self.navigationController?.navigationBar.largeContentTitle = "FHS News"
        } else {
            self.navigationController?.navigationBar.backgroundColor = .white
        }
        self.navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.blue,
            .font: UIFont.systemFont(ofSize: 21)
        ]
        self.navigationController?.navigationItem.title = "FHS News"
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

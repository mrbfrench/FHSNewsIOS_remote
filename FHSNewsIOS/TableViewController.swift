

import UIKit

//UPDATE: THIS FILE IS NO LONGER USED

    //TODO: SF Symbols not available on iOS 11/12, make a solution
class TableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var tapGesture: UITapGestureRecognizer?
    
    var tableView : UITableView?
    
    var newsNames = ["Loading..."]
    var newsImages = [UIImageView.init(image: UIImage.init(named: "SettingsSnoolieIconV2.png"))]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        newsNames.count
    }
    
    func getArticlesInfo() {
        /*var urlReq = NSMutableURLRequest.init()
        urlReq.httpMethod = "GET"
        urlReq.url = URL.init(string: "http://76.139.70.221:3000/api/weather")
        var error: NSError?
        var responseCode: NSURLResponse?
        
        //[urlReq setValue:@"application/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        //[urlReq setValue:@"*" forHTTPHeaderField:@"Access-Control-Allow-Origin"];
        
        urlReq.setValue("*", forHTTPHeaderField: "Access-Control-Allow-Origin")

        let oResponseData = NSURLConnection.sendSynchronousRequest(urlReq, returningResponse: &responseCode, error: &error)
        
        //NSData *oResponseData = [NSURLConnection sendSynchronousRequest:urlReq returningResponse:&responseCode error:&error];
        
        if([responseCode statusCode] != 200){
            NSLog(@"Error GET, HTTP status code %li", (long)[responseCode statusCode]);
            exit(7829);
        }*/
        
        //weather Info: http://76.139.70.221:3000/api/weather
        //let url = URL(string: "http://76.139.70.221:3000/ArticlesList.json")!
        //let url = URL(string: "http://76.139.70.221:3000/api/home")!
        let url = URL(string: "https://dev-api.fhs-news.org/api/home")!
    

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        //var output: AnyObject?//[String: AnyObject]?
        //output = nil

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                let data2 = data
                do {
                    let result = try JSONSerialization.jsonObject(with: data, options: [.mutableContainers])
                    let resultArray = result as! NSMutableArray //->This should always work
                    //print(resultArray) //->shows output...
                    /*for (NSDictionary dict in resultArray) {
                        print(dict)
                    }*/
                    var iter = 0
                    for dict in (resultArray as NSArray as! [NSDictionary]) {
                      print(dict)
                        //if iter is larger than our array, we'd be overflowing it so instead, break
                      if iter >= self.newsNames.count {
                          if (dict["headline"] != nil) {
                              self.newsNames.append(dict["headline"] as! String? ?? "")
                          }
                      } else {
                          if (dict["headline"] != nil) {
                              self.newsNames[iter] = dict["headline"] as! String? ?? ""
                              iter += 1
                          }
                      }
                    //TODO: This code is uncommented out since if image cant be get, app will fail to load info! Well actually no but it'll keep trying to load image until error which takes a while... make sure to implement a failsafe if image GET fail, as well as actually implement a valid link to the image
                      /*let urlString = dict["articleThumbnail"] as! String
                      let url = NSURL(string: urlString)! as URL
                      print(urlString)
                      if let imageData: NSData = NSData(contentsOf: url) {
                        self.newsImages[iter].image = UIImage(data: imageData as Data)
                      }*/
                      
                    }
                    if iter > 0 {
                      iter = 0
                      DispatchQueue.main.async {
                        self.tableView?.reloadData()
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
    }
    
    func populateCellsWithArticlesInfo(articleInfo: AnyObject?) {
        newsNames[0] = articleInfo!["headline"] as! String
        DispatchQueue.main.async {
            self.tableView?.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if (cell == nil) {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: "cell")
            
        }
        if indexPath.row <= (newsNames.count - 1) {
            cell?.textLabel?.text = newsNames[indexPath.row]
            if indexPath.row <= (newsImages.count - 1) {
                cell?.imageView!.image = newsImages[indexPath.row].image
            }
        } else {
            cell?.textLabel?.text = "Error! You should not be seeing this."
        }
        cell?.addGestureRecognizer(tapGesture!)
        //UITapGestureRecognizer
        return cell!
    }

    override func viewDidLoad() {
     
        super.viewDidLoad()
        tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(didTapCell))
        tableView = UITableView.init(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        tableView?.dataSource = self;
        tableView?.delegate = self;
        self.view.addSubview(tableView!)
        getArticlesInfo()
        // Do any additional setup after loading the view.
    }
    
    @objc func didTapCell(sender: UITapGestureRecognizer) {
        print("tapped")
        //self.present(ViewController.init(), animated: true)
        //self.present(NewsHomeViewController.init(), animated: true)
        //https://stackoverflow.com/questions/24099533/swift-presentviewcontroller#:~:text=Try%20this%3A%20let%20vc%20%3D%20ViewController%20%28%29%20%2F%2Fchange,With%20Swift3%3A%20self.present%20%28vc%2C%20animated%3A%20true%2C%20completion%3A%20nil%29
        let viewController = NewsHomeViewController()
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: true)
        /*if let articleInfo = getArticlesInfo() {
            populateCellsWithArticlesInfo(articleInfo: articleInfo)
        } else {
            print("ERROR WITH FUNC GETWEATHERINFO")
        }*/
        
    }
}


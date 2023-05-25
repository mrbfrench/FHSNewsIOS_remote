//
//  ClubsViewController.swift
//  FHSNewsIOS
//
//  Created by Z Keffaber (0xilis) on 3/28/23.
//

import UIKit

class ClubsViewController: UICollectionViewController {
    
    let dataSource: [String] = ["Football", "Soccer"]
    
    func getArticlesInfo() {
        
        let url = URL(string: "http://76.139.70.221:3000/ArticlesList.json")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let data = data {
                do {
                    let result = try JSONSerialization.jsonObject(with: data, options: [.mutableContainers])
                    let resultArray = result as! NSMutableArray //->This should always work
                    var iter = 0
                    /*for dict in (resultArray as NSArray as! [NSDictionary]) {
                        //if iter is larger than our array, we'd be overflowing it so instead, break
                      if iter >= self.newsNames.count {
                        break
                      }
                      self.newsNames[iter] = dict["headline"] as! String
                      iter += 1
                    }
                    if iter > 0 {
                      iter = 0
                      DispatchQueue.main.async {
                        self.tableView?.reloadData()
                      }
                    }*/
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
        getArticlesInfo()
        // Do any additional setup after loading the view.
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dataSource.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }

}

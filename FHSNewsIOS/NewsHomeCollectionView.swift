//
//  NewsHomeCollectionView.swift
//  FHSNewsIOS
//
//  Created by Z Keffaber (0xilis) on 5/12/23.
//

import Foundation
import UIKit

class NewsHomeViewController : UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    //tjhank u https://www.youtube.com/watch?v=nqhK6a-8LNI
    
    //TODO: Use an actual loading image soon. For now, I'm using an image from one of my unreleased iOS themes, Assonance. Replace the icon latr :/
    var headlines = ["GenericHeadline"]
    var thumbnailURL = ["https://avatars.githubusercontent.com/u/109871561?s=400&u=95afdbb0c619d965a0344f65d69074c74889d453&v=4"]
    var cachedThumbnails = ["abcd": UIImage.init(named: "SettingsSnoolieIconV2.png")]
    
    var collectionView : UICollectionView!
    
    var apiInfo : [AnyObject]!
    
    override func viewDidLoad() {
        self.apiInfo = []
        let apiHandler = globalAPIHandler
        apiHandler.loadAPIInfo { result in
            switch result {
                case .success(let apiResponse):
                    //set apiInfo to apiResponse
                    self.apiInfo = apiResponse
                    break
                case .failure(let error):
                    print("NewsHomeViewController error(1): \(error)")
                    break
            }
        }
        setCollectionView()
        if !self.apiInfo.isEmpty {
            var index = 0
            for apiDictionary in apiInfo {
                if let headline = apiDictionary["headline"] as? String {
                    //ok, we got a headline, now make sure the itemType is a Article...
                    if apiDictionary["itemType"] as! String == "Article" {
                        DispatchQueue.main.async {
                            if index >= self.headlines.count {
                                self.headlines.append(headline)
                                //hopefully no one ever adds an article to the api without an articleThumbnail. if they do, this will crash, but hopefully no one will ever do that because that is stupid
                                self.thumbnailURL.append(apiDictionary["articleThumbnail"] as! String)
                            } else {
                                self.headlines[index] = headline
                                self.thumbnailURL[index] = apiDictionary["articleThumbnail"] as! String
                            }
                            index += 1
                        }
                    }
                }
            }
        }
    }
    
    func setCollectionView() {
        let layout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(FHSNewsCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
    }
    
    private func loadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        if let cachedImage = self.cachedThumbnails[urlString] {
            //we already cached this thumbnail, return the cached thumbnail so we don't need to make another request
            print("reload cached image")
            completion(cachedImage)
            return
        }
        print("image not cached")
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        //The API does not, at the time of writing, ever use these headers, but adding them anyway for future use
        request.setValue("iOS", forHTTPHeaderField: "FHSNewsClientPlatform")
        request.setValue(fhsNewsClientVersion, forHTTPHeaderField: "FHSNewsClientVersion")
        request.setValue(UIDevice.current.systemVersion, forHTTPHeaderField: "FHSNewsDeviceVersion")
        request.setValue(cachedDeviceIdentifier, forHTTPHeaderField: "FHSNews_iOSDeviceID")
        request.setValue(cachedRunningInSimulator, forHTTPHeaderField: "FHSNews_iOSAmIRunningInSimulator")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error loading image: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let data = data else {
                completion(nil)
                return
            }
            
            let image = UIImage(data: data)
            self.cachedThumbnails[urlString] = image
            completion(image)
        }.resume()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return headlines.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //This code goes in to a forever loop
        //But somehow, it still works???? idk
        //In the future, please replace this with an actually good implementation of this method :P
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! FHSNewsCollectionViewCell
        cell.itemIndex = indexPath.row
        //Load my placeholder image
        if (cell.thumbnail.image == nil) {
            cell.thumbnail.image = UIImage(named: "SettingsSnoolieIconV2.png")
        }
        //oki now load actual image
        if indexPath.row < self.thumbnailURL.count {
            loadImage(from: self.thumbnailURL[indexPath.row]) { image in
                if let image = image {
                    // Do something with the image
                    DispatchQueue.main.async {
                        if cell.thumbnail.image != image {
                            cell.thumbnail.image = image
                            cell.headline.text = self.headlines[indexPath.row]
                            
                            //Code for setting the frame of the UILabel
                            //I cannot put this in FHSNewsCollectionViewCell's init method as I am basing this off of the thumbnail frame, which is not calculated in the init method
                            //However, by the time this code runs it will, so it's here
                            //We want our label to be at the bottom of the thumbnail
                            
                            //Set it to have the same starting x point as the thumbnail
                            cell.headline.frame.origin.x = cell.thumbnail.frame.origin.x
                            //Set it to have the same width as the thumbnail
                            cell.headline.frame.size.width = cell.thumbnail.frame.size.width
                            //Make the height of the UILabel, its gonna be 1/8 of the thumbnail's height
                            cell.headline.frame.size.height = (cell.thumbnail.frame.size.height / 8)
                            //Set the starting y point. (cell.thumbnail.frame.origin.y + cell.thumbnail.frame.size.height) will make us start at the bottom of the thumbnail. Afterwards, we substract that point by the height of our label.
                            cell.headline.frame.origin.y = (cell.thumbnail.frame.origin.y + cell.thumbnail.frame.size.height) - (cell.thumbnail.frame.size.height / 8)
                            
                            //reload the data. this seems to cause an inf loop afterwards, since afterwards (I think this is what the problem is) it reloads the data and then reconfigures all cells, and in the process runs this function and ends up re-running the reloadData. However, *somehow* it still seems to correctly reload, despite inf loop?? no idea why, but it still works in the end so I guess its not a priority to fix this, but look into why later.
                            
                            //OK, nevermind, when implementing image caching I somehow fixed it??? I am clueless lol
                            collectionView.reloadData()
                            //print("target0")
                        }
                    }
                } else {
                    // Handle error loading image
                }
            }
        }
        let myQueue = DispatchQueue(label: "com.snooliek.fhsnews-runafterimage")
        myQueue.async {
            // code to execute after target1
            //print("target2")
        }
        //print("target1")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width/2 - 20, height: 250)
    }
    
    //I was originally gonna do this in a gesture recognizer but this is a better way to do it
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("did select item at \(indexPath.row)")
        let viewController = NewsArticleViewController()
        //let navigationController = UINavigationController(rootViewController: viewController)
        //navigationController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: true)
    }
}

class FHSNewsCollectionViewCell : UICollectionViewCell {
    let thumbnail = UIImageView()
    var itemIndex = -1
    let headline = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        /*
         
         Commented out bc we are no longer creating our own gesture recognizers for this
         
        let gestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(imageWasPressed))
        gestureRecognizer.numberOfTapsRequired = 1
        self.addGestureRecognizer(gestureRecognizer)
         */
        
        addSubview(thumbnail)
        
        thumbnail.translatesAutoresizingMaskIntoConstraints = false
        thumbnail.topAnchor.constraint(equalTo: topAnchor).isActive = true
        thumbnail.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        thumbnail.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        thumbnail.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        thumbnail.layer.cornerRadius = 20
        thumbnail.layer.masksToBounds = true
        
        //set some settings of the headline
        headline.textColor = .black
        headline.font = .boldSystemFont(ofSize: 12)
        headline.backgroundColor = .white
        headline.textAlignment = .center
        thumbnail.addSubview(headline)
        
        //give us a black boarder
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 2.0
        self.layer.cornerRadius = 20
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder) has not been implemented")
    }
    
    //This is no longer used since we no longer add gesture recognizers which would have originally triggered this method. So, why am I wasting my time making this comment rather than just removing the method? idk either lol
    @objc func imageWasPressed() {
        //image was pressed
        print("image \(self.itemIndex) was pressed")
    }
}

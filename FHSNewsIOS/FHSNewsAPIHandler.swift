//
//  FHSNewsAPIHandler.swift
//  FHSNewsIOS
//
//  Created by Z Keffaber (0xilis) on 5/12/23.
//

import UIKit

var globalAPIHandler = FHSNewsAPIHandler.init()

//the following is a class that handles the api
class FHSNewsAPIHandler {
    
    var cachedApiInfo : [AnyObject]
    var fileURL : URL
    var errorCode : Int
    
    init() {
        cachedApiInfo = []
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        fileURL = documentsURL.appendingPathComponent("api-data.json")
        errorCode = 0
        print("initialized FHSNewsAPIHandler")
    }
    
    //Function for saving data to a JSON file, ex used in reloadAPIInfo() to cache api info in file for emergency API fallbacks :P.
    //TODO: saveToJSON() currently does not work because I'm an idiot and make this function with [String] instead of [AnyObject]. Oh well not enough time to change it back now. But for future contributors: PLEASE DON'T BE ME - ACTUALLY FIX IT, BECAUSE THIS FUNCTION IS KINDA IMPORTANT :P.
    private func saveToJSON(_ data: Data, filePath: URL) throws {
        let json = try JSONSerialization.jsonObject(with: data, options: [])
        guard let jsonArray = json as? [String] else {
            throw NSError(domain: "Error: Not able to convert to String array.", code: 401, userInfo: nil)
        }
        
        let encodedData = try JSONEncoder().encode(jsonArray)
        try encodedData.write(to: filePath, options: .atomic)
    }
    
    private func readFromJSON(filePath: URL) -> [AnyObject] {
        guard let jsonData = try? Data(contentsOf: filePath),
              let jsonArray = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [AnyObject] else {
            return []
        }
        return jsonArray
    }
    
    // Define a completion handler type
    typealias APILoadCompletionHandler = (Result<[AnyObject], Error>) -> Void
    
    //this is a method for both the first initialization of the api, and possible future times where we may want to reload it even after load
    func reloadAPIInfo(completionHandler: @escaping APILoadCompletionHandler) {
        let url = URL(string: "https://dev-api.fhs-news.org/api/home")!
    
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        //The API does not, at the time of writing, ever use these headers, but adding them anyway for future use
        request.setValue("iOS", forHTTPHeaderField: "FHSNewsClientPlatform")
        request.setValue(fhsNewsClientVersion, forHTTPHeaderField: "FHSNewsClientVersion")
        request.setValue(UIDevice.current.systemVersion, forHTTPHeaderField: "FHSNewsDeviceVersion")
        request.setValue(cachedDeviceIdentifier, forHTTPHeaderField: "FHSNews_iOSDeviceID")
        request.setValue(cachedRunningInSimulator, forHTTPHeaderField: "FHSNews_iOSAmIRunningInSimulator")
        /*let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    let result = try JSONSerialization.jsonObject(with: data, options: [.mutableContainers])
                    
                    guard let jsonArray = result as? [AnyObject] else {
                        throw NSError(domain: "Error: Not able to convert to AnyObject array.", code: 401, userInfo: nil)
                    }
                    //TODO: If saveToJSON fails, cachedApiInfo will not be set, despite the reloadApiInfo call being successful. This will cause the loadAPIInfo() to incorrectly output errorCode 2 even if the call to this method successfully gets the API info if it fails to save the cache in the filesystem, despite how, while yes, saving the cache in the filesystem is really wanted, it's not *needed* since we can just use the current cachedApiInfo that we *were* able to get anyway.
                    self.cachedApiInfo = jsonArray
                    if !jsonArray.isEmpty {
                        self.errorCode = 0 //since reloadAPIInfo was successful, even if we did previously error, since now we successfully loaded the API info, reset errorCode to 0
                        //try self.saveToJSON(data, filePath: self.fileURL)
                        completionHandler(.success(jsonArray))
                    }
                } catch {
                    print("Something went wrong: \(error)")
                    completionHandler(.failure(error))
                }
            } else if let error = error {
                print("HTTP Request Failed \(error)")
            }
        }*/
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                    let result = try JSONSerialization.jsonObject(with: data, options: [.mutableContainers])
                    
                    guard let jsonArray = result as? [AnyObject] else {
                        throw NSError(domain: "Error: Not able to convert to AnyObject array.", code: 401, userInfo: nil)
                    }
                    //TODO: If saveToJSON fails, cachedApiInfo will not be set, despite the reloadApiInfo call being successful. This will cause the loadAPIInfo() to incorrectly output errorCode 2 even if the call to this method successfully gets the API info if it fails to save the cache in the filesystem, despite how, while yes, saving the cache in the filesystem is really wanted, it's not *needed* since we can just use the current cachedApiInfo that we *were* able to get anyway.
                    self.cachedApiInfo = jsonArray
                    if !jsonArray.isEmpty {
                        self.errorCode = 0 //since reloadAPIInfo was successful, even if we did previously error, since now we successfully loaded the API info, reset errorCode to 0
                        //try self.saveToJSON(data, filePath: self.fileURL)
                        completionHandler(.success(jsonArray))
                    }
                } catch {
                    print("Something went wrong: \(error)")
                    completionHandler(.failure(error))
                }
            } else if let error = error {
                print("HTTP Request Failed \(error)")
            }
        }

        task.resume()
    }
    
    func loadAPIInfo(completionHandler: @escaping APILoadCompletionHandler) {
        //check if we have already loaded the api, if so it will be cached in our var
        //if errorCode is not 0 though, that means that we had an API fail. Even if the API was populated from the cache in the file, we should try reload the api again :P.
        if (!cachedApiInfo.isEmpty && (errorCode == 0)) {
            //TODO: in the future, when preform reloadAPIInfo, save a timestamp and if timestamp is diff enough, reload cache anyway
            //but for now - !cachedApiInfo.isEmpty means we already have api info cached, so no need to reload API info again
            completionHandler(.success(cachedApiInfo))
            return
        }
        reloadAPIInfo { result in
            switch result {
                case .success(let apiResponse):
                    self.cachedApiInfo = apiResponse
                    if self.cachedApiInfo.isEmpty {
                        //errorCode is 1, signifying that while we cannot load API info, we were able to load a cache from a file. still, show an alert since it was not successful.
                        self.errorCode = 1
                        self.cachedApiInfo = self.readFromJSON(filePath: self.fileURL)
                        if self.cachedApiInfo.isEmpty {
                            //errorCode is 2, signifying we could not load API OR load a cached response from a file
                            self.errorCode = 2
                        }
                    }
                    completionHandler(.success(apiResponse))
                case .failure(let error):
                    if self.cachedApiInfo.isEmpty {
                        //errorCode is 1, signifying that while we cannot load API info, we were able to load a cache from a file. still, show an alert since it was not successful.
                        self.errorCode = 1
                        self.cachedApiInfo = self.readFromJSON(filePath: self.fileURL)
                        if self.cachedApiInfo.isEmpty {
                            //errorCode is 2, signifying we could not load API OR load a cached response from a file
                            self.errorCode = 2
                        }
                    }
                    completionHandler(.failure(error))
            }
        }
    }
    
}

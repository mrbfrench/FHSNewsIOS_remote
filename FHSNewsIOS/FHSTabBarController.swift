//
//  FHSTabBarController.swift
//  FHSNewsIOS
//
//  Created by Z Keffaber (0xilis) on 4/27/23.
//

import UIKit

class CustomTabBar: UITabBar {
    override func layoutSubviews() {
        super.layoutSubviews()

        // Adjust the frame of the tab bar to be floating 10 points above the bottom of the screen
        var tabBarFrame = frame
        tabBarFrame.origin.x = 10.0
        tabBarFrame.size.width = superview!.bounds.width - 20.0
        tabBarFrame.origin.y = superview!.bounds.height - frame.height - 10.0
        frame = tabBarFrame
    }
}

class FHSTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        tabBar.backgroundColor = UIColor.init(red: 255, green: 255, blue: 255, alpha: 1)
        tabBar.layer.cornerRadius = 10
        
        // Set the frame of the tab bar to be floating 10 points above the bottom of the screen
        var tabBarFrame = tabBar.frame
        tabBarFrame.origin.x = 10.0
        tabBarFrame.size.width = view.bounds.width - 20.0
        tabBarFrame.origin.y = view.bounds.height - tabBarFrame.height - 10.0
        tabBar.frame = tabBarFrame
        
        // Set the background color and corner radius for the custom tab bar
        let customTabBar = CustomTabBar()
        customTabBar.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        customTabBar.layer.cornerRadius = 10
        customTabBar.frame.origin.x = 10.0
                
        // Set the custom tab bar as the tab bar for the tab bar controller
        setValue(customTabBar, forKey: "tabBar")
        
        // Do any additional setup after loading the view.
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

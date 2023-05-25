//
//  ViewController.swift
//  FHSNewsIOS
//
//  Created by Brigham French on 1/6/23.
//

//UPDATE: THIS FILE IS NO LONGER USED

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
     //Not used ever in the final app. So, why am I making this comment rather than just simply deleting this file like a sane human would? I have no idea lol.
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let button = UIButton.init()
        button.setTitle("Questions", for: UIControl.State.normal)
        button.setTitleColor(UIColor.systemTeal, for: UIControl.State.normal)
        button.frame = CGRect(x: UIScreen.main.bounds.width / 4, y: (UIScreen.main.bounds.height / 3), width: UIScreen.main.bounds.width / 2, height: UIScreen.main.bounds.height / 2)
        //view.backgroundColor = UIColor.blue
        button.tintColor = UIColor.systemPink
        button.backgroundColor = UIColor.systemPink
        button.layer.cornerRadius = 5.0
        let didTap = UITapGestureRecognizer.init(target: self, action: #selector(didTapButton))
        button.addGestureRecognizer(didTap)
        view.addSubview(button)
        // Do any additional setup after loading the view.
    }


    @objc func didTapButton(sender: UITapGestureRecognizer) {
        print("numa numa")
        let h = TableViewController.init()
        //let navbar = UINavigationController.init(rootViewController: self)
        navigationController?.pushViewController(h, animated: true)
        //present(h,animated: true)
    }

}

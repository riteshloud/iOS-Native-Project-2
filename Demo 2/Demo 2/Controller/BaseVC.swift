//
//  BaseVC.swift
//  Demo 2
//
//  Created by Demo MACBook Pro on 21/04/22.
//  Copyright © 2022 Demo Team. All rights reserved.
//

import UIKit

class BaseVC: UIViewController {

    // MARK:- VIEWCONTROLLER LIFE CYCLE -
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.barTintColor = UIColor.white   
//        self.navigationController?.navigationBar.barStyle = .black
        self.navigationController?.navigationBar.tintColor = UIColor.red
//        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor : Colors.labelColor, .font : UIFont(name: Fonts.NunitoBold, size: 18)!]
        
        
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor : Colors.labelColor, .font : UIFont.systemFont(ofSize: 17.0, weight: .semibold)]
        self.navigationController?.navigationBar.isTranslucent = false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
}

//
//  BossFreeTrialExpiredVC.swift
//  Demo 2
//
//  Created by Demo MACBook Pro on 15/05/20.
//  Copyright © 2022 Demo Team. All rights reserved.
//

import UIKit

class BossFreeTrialExpiredVC: UIViewController {
    
    @IBOutlet weak var vwContent: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var btnShowAllPackages: UIButton!
    @IBOutlet weak var btnLogout: UIButton!
    
    var navigationControllerLocal: UINavigationController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    // MARK:- ACTIONS -
    
    @IBAction func btnShowAllPackagesTapped(_ sender: UIButton) {
        self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
        let vc = AppFunctions.bossSubscriptionsStoryBoard().instantiateViewController(withIdentifier: "BossSubscriptionsVC") as! BossSubscriptionsVC
        vc.isFromFreeTrialExpired = true
        self.navigationControllerLocal?.pushViewController(vc, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func btnLogoutTapped(_ sender: UIButton) {
        appDelegate.logoutUser()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.dismiss(animated: true, completion: nil)
        }
    }
}

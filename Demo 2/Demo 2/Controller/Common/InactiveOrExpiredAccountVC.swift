//
//  InactiveOrExpiredAccountVC.swift
//  Demo 2
//
//  Created by Demo MACBook Pro on 15/05/20.
//  Copyright © 2022 Demo Team. All rights reserved.
//

import UIKit

class InactiveOrExpiredAccountVC: BaseVC {

    // MARK:- PROPERTIES & OUTLETS -
    @IBOutlet weak var vwPopup: UIView!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var lblFirst: UILabel!
    @IBOutlet weak var btnSupportMail: UIButton!
    @IBOutlet weak var lblSecond: UILabel!
    @IBOutlet weak var btnWebsite: UIButton!
    @IBOutlet weak var lblThird: UILabel!
    
    @IBOutlet weak var lblSeperator: UILabel!
    @IBOutlet weak var btnContinue: UIButton!
    
    var isFromLoginScreen: Bool = false
    
    // MARK:- VIEWCONTROLLER LIFE CYCLE -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.isOpaque = false
        view.backgroundColor = UIColor.black.withAlphaComponent(0.30)
        
         
        
        if self.isFromLoginScreen {
            self.lblSeperator.isHidden = true
            self.btnContinue.isHidden = true
            self.btnClose.isHidden = false
            self.lblThird.isHidden = true
        } else {
            self.lblSeperator.isHidden = false
            self.btnContinue.isHidden = false
            self.btnClose.isHidden = true
            self.lblThird.isHidden = false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    // MARK:- ACTIONS -
    @IBAction func btnCloseDialogTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnSupportEmailTapped(_ sender: UIButton) {
        let email = "support@dummy.com"
        if let url = URL(string: "mailto:\(email)") {
          if #available(iOS 10.0, *) {
            UIApplication.shared.open(url)
          } else {
            UIApplication.shared.openURL(url)
          }
        }
    }
    
    @IBAction func btnWebsiteTapped(_ sender: UIButton) {
        guard let url = URL(string: "https://www.dummy.com") else { return }
        UIApplication.shared.open(url)
    }
    
    @IBAction func btnContinueTapped(_ sender: UIButton) {
        appDelegate.logoutUser()
    }
}

extension UIButton {
    func underlineButton(text: String) {
        let titleString = NSMutableAttributedString(string: text)
        titleString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0, text.count))
        self.setAttributedTitle(titleString, for: .normal)
    }
}

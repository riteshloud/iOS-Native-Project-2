//
//  SplashVideoVC.swift
//  Demo 2
//
//  Created by Demo MACBook Pro on 17/06/20.
//  Copyright © 2022 Demo Team. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import SwiftyJSON

class SplashVideoVC: BaseVC {

    var player = AVPlayer()
    var isVideoFinished: Bool = false
    var isDataAvailable: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.getConfigData()        
        self.loadVideo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: nil)
    }

    //PLAY SPLASH VIDEO
    private func loadVideo() {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.ambient)
        } catch { }

        let path = Bundle.main.path(forResource: "Splash", ofType:"mp4")

        player = AVPlayer(url: NSURL(fileURLWithPath: path!) as URL)
        
        //ADDED NOTIFICATION OBSERVER TO NOTIFY US WHEN VIDEO FINISH PLAYING
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: .AVPlayerItemDidPlayToEndTime, object: nil)
        
        let playerLayer = AVPlayerLayer(player: player)

        playerLayer.frame = self.view.frame
        playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        playerLayer.zPosition = -1

        self.view.layer.addSublayer(playerLayer)

        player.seek(to: CMTime.zero)
        player.play()
    }

    @objc func playerDidFinishPlaying(note: NSNotification) {
        isVideoFinished = true
        self.moveToDashboard()
    }
    
    //GO TO NEXT SCREEN AS PER CONDITIONS
    func moveToDashboard() {
        if self.isVideoFinished && self.isDataAvailable {
            if defaults.object(forKey: authToken) != nil {
                if let data = defaults.value(forKey: loggedInUserData) as? Data,
                    let object = try? JSONDecoder().decode(User.self, from: data) {
                    
                    appDelegate.objLoggedInUser = object
                    appDelegate.employeeTimesheeetStatus = appDelegate.objLoggedInUser.objEmployeeInfo.objEmployeeSetting.timesheet_status
                    
                    //UPDATE GLOBAL DATE FORMAT AND TIME FORMAT
                    if appDelegate.objLoggedInUser.login_type == "Company".localized() {
                        AppFunctions.sharedInstance.setGlobalDateFormat(strFormat: appDelegate.objLoggedInUser.objCompanyInfo.date_format)
                        AppFunctions.sharedInstance.setGlobalTimeFormat(strFormat: appDelegate.objLoggedInUser.objCompanyInfo.time_format)
                        AppFunctions.sharedInstance.setGlobalTimeZone(strTimezone: appDelegate.objLoggedInUser.objCompanyInfo.time_zone)
                    }
                    else {
                        AppFunctions.sharedInstance.setGlobalDateFormat(strFormat: appDelegate.objLoggedInUser.objEmployeeInfo.date_format)
                        AppFunctions.sharedInstance.setGlobalTimeFormat(strFormat: appDelegate.objLoggedInUser.objEmployeeInfo.time_format)
                        AppFunctions.sharedInstance.setGlobalTimeZone(strTimezone: appDelegate.objLoggedInUser.objEmployeeInfo.objEmployeeSetting.timezone)
                    }
                    
                    if appDelegate.objLoggedInUser.reg_status_two == true {
                        if appDelegate.objLoggedInUser.login_type == "Company".localized() {
                            let leftMenuVC = AppFunctions.bossSidemenuStoryBoard().instantiateViewController(withIdentifier: "BossLeftMenuVC") as! BossLeftMenuVC
                            leftMenuVC.strSelectedItem = "Dashboard".localized()
                            let vc = AppFunctions.bossDashboardStoryBoard().instantiateViewController(withIdentifier: "BossDashboardVC") as! BossDashboardVC
                            let navController = UINavigationController.init(rootViewController: vc)
                            appDelegate.drawerController.contentViewController = navController
                            appDelegate.drawerController.menuViewController = leftMenuVC
                            appDelegate.window?.rootViewController = appDelegate.drawerController
                        } else {
                            
                            let controller = AppFunctions.employeeTabBarStoryBoard().instantiateViewController(withIdentifier: "EmployeeTabBarVC") as! EmployeeTabBarVC
                            controller.isEmployeeLoginForFirstTime = false
                            appDelegate.window?.rootViewController = controller
                        }
                    } else {
                        let vc = AppFunctions.mainStoryBoard().instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                        vc.isFromOnBoardingScreen = false
                        let navController = UINavigationController.init(rootViewController: vc)
                        appDelegate.window?.rootViewController = navController
                    }
                }
                else {
                    let vc = AppFunctions.mainStoryBoard().instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                    vc.isFromOnBoardingScreen = false
                    let navController = UINavigationController.init(rootViewController: vc)
                    appDelegate.window?.rootViewController = navController
                }
            }
            else {
                let isOnBoradingScreenDisplay: Bool = defaults.bool(forKey: isOnBoradingScreenDisplayed)
                if !isOnBoradingScreenDisplay {
                    let vc = AppFunctions.mainStoryBoard().instantiateViewController(withIdentifier: "OnboardingVC") as! OnboardingVC
                    let navController = UINavigationController.init(rootViewController: vc)
                    appDelegate.window?.rootViewController = navController
                }
                else {
                    let vc = AppFunctions.mainStoryBoard().instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                    vc.isFromOnBoardingScreen = false
                    let navController = UINavigationController.init(rootViewController: vc)
                    appDelegate.window?.rootViewController = navController
                }
            }
        }
    }
}

//MARK:- API Call
extension SplashVideoVC {
    func getConfigData() {
        if AppFunctions.checkInternet() == false {
            if (defaults.value(forKey: configurationData) as? Data) != nil {
                debugPrint("CONFIG DATA AVAILABLE")
                self.isDataAvailable = true
            }
            else {
                debugPrint("CONFIG DATA NOT AVAILABLE")
                AppFunctions.sharedInstance.showLightStyleToastMesage(message: INTERNET_UNAVAILABLE)
//                AppFunctions.displayAlert(INTERNET_UNAVAILABLE)
            }
            
            self.moveToDashboard()
            return
        }
        
        AFWrapper.requestGETURL(BASE_URL + Constants.URLS.GET_COMMON_LIST, success: { (JSONResponse) in
                        
            if JSONResponse != JSON.null {
                if let response = JSONResponse.rawValue as? [String : Any] {
                    if response["code"] as! Int == 200 {
                        let payloadData = response["payload"]  as! [String : Any]
                        
                        AppFunctions.sharedInstance.objConfiguration = ConfigDataObject.init(payloadData)
                        
                        if let data = try? JSONEncoder().encode(AppFunctions.sharedInstance.objConfiguration) {
                            defaults.set(data, forKey:configurationData)
                            defaults.synchronize()
                        }
                        
                        self.isDataAvailable = true
                        self.moveToDashboard()
                    }
                    else if response["code"] as! Int == 300 || response["code"] as! Int == 301 || response["code"] as! Int == 302 || response["code"] as! Int == 401 {
                        AppFunctions.displayInvalidTokenAlert((response["message"] as! String))
                    }
                    else {
//                        AppFunctions.displayAlert((response["message"] as! String))
                    }
                }
            }
        }) { (error) in
            AppFunctions.sharedInstance.showDarkStyleToastMesage(message: NETWORK_ERROR)
        }
    }
}

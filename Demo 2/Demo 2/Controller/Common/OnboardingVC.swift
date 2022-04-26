//
//  OnboardingVC.swift
//  Demo 2
//
//  Created by Demo MACBook Pro on 11/06/20.
//  Copyright © 2022 Demo Team. All rights reserved.
//

import UIKit
//import SCPageControl

class OnboardingVC: BaseVC {

    // MARK:- PROPERTIES & OUTLETS -
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    //    @IBOutlet weak var viewPaging: SCPageControlView!
    @IBOutlet weak var btnSkip: UIButton!
    
    @IBOutlet weak var btnSignUpForFree: UIButton!
    @IBOutlet weak var btnSignIn: UIButton!
    
    var boardingImage: [UIImage] = [#imageLiteral(resourceName: "onboard_first"), #imageLiteral(resourceName: "onboard_second"), #imageLiteral(resourceName: "onboard_third"), #imageLiteral(resourceName: "onboard_forth"), #imageLiteral(resourceName: "onboard_fifth")]
    
    var arrTitle = ["Try for free".localized(), "Time Tracking".localized(), "Team".localized(), "Timesheet".localized(), "Payroll".localized()]
    
    var arrSubTitle = ["Lorem Ipsum is simply dummy text of the printing and typesetting industry.".localized(), "Lorem Ipsum is simply dummy text of the printing and typesetting industry.".localized(), "Lorem Ipsum is simply dummy text of the printing and typesetting industry.".localized(), "Lorem Ipsum is simply dummy text of the printing and typesetting industry.".localized(), "Lorem Ipsum is simply dummy text of the printing and typesetting industry.".localized()]
    
    let reuseIdentifier = "BoardingCell"
    
    // MARK:- VIEWCONTROLLER LIFE CYCLE -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    // MARK:- ACTIONS -
    
    @IBAction func btnSkipClick(_ sender: UIButton) {
        defaults.set(true, forKey: isOnBoradingScreenDisplayed)
        defaults.synchronize()
        
        let vc = AppFunctions.mainStoryBoard().instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        vc.isFromOnBoardingScreen = false
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnSignUpForFreeTapped(_ sender: UIButton) {
        defaults.set(true, forKey: isOnBoradingScreenDisplayed)
        defaults.synchronize()
        
        let vc = AppFunctions.mainStoryBoard().instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        vc.isFromOnBoardingScreen = true
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    @IBAction func btnSignInTapped(_ sender: UIButton) {
        defaults.set(true, forKey: isOnBoradingScreenDisplayed)
        defaults.synchronize()
        
        let vc = AppFunctions.mainStoryBoard().instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        vc.isFromOnBoardingScreen = false
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK:- UICOLLECTIONVIEW DATASOURCE & DELEGATE METHOD -

extension OnboardingVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.boardingImage.count
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! BoardingCell
        
        cell.imgBackground.image = self.boardingImage[indexPath.row]
        cell.lblTitle.text = self.arrTitle[indexPath.row]
        cell.lblDescription.text = self.arrSubTitle[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
}

//MARK:- UISCROLLVIEW DELEGATE -

extension OnboardingVC: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let visibleRect = CGRect(origin: self.collectionView.contentOffset, size: self.collectionView.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        if let visibleIndexPath = self.collectionView.indexPathForItem(at: visiblePoint) {
            if visibleIndexPath.row == self.boardingImage.count - 1 {
                self.btnSkip.isHidden = true
            } else {
                self.btnSkip.isHidden = false
            }
            self.pageControl.currentPage = visibleIndexPath.row
        }
    }
}

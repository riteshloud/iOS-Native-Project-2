//
//  BossExpenseReportTableCell.swift
//  Demo 2
//
//  Created by Demo MACBook Pro on 12/06/20.
//  Copyright © 2022 Demo Team. All rights reserved.
//

import UIKit

class BossExpenseReportTableCell: UITableViewCell {

    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var collectionView: SelfSizedCollectionView!
    
    var arrayResult: [ExpenseDetailListObject] = []
    
    func loadCollectionView(array: [ExpenseDetailListObject]) {
        self.arrayResult = array
        self.collectionView.reloadData()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.viewContainer.layer.borderColor = UIColor.lightGray.cgColor
        self.viewContainer.layer.borderWidth = 0.3
        
        self.viewContainer.layer.masksToBounds = false
        self.viewContainer.layer.shadowRadius = 1
        self.viewContainer.layer.shadowOpacity = 0.6
        self.viewContainer.layer.shadowColor = UIColor.lightGray.cgColor
        self.viewContainer.layer.shadowOffset = CGSize(width: 0, height: 2)
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

// MARK:- UICOLLECTIONVIEW DATASOURSE & DELEGATES METHOD -

extension BossExpenseReportTableCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayResult.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BossExpenseReportCollectionCell", for: indexPath as IndexPath) as! BossExpenseReportCollectionCell
        
        var currency = ""
        if appDelegate.objCompanySettings != nil {
            currency = appDelegate.objCompanySettings.currency
        } else {
            currency = appDelegate.objLoggedInUser.objCompanyInfo.currency
        }
        
        let objDetail = arrayResult[indexPath.row]
        let amount = "\(objDetail.amount)"
        
        if amount == "" {
            cell.lblTitle.text = objDetail.category + " " + currency + "0"
        } else {
            cell.lblTitle.text = objDetail.category + " " + currency + amount
        }
        
        cell.viewContent.layer.borderColor = UIColor.init(HexCode: 0x3934d4).cgColor
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
                
        let noOfCellsInRow = 2
        
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        
        let totalSpace = flowLayout.sectionInset.left
            + flowLayout.sectionInset.right
            + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))
        
        let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))
        
        return CGSize(width: size, height: 37)
        
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BossExpenseReportCollectionCell", for: indexPath as IndexPath) as! BossExpenseReportCollectionCell
//
//        let font = UIFont(name: Fonts.NunitoBold, size: cell.lblTitle.font.pointSize)!
//        var width: CGFloat = 0
//        let item = self.arrayResult[indexPath.item]
//
//        width = NSString(string: item).size(withAttributes: [NSAttributedString.Key.font : font]).width
//
//        return CGSize(width: width + 20, height: 37)
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }
}

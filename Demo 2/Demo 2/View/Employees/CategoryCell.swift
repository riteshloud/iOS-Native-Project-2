//
//  CategoryCell.swift
//  Demo 2
//
//  Created by Demo MACBook Pro on 15/05/20.
//  Copyright © 2022 Demo Team. All rights reserved.
//

import UIKit

class CategoryCell: UITableViewCell {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var btnCheck: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setUpMultiSelectCategoryData(_ dicData : Dictionary<String,AnyObject>, ids : [Int]) {
        if let categoryName = dicData["category_name"] as? String {
            self.lblName.text = categoryName
        }
        
        if let catIds = dicData["cat_id"] as? Int {
            if ids.contains(catIds) {
                self.btnCheck.setImage(UIImage(named: "ic_selected"), for: .normal)
            } else {
                self.btnCheck.setImage(UIImage(named: "ic_deselected"), for: .normal)
            }
        } else {
            self.btnCheck.setImage(UIImage(named: "ic_deselected"), for: .normal)
        }
    }
    
    func setUpSingleSelectCategoryData(_ dicData : Dictionary<String,AnyObject>, ids : [Int]) {
        if let categoryName = dicData["category_name"] as? String {
            self.lblName.text = categoryName
        }
        
        if let catIds = dicData["cat_id"] as? Int {
            if ids.contains(catIds) {
                self.btnCheck.setImage(UIImage(named: "ic_radioselected"), for: .normal)
            } else {
                self.btnCheck.setImage(UIImage(named: "ic_radiodeselected"), for: .normal)
            }
        } else {
            self.btnCheck.setImage(UIImage(named: "ic_radiodeselected"), for: .normal)
        }
    }
}

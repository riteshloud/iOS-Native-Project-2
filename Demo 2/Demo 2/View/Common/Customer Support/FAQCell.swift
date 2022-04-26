//
//  FAQCell.swift
//  Demo 2
//
//  Created by Demo MACBook Pro on 13/04/20.
//  Copyright © 2022 Demo Team. All rights reserved.
//

import UIKit

class FAQCell: UITableViewCell {

    @IBOutlet var lblQuestion: UILabel!
    @IBOutlet var lblAnswer: UILabel!
    @IBOutlet var viewContainer: UIView!
    @IBOutlet var icArrow: UIImageView!
    @IBOutlet var vwQue: UIView!
    @IBOutlet var vwSepratorLine: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.icArrow.tintColor = UIColor.init(HexCode: 0x858585)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }
}

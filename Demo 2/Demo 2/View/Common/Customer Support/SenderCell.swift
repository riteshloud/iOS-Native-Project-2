//
//  SenderCell.swift
//  Demo 2
//
//  Created by Demo MACBook Pro on 15/05/20.
//  Copyright © 2022 Demo Team. All rights reserved.
//

import UIKit

class SenderCell: UITableViewCell {

    @IBOutlet weak var vwContent: UIView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblTimeAgo: UILabel!
    @IBOutlet weak var lblMessage: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        DispatchQueue.main.async() {
            self.vwContent.roundCorners([.topLeft, .topRight, .bottomLeft], radius: 12)
        }
    }
}

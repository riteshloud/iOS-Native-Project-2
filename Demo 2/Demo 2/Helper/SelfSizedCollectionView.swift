//
//  SelfSizedCollectionView.swift
//  Demo 2
//
//  Created by Demo MACBook Pro on 15/05/20.
//  Copyright © 2022 Demo Team. All rights reserved.
//

import UIKit

class SelfSizedCollectionView: UICollectionView {

    override func reloadData() {
        super.reloadData()
        self.invalidateIntrinsicContentSize()
    }

    override var intrinsicContentSize: CGSize {
        let s = self.collectionViewLayout.collectionViewContentSize
        return CGSize(width: max(s.width, 1), height: max(s.height,1))
    }

}

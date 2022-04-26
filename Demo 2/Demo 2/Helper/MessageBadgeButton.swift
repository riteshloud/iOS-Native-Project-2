//
//  MessageBadgeButton.swift
//  vextrader
//
//  Created by Demo MACBook Pro on 15/05/20.
//  Copyright © 2022 Demo Team. All rights reserved.
//

import UIKit

class MessageBadgeButton: UIControl {
    
    var inset: CGFloat = 10
    var badgeInset: CGFloat = 6

    private lazy var tapGesture: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        gesture.numberOfTouchesRequired = 1
        gesture.numberOfTapsRequired = 1
        return gesture
    }()
    
    private var imageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private var badgeView: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Colors.badgeBGColor
        return view
    }()
    
    private var badgeLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont.init(name: Fonts.NunitoBold, size: 12)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        self.isUserInteractionEnabled = true
        self.addSubview(imageView)
        imageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: inset).isActive = true
        imageView.topAnchor.constraint(equalTo: self.topAnchor, constant: inset).isActive = true
        imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -inset).isActive = true
        imageView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -inset).isActive = true
        
        self.addSubview(badgeView)
        badgeView.leftAnchor.constraint(greaterThanOrEqualTo: self.leftAnchor, constant: 2).isActive = true
        badgeView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        badgeView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        badgeView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        badgeView.addSubview(badgeLabel)
        badgeLabel.leftAnchor.constraint(equalTo: badgeView.leftAnchor, constant: badgeInset).isActive = true
        badgeLabel.topAnchor.constraint(equalTo: badgeView.topAnchor).isActive = true
        badgeLabel.centerXAnchor.constraint(equalTo: badgeView.centerXAnchor).isActive = true
        badgeLabel.centerYAnchor.constraint(equalTo: badgeView.centerYAnchor).isActive = true
        
        self.addGestureRecognizer(self.tapGesture)
//        setImage()
    }
    
    @objc private func tapAction() {
        self.sendActions(for: .touchUpInside)
    }
    
    func setImage(_ image: UIImage? = #imageLiteral(resourceName: "ic_filter_baritem")) {
        self.imageView.image = image
    }
    
    func changeBackgroundColor(_ color: UIColor) {
        self.badgeView.backgroundColor = color
    }
    
    func changeBadgeTextColor(_ color: UIColor) {
        self.badgeLabel.textColor = color
    }
    
    func updateBadge(_ count: Int) {
        self.badgeLabel.text = "\(count)"
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.badgeView.layer.cornerRadius = self.badgeView.frame.height/2
        self.badgeView.layer.masksToBounds = true
    }
    
}

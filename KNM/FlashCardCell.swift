//
//  FlashCardCell.swift
//  KNM
//
//  Created by Mohammad Namvar on 05/02/2019.
//  Copyright © 2019 Mohammad Namvar. All rights reserved.
//

import UIKit

class FlashCardCell: BaseCell {
    
    let cardView: UIView = {
       let card = UIView()
//        card.backgroundColor = .yellow
        card.layer.cornerRadius = 20.0
        card.layer.shadowColor = UIColor.black.cgColor
        card.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        card.layer.shadowRadius = 12.0
        card.layer.shadowOpacity = 0.7
        return card
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.textAlignment = .center        
        label.isUserInteractionEnabled = true
        label.font = UIFont(name: "Arial", size: 20)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()

    
    override func setupViews() {
        addSubview(cardView)
        
        cardView.addSubview(titleLabel)
        cardView.addConstraintsWithFormat(format: "H:|-8-[v0]-8-|", views: titleLabel)
        cardView.addConstraintsWithFormat(format: "V:|-8-[v0]-8-|", views: titleLabel)
        
        cardView.anchor(
            topAnchor,
            left: leftAnchor,
            bottom: bottomAnchor,
            right: rightAnchor,
            topConstant: 0,
            leftConstant: 0,
            bottomConstant: 0,
            rightConstant: 0,
            widthConstant: 0,
            heightConstant: 0)
    }

}

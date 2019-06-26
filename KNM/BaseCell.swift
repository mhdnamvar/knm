//
//  BaseCell.swift
//  KNM
//
//  Created by Mohammad Namvar on 05/02/2019.
//  Copyright © 2019 Mohammad Namvar. All rights reserved.
//

import UIKit

class BaseCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {}
}

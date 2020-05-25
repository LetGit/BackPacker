//
//  ContentFooterViewCell.swift
//  backpacker
//
//  Created by 이연재 on 2020/05/24.
//  Copyright © 2020 이연재. All rights reserved.
//

import UIKit

class ContentFooterViewCell: UICollectionViewCell {
    
    @IBOutlet weak var genresLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        self.layer.cornerRadius = 3.0
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.init(rgb: 0xE1E1E1).cgColor
    }
}

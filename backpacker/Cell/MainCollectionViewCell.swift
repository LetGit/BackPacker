//
//  MainCollectionViewCell.swift
//  backpacker
//
//  Created by 이연재 on 2020/05/23.
//  Copyright © 2020 이연재. All rights reserved.
//

import UIKit

class MainCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var artworkUrl512ImageView: UIImageView!
    @IBOutlet weak var trackCensoredNameLabel: UILabel!
    @IBOutlet weak var sellerNameLabel: UILabel!
    @IBOutlet weak var genresLabel: UILabel!
    @IBOutlet weak var formattedPriceLabel: UILabel!
    @IBOutlet weak var floatRatingView: FloatRatingView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.masksToBounds = true
        self.layer.borderColor = UIColor.init(rgb: 0xE1E1E1).cgColor
        self.layer.borderWidth = 1.0
        
        setFloatRatingView()
    }

    func setFloatRatingView() {
        
        floatRatingView.backgroundColor = UIColor.clear
        floatRatingView.contentMode = .scaleAspectFit
        floatRatingView.type = .floatRatings
    }
}

//
//  ContentFooterView.swift
//  backpacker
//
//  Created by 이연재 on 2020/05/24.
//  Copyright © 2020 이연재. All rights reserved.
//

import UIKit

class ContentFooterView: UIView {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var genres = [String]()
    
    class func instanceFromNib() -> ContentFooterView {
           let view = UINib(nibName: "ContentFooterView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! ContentFooterView
           view.setupView()
           return view
    }
    
    func setupView() {
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(UINib(nibName: "ContentFooterViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
    }
}

extension ContentFooterView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return genres.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ContentFooterViewCell
        cell.genresLabel.text = genres[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let text = genres[indexPath.row]
        let cellWidth = text.size(withAttributes:[.font: UIFont.systemFont(ofSize:12.0)]).width + 30.0
        return CGSize(width: cellWidth, height: 50.0)
    }
}

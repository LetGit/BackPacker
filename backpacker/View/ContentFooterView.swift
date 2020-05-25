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

//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        self.commonInit()
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        self.commonInit()
//    }
//
//    func commonInit(){
//        let view = Bundle.main.loadNibNamed("ContentFooterView", owner: self, options: nil)?.first as! UIView
//        view.frame = self.bounds
//        self.addSubview(view)
//    }
    
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
    
//    func updateCellLayout(handler: @escaping ((CGFloat) -> Void)) {
//
//        collectionView.delegate = self
//        collectionView.dataSource = self
//
//        collectionView.register(UINib(nibName: "ContentFooterViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
//
//        collectionView.performBatchUpdates({
//
//        }) { (finish) in
//
//            handler(self.collectionView.contentSize.height + 122.0)
//        }
//    }
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
        let cellWidth = text.size(withAttributes:[.font: UIFont.systemFont(ofSize:12.0)]).width + 10.0
        return CGSize(width: cellWidth, height: 50.0)
    }
}

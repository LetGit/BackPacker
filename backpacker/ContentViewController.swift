//
//  ContentViewController.swift
//  backpacker
//
//  Created by 이연재 on 2020/05/23.
//  Copyright © 2020 이연재. All rights reserved.
//

import UIKit
import CachyKit

class ContentViewController: UIViewController {
    
    var results: NSDictionary!
    let cachy = CachyLoader()
    
    @IBOutlet weak var screenshotScrollView: UIScrollView!
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var sellerNameLabel: UILabel!
    @IBOutlet weak var formattedPriceLabel: UILabel!
    @IBOutlet weak var buttonBackView: UIView!
    @IBOutlet weak var fileSizeBytesLabel: UILabel!
    @IBOutlet weak var trackContentRatingLabel: UILabel!
    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var releaseNotesLabel: UILabel!
    @IBOutlet weak var appInfoBackView: UIStackView!
    @IBOutlet weak var downIcon: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        buttonBackView.layer.cornerRadius = 5.0
        buttonBackView.layer.masksToBounds = true
        buttonBackView.layer.borderColor = UIColor.init(rgb: 0xE1E1E1).cgColor
        buttonBackView.layer.borderWidth = 1.0
        
        self.updateResults()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        self.setLineView()
        self.setFooterView()
    }
    
    //MARK:
    
    func updateResults() {
        
        let spacing: CGFloat = 10.0
        
        let screenshotUrls = results["screenshotUrls"] as! Array<String>
        
        for (index, url) in screenshotUrls.enumerated() {
            
            let url = URL(string: url)
            let data = try? Data(contentsOf: url!)
            let imageView = self.resizeImage(image: UIImage(data: data!)!)
            imageView.contentMode = .scaleAspectFit
            
            imageView.frame.origin = CGPoint(x: (imageView.frame.width + spacing) * CGFloat(index), y: 0)
            
            screenshotScrollView.contentSize.width = (imageView.frame.width + spacing) * CGFloat(1 + index)
            screenshotScrollView.addSubview(imageView)
        }
        
        trackNameLabel.text = results["trackName"] as? String
        sellerNameLabel.text = results["sellerName"] as? String
        formattedPriceLabel.text = (results["formattedPrice"] as? String).map({
            if $0.contains("￦") {
                return $0.dropFirst() + "원"
            }
            return $0
        })
        let int64: Int64! = Int64(results["fileSizeBytes"] as! String)
        fileSizeBytesLabel.text = ByteCountFormatter.string(fromByteCount: int64, countStyle: .file)
        trackContentRatingLabel.text = results["trackContentRating"] as? String
        versionLabel.text = results["version"] as? String
        descriptionLabel.text = results["description"] as? String

        if let releaseNote = results["releaseNotes"] as? String { // 수정사항이 있을 경우
            releaseNotesLabel.text = releaseNote
            downIcon.isHidden = false
        }
    }
    
    func setLineView() {
        
        for (index, childview) in appInfoBackView.arrangedSubviews.enumerated() {
            
            let border = UIView(frame: CGRect(x: 0, y: 0, width: childview.frame.width, height: 1.0))
            border.backgroundColor = UIColor.init(rgb: 0xE1E1E1)
            childview.addSubview(border)
            
            if index == appInfoBackView.arrangedSubviews.count - 2 { // '새로운 기능' 뷰일 경우 아래에 라인 하나 더 그리기
                
                let border = UIView(frame: CGRect(x: 0, y: childview.frame.height, width: childview.frame.width, height: 1.0))
                border.backgroundColor = UIColor.init(rgb: 0xE1E1E1)
                childview.addSubview(border)
            }
        }
    }
    
    func setFooterView() {
        
        let contentFooterView = ContentFooterView.instanceFromNib()
        
        contentFooterView.genres = (results["genres"] as! [String]).map { "#" + $0 }
        contentFooterView.translatesAutoresizingMaskIntoConstraints = false
        
        contentFooterView.collectionView.performBatchUpdates({

        }) { (finish) in
            
            let _height = contentFooterView.collectionView.contentSize.height
            let _origin = contentFooterView.collectionView.frame.origin.y
            let _bottom: CGFloat = 15.0
            
            self.mainScrollView.addSubview(contentFooterView)

            self.mainScrollView.contentSize.height += (contentFooterView.frame.height)
            
            contentFooterView.heightAnchor.constraint(equalToConstant: _height + _origin + _bottom).isActive = true
            contentFooterView.widthAnchor.constraint(equalToConstant: self.mainScrollView.frame.width).isActive = true
            
            contentFooterView.topAnchor.constraint(equalTo: self.descriptionLabel.bottomAnchor, constant: 50.0).isActive = true
            contentFooterView.leadingAnchor.constraint(equalTo: self.mainScrollView.leadingAnchor).isActive = true
            contentFooterView.trailingAnchor.constraint(equalTo: self.mainScrollView.trailingAnchor).isActive = true
            contentFooterView.bottomAnchor.constraint(equalTo: self.mainScrollView.bottomAnchor).isActive = true
        }
    }
    
    func resizeImage(image: UIImage)  -> UIImageView {
        
        let scale = screenshotScrollView.frame.height / image.size.height
        
        let transform = CGAffineTransform(scaleX: scale, y: scale)
        let size = image.size.applying(transform)
        UIGraphicsBeginImageContext(size)
        image.draw(in: CGRect(origin: .zero, size: size))
        let resultImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        if (resultImage != nil) { return UIImageView(image: resultImage!) }
        
        return UIImageView()
    }

    //MARK: IBAction
    
    @IBAction func onReleaseNotes(_ sender: UIButton) {
        
        guard results["releaseNotes"] != nil else { // 수정사항이 없을 경우 버튼 기능 X
            return
        }
        
        let releaseView = appInfoBackView.arrangedSubviews.last!
        
        releaseView.isHidden = !releaseView.isHidden
        
        let angle = (releaseView.isHidden) ? 0 : CGFloat(Double.pi)
        downIcon.transform = CGAffineTransform(rotationAngle: angle)
    }
    
    @IBAction func onOpenUrl(_ sender: UIButton) {
        
        let trackViewUrl = results["trackViewUrl"] as! String
        
        if let url = URL(string: trackViewUrl) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    @IBAction func onShare(_ sender: UIButton) {
        
        let vc = UIActivityViewController(activityItems: [results["trackViewUrl"] as! String], applicationActivities: nil)
        self.present(vc, animated: true, completion: nil)
    }
}

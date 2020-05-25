//
//  MainViewController.swift
//  backpacker
//
//  Created by 이연재 on 2020/05/23.
//  Copyright © 2020 이연재. All rights reserved.
//

import UIKit
import CachyKit

class MainViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var results: NSArray?
    let cachy = CachyLoader()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let label = UILabel()
        label.textColor = UIColor.black
        label.text = "핸드메이드"
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: label)
        self.navigationController?.navigationBar.backItem?.title = label.text
        
        collectionView.register(UINib(nibName: "MainCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        
        self.searchResultsUpdating()
    }
    
    func searchResultsUpdating() {
        
        let api = "https://itunes.apple.com/search?term=핸드메이드&country=kr&media=software"
        let encoding = api.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let url = URL(string: encoding)!
        cachy.load(url: url) { [weak self] data, _ in
            
            guard let self = self else { return }
            
            do {
                
                let elements = try JSONSerialization.jsonObject(with: data, options: []) as! NSDictionary
                self.results = elements["results"] as? NSArray
                
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
                
            } catch {
                debugPrint("Error occurred")
            }
        }
    }
}

extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return results?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MainCollectionViewCell
        
        let dict = results?[indexPath.row] as! NSDictionary
        let genres = dict["genres"] as? NSArray
        
        let url = URL(string: dict["artworkUrl512"] as! String)
        let data = try? Data(contentsOf: url!)

        cell.artworkUrl512ImageView.image = UIImage(data: data!)
        cell.trackCensoredNameLabel.text = dict["trackCensoredName"] as? String
        cell.sellerNameLabel.text = dict["sellerName"] as? String
        cell.genresLabel.text = genres?.componentsJoined(by: ",")
        cell.formattedPriceLabel.text = dict["formattedPrice"] as? String
        cell.floatRatingView.rating = dict["averageUserRating"] as! Double
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let margin: CGFloat = 10.0
        let size = self.view.frame.width - (margin * 2)
        return CGSize(width: size, height: size + 73.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let uvc : ContentViewController = UIStoryboard(name:"Main", bundle: nil).instantiateViewController(withIdentifier: "ContentViewController") as! ContentViewController
        uvc.results = results?[indexPath.row] as? NSDictionary
        self.navigationController?.pushViewController(uvc, animated: true)
    }
}

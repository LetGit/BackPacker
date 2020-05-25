//
//  ViewController.swift
//  backpacker
//
//  Created by 이연재 on 2020/05/23.
//  Copyright © 2020 이연재. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var results: NSArray?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let label = UILabel()
        label.textColor = UIColor.black
        label.text = "핸드메이드"
        label.font = .boldSystemFont(ofSize: 25.0)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: label)
        
        collectionView.register(UINib(nibName: "MainCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        
        let search = SearchResultsUpdating()
        search.temporaryClosure(url:
        "https://itunes.apple.com/search?", post_data: ["term" : "핸드메이드", "country" : "kr", "media" : "software"]) { (result) in

            self.results = result["results"] as! NSArray
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
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
        let genres = dict["genres"] as! NSArray
        
//        let url = URL(string: dict["artworkUrl512"] as! String)
//        let data = try? Data(contentsOf: url!)
//
//        cell.artworkUrl512ImageView.image = UIImage(data: data!)
        cell.trackCensoredNameLabel.text = dict["trackCensoredName"] as! String
        cell.sellerNameLabel.text = dict["sellerName"] as! String
        cell.genresLabel.text = genres.componentsJoined(by: ",")
        cell.formattedPriceLabel.text = dict["formattedPrice"] as! String
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: self.view.frame.width, height: self.view.frame.width + 73.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

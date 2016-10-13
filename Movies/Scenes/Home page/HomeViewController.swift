//
//  HomeViewController.swift
//  Movies
//
//  Created by Vinay Nair on 11/10/16.
//  Copyright © 2016 vinaynair. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    let data = ["movie 1", "movie 2", "movie 3", "movie 4", "movie 5", "movie 6", "movie 7", "movie 8", "movie 9", "movie 10"]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

// MARK:- UICollectionViewDataSource Delegate

extension HomeViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "movieListCellID", for: indexPath) as! MovieListCell
        
        cell.nameLabel.text = data[indexPath.row]
        cell.posterImage.image = UIImage(named: "image001")
        
        return cell
    }
    
}

//
//  MovieListViewController.swift
//  Movies
//
//  Created by Vinay Nair on 14/10/16.
//  Copyright © 2016 vinaynair. All rights reserved.
//

import UIKit
import WebImage

// MARK: Protocols

protocol MovieListViewControllerProtocol: class {
    func setData(data: [MovieEntity])
}


class MovieListViewController: UIViewController, MovieListViewControllerProtocol {
    
    // MARK: Properties    
    var interactorDelegate: MovieListInteractorProtocol!
    var movieList = [MovieEntity]()
    
    @IBOutlet weak var movieCollectionView: UICollectionView!
    
    // MARK: View Lifecycle
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        let interactor = MovieListInteractor()
        interactor.viewControllerDelegate = self
        self.interactorDelegate = interactor
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.interactorDelegate.makeDiscoverPopularMoviesWebserviceRequest()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: MovieListViewControllerProtocol
    
    func setData(data: [MovieEntity]) {
        self.movieList.append(contentsOf: data)
        self.movieCollectionView.dataSource = self
        self.movieCollectionView.reloadData()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

// MARK:- UICollectionViewDataSource

extension MovieListViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieList.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "movieListCellID", for: indexPath) as! MovieListCell
        
        if let movie = movieList[indexPath.row] as MovieEntity? {
            cell.nameLabel.text = movie.name
            cell.posterImage.image = UIImage(named: "image001")
            if let posterPath = movie.posterPath {
                cell.posterImage.sd_setImage(with: URL(string:WebserviceURL.imageBaseURL + posterPath), placeholderImage: UIImage(named: "image001"))
            }
            

        }
        
        
        
        return cell
    }
    
}

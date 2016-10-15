//
//  MovieListCell.swift
//  Movies
//
//  Created by Vinay Nair on 11/10/16.
//  Copyright © 2016 vinaynair. All rights reserved.
//

import UIKit

class MovieListCell: UICollectionViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var posterImage: UIImageView!
    
    func configureCell(movie: MovieEntity) {
        
        self.nameLabel.text = movie.name
        if let posterPath = movie.posterPath {
            self.posterImage.sd_setImage(with: URL(string:WebserviceURL.imageBaseURL + posterPath), placeholderImage: nil)
        }
        
        self.posterImage.layer.cornerRadius = 3.0
        self.posterImage.layer.masksToBounds = true
        
    }
    
}

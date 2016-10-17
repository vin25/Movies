//
//  DetailViewController.swift
//  Movies
//
//  Created by Vinay Nair on 16/10/16.
//  Copyright © 2016 vinaynair. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var movie: MovieEntity?

    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var movieTitle: UITextView!
    @IBOutlet weak var synopsis: UITextView!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var releaseDate: UILabel!    
    
    @IBOutlet weak var titleToBottomViewDistance: NSLayoutConstraint!
    @IBOutlet weak var titleHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.posterImage.layer.cornerRadius = 1.0
        self.posterImage.layer.masksToBounds = true
        if let posterPath = movie?.posterPath {
            self.posterImage.sd_setImage(with: URL(string:WebserviceURL.imageBaseURL + posterPath), placeholderImage: #imageLiteral(resourceName: "placholder"))
        }
        if let title = movie?.name {
            self.movieTitle.text = title
        }
        if let releaseDate = movie?.releaseDate {
            self.releaseDate.text = releaseDate
        }
        if let rating = movie?.userRating {
            self.rating.text = String(format: "%.1f", rating)
        }
        if let synopsis = movie?.synopsis {
            self.synopsis.text = synopsis
        }
    }

    override func viewDidLayoutSubviews() {
        updateUIConstraints()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateUIConstraints() {
        let height = self.movieTitle.text.heightWithConstrainedWidth(width: self.movieTitle.frame.width, font: self.movieTitle.font!)
        self.titleHeightConstraint.constant = height + 8
        self.synopsis.setContentOffset(CGPoint.zero, animated: false)
        self.movieTitle.setContentOffset(CGPoint.zero, animated: false)
        self.view.layoutIfNeeded()
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

}

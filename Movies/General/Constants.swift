//
//  Constants.swift
//  Movies
//
//  Created by Vinay Nair on 13/10/16.
//  Copyright © 2016 vinaynair. All rights reserved.
//

import Foundation
import UIKit

struct WebserviceURL {
    
    static let baseURL = "https://api.themoviedb.org/3"
    static let discoverPopularMovies = baseURL + "/discover/movie"
    static let imageBaseURL = "https://image.tmdb.org/t/p/w500"
}

struct Authentication {
    
    static let apiKey = "cba7f8f82ec836d8c400bef5fbc101ca"
}

struct Colors {
    static let lightGrayColor = UIColor(red: 236.0/255.0, green: 236.0/255.0, blue: 236.0/255.0, alpha: 1.0)
    static let lightYellowColor = UIColor(red: 248.0/255.0, green: 234.0/255.0, blue: 154.0/255.0, alpha: 1.0)
}


//
//  MovieEntity.swift
//  Movies
//
//  Created by Vinay Nair on 13/10/16.
//  Copyright © 2016 vinaynair. All rights reserved.
//

import Foundation

struct MovieEntity {
    var name: String?
    var synopsis: String?
    var releaseDate: String?
    var userRating: Double?
    var posterPath: String?
    var backdropPath: String?
}

struct DiscoverMoviesResponse {
    var movies: [MovieEntity]?
    var page: Int?
    var totalResults: Int?
    var totalPages: Int?
}

enum SortType {
    case Popularity
    case Rating
}

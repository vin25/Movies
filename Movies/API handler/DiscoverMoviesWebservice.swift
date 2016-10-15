//
//  DiscoverMoviesWebservice.swift
//  Movies
//
//  Created by Vinay Nair on 14/10/16.
//  Copyright © 2016 vinaynair. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol DiscoverMoviesCallback: class {
    func discoverMoviesCallDidSucceed(response: [MovieEntity], sortType: SortType)
    func discoverMoviesCallDidFail(response: HTTPURLResponse?, error:Error, sortType: SortType)
}

class DiscoverMoviesWebservice: BaseWebservice, BaseWebserviceCallback {
    
    weak var discoverMoviescallback: DiscoverMoviesCallback?
    var sortType: SortType = .Popularity
    
    // MARK: Parse
    init(type: SortType) {
        super.init()
        self.sortType = type
    }
    
    func parseResponse(json: JSON) -> [MovieEntity] {
        
        var movieList: [MovieEntity] = []
        
        if let results = json["results"].array {
            
            for i in 0...(results.count-1) {
                
                var movie: MovieEntity = MovieEntity()
                
                if let name = results[i]["title"].string {
                    movie.name = name
                }
                
                if let releaseDate = results[i]["release_date"].string {
                    movie.releaseDate = releaseDate
                }
                
                if let synopsis = results[i]["overview"].string {
                    movie.synopsis = synopsis
                }
                
                if let posterPath = results[i]["poster_path"].string {
                    movie.posterPath = posterPath
                }
                
                if let backdropPath = results[i]["backdrop_path"].string {
                    movie.backdropPath = backdropPath
                }
                
                if let userRating = results[i]["vote_average"].double {
                    movie.userRating = userRating
                }
                
                movieList.append(movie)
            }
            
            
        }
        
        return movieList
    }
    
    
    // MARK: Make request
    
    func makeWebserviceRequest(parameters: String) {
        
        var parameterString = parameters
        if self.sortType == .Popularity {
            parameterString = parameterString + "&sort_by=popularity.desc"
        }
        else {
            parameterString = parameterString + "&sort_by=vote_average.desc"
        }
        
        makeGETWebserviceRequest(URL: WebserviceURL.discoverPopularMovies, parameters: parameterString)
        self.callback = self
    }
    
    // MARK: BaseWebserviceCallback methods
    
    func webserviceCallDidSucceed(json: JSON, response: HTTPURLResponse) {
        //prepare object and send to the interactor
        self.discoverMoviescallback?.discoverMoviesCallDidSucceed(response: self.parseResponse(json: json), sortType: self.sortType)
    }
    
    func webserviceCallDidFail(response: HTTPURLResponse?, error:Error) {
        //prepare object and send to the interactor
        self.discoverMoviescallback?.discoverMoviesCallDidFail(response: response, error: error, sortType: self.sortType)
    }
    
}

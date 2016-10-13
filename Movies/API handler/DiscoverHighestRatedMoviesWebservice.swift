//
//  DiscoverHighestRatedMoviesWebservice.swift
//  Movies
//
//  Created by Vinay Nair on 14/10/16.
//  Copyright © 2016 vinaynair. All rights reserved.
//

import Foundation

import SwiftyJSON

protocol DiscoverHighestRatedMoviesCallback: class {
    func discoverHighestRatedMoviesCallDidSucceed(response: [MovieEntity])
    func discoverHighestRatedMoviesCallDidFail(response: HTTPURLResponse?, error:Error)
}

class DiscoverHighestRatedMoviesWebservice: BaseWebservice, BaseWebserviceCallback {
    
    weak var discoverHighestRatedMoviescallback: DiscoverHighestRatedMoviesCallback?
    
    // MARK: Parse
    
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
        
        let parameterString = parameters + "&sort_by=vote_average.desc"
        makeGETWebserviceRequest(URL: WebserviceURL.discoverPopularMovies, parameters: parameterString)
        self.callback = self
    }
    
    // MARK: SwiftBaseWebserviceCallback methods
    
    func webserviceCallDidSucceed(json: JSON, response: HTTPURLResponse) {
        //prepare object and send to the interactor
        self.discoverHighestRatedMoviescallback?.discoverHighestRatedMoviesCallDidSucceed(response: self.parseResponse(json: json))
    }
    
    func webserviceCallDidFail(response: HTTPURLResponse?, error:Error) {
        //prepare object and send to the interactor
        self.discoverHighestRatedMoviescallback?.discoverHighestRatedMoviesCallDidFail(response: response, error: error)
    }
    
}

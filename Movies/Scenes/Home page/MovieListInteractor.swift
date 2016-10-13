//
//  MovieListInteractor.swift
//  Movies
//
//  Created by Vinay Nair on 14/10/16.
//  Copyright © 2016 vinaynair. All rights reserved.
//

import Foundation

protocol MovieListInteractorProtocol {
    func makeDiscoverPopularMoviesWebserviceRequest()
    func makeDiscoverHighestRatedMoviesWebserviceRequest()
}

class MovieListInteractor: MovieListInteractorProtocol, DiscoverMoviesCallback {
    
    // MARK: Variables
    weak var viewControllerDelegate: MovieListViewControllerProtocol!
    
    // MARK: MovieListInteractorProtocol
    
    func makeDiscoverPopularMoviesWebserviceRequest() {
        self.makeDiscoverPopularMoviesWebserviceRequestForPage(page: 1)
    }
    
    func makeDiscoverHighestRatedMoviesWebserviceRequest() {
        self.makeDiscoverHighestRateMoviesWebserviceRequestForPage(page: 1)
    }
    
    // MARK: Webservice call
    
    func makeDiscoverPopularMoviesWebserviceRequestForPage(page: Int) {
        
        let discoverPopularWS: DiscoverMoviesWebservice = DiscoverMoviesWebservice(type: .Popularity)
        discoverPopularWS.discoverMoviescallback = self
        discoverPopularWS.makeWebserviceRequest(parameters: "page=\(page)")
    }
    
    func makeDiscoverHighestRateMoviesWebserviceRequestForPage(page: Int) {
        
        let discoverPopularWS: DiscoverMoviesWebservice = DiscoverMoviesWebservice(type: .Popularity)
        discoverPopularWS.discoverMoviescallback = self
        discoverPopularWS.makeWebserviceRequest(parameters: "page=\(page)")
    }
    
    
    // MARK: DiscoverPopularMoviesCallback
    func discoverMoviesCallDidSucceed(response: [MovieEntity]) {
        print("discoverMoviesCallDidSucceed response: \(response)")
        viewControllerDelegate.setData(data: response)
    }
    
    func discoverMoviesCallDidFail(response: HTTPURLResponse?, error:Error) {
        print("discoverPopularMoviesCallDidFail response: \(response)")
    }

}


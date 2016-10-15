//
//  MovieListInteractor.swift
//  Movies
//
//  Created by Vinay Nair on 14/10/16.
//  Copyright © 2016 vinaynair. All rights reserved.
//

import Foundation
import UIKit

protocol MovieListInteractorProtocol {
    
    //perform operations as per the sort type
    func sortByPopularity()
    func sortByRating()
    
    //get count of the list
    func getMoviesCount() -> Int
    
    //get movie element
    func getMovieElementForIndex(index: Int) -> MovieEntity?
    
    //set content offset
    func setContentOffsetForPopularMovies(point: CGPoint)
    func setContentOffsetForTopRatedMovies(point: CGPoint)
}

class MovieListInteractor: MovieListInteractorProtocol, DiscoverMoviesCallback {
    
    // MARK: Variables
    weak var viewControllerDelegate: MovieListViewControllerProtocol!
    var sortType: SortType = .Popularity
    var popularMoviesList = [MovieEntity]()
    var topRatedMovielsList = [MovieEntity]()
    var popularMoviesContentOffset = CGPoint(x: 0, y:0)
    var topRatedMoviesContentOffset = CGPoint(x: 0, y:0)
    
    // MARK: MovieListInteractorProtocol
    
    func sortByPopularity() {
        sortType = .Popularity
        makeDiscoverPopularMoviesWebserviceRequest()
        
        if popularMoviesList.count == 0 {
            //hide list and show loading
            viewControllerDelegate.hideMoviesList()
            viewControllerDelegate.startLoader()
        }
    }
    
    func sortByRating() {
        sortType = .Rating
        makeDiscoverHighestRatedMoviesWebserviceRequest()
        
        if topRatedMovielsList.count == 0 {
            //hide list and show loading
            viewControllerDelegate.hideMoviesList()
            viewControllerDelegate.startLoader()
        }
    }
    
    func getMoviesCount() -> Int {
        if sortType == .Popularity {
            return popularMoviesList.count
        }
        else {
            return topRatedMovielsList.count
        }
    }
    
    func getMovieElementForIndex(index: Int) -> MovieEntity? {
        
        if sortType == .Popularity {
            if let movie = popularMoviesList[index] as MovieEntity? {
                return movie
            }
        }
        else {
            if let movie = topRatedMovielsList[index] as MovieEntity? {
                return movie
            }
        }
        
        return nil
        
    }
    
    func setContentOffsetForPopularMovies(point: CGPoint) {
        popularMoviesContentOffset = CGPoint (x: point.x, y: point.y)
    }
    
    func setContentOffsetForTopRatedMovies(point: CGPoint) {
        topRatedMoviesContentOffset = CGPoint (x: point.x, y: point.y)
    }
    
    
    // MARK: Webservice request
    
    func makeDiscoverPopularMoviesWebserviceRequest() {
        self.makeDiscoverPopularMoviesWebserviceRequestForPage(page: 1)
    }
    
    func makeDiscoverHighestRatedMoviesWebserviceRequest() {
        self.makeDiscoverHighestRateMoviesWebserviceRequestForPage(page: 1)
    }
    
    func makeDiscoverPopularMoviesWebserviceRequestForPage(page: Int) {
        
        let discoverPopularWS: DiscoverMoviesWebservice = DiscoverMoviesWebservice(type: .Popularity)
        discoverPopularWS.discoverMoviescallback = self
        discoverPopularWS.makeWebserviceRequest(parameters: "page=\(page)")
    }
    
    func makeDiscoverHighestRateMoviesWebserviceRequestForPage(page: Int) {
        
        let discoverTopRatedWS: DiscoverMoviesWebservice = DiscoverMoviesWebservice(type: .Rating)
        discoverTopRatedWS.discoverMoviescallback = self
        discoverTopRatedWS.makeWebserviceRequest(parameters: "page=\(page)")
    }
    
    
    // MARK: DiscoverMoviesCallback
    
    func discoverMoviesCallDidSucceed(response: [MovieEntity], sortType: SortType) {
        print("discoverMoviesCallDidSucceed response: \(response)")
        
        if sortType == .Popularity {
            if popularMoviesList.count == 0 {
                //show list and stop loading
                viewControllerDelegate.showMoviesList()
                viewControllerDelegate.stopLoader()
            }
            self.popularMoviesList.append(contentsOf: response)
            viewControllerDelegate.reloadListWithContentOffset(point: popularMoviesContentOffset)
        }
        else {
            if topRatedMovielsList.count == 0 {
                //show list and stop loading
                viewControllerDelegate.showMoviesList()
                viewControllerDelegate.stopLoader()
            }
            self.topRatedMovielsList.append(contentsOf: response)
            viewControllerDelegate.reloadListWithContentOffset(point: topRatedMoviesContentOffset)
        }
        
        
    }
    
    func discoverMoviesCallDidFail(response: HTTPURLResponse?, error:Error, sortType: SortType) {
        print("discoverPopularMoviesCallDidFail response: \(response)")
        
        //stop loader
        if sortType == .Popularity {
            if popularMoviesList.count == 0 {
                //show list and stop loading
                viewControllerDelegate.stopLoader()
            }
        }
        else {
            if topRatedMovielsList.count == 0 {
                //show list and stop loading
                viewControllerDelegate.stopLoader()
            }
        }
        
    }

}


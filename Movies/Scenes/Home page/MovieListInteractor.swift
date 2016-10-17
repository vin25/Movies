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
    
    func loadNextPage()
    
    //get count of the list
    func getMoviesCount() -> Int
    
    //get movie element
    func getMovieElementForIndex(index: Int) -> MovieEntity?
    
    //set content offset
    func setContentOffsetForPopularMovies(point: CGPoint)
    func setContentOffsetForTopRatedMovies(point: CGPoint)
    
    //search
    func filterSearchResultsForText(searchText: String)
    func cancelSearch()
}

class MovieListInteractor: MovieListInteractorProtocol, DiscoverMoviesCallback {
    
    // MARK: Variables
    weak var viewControllerDelegate: MovieListViewControllerProtocol!
    var sortType: SortType = .Popularity
    var popularMoviesList = [MovieEntity]()
    var topRatedMovielsList = [MovieEntity]()
    var searchList = [MovieEntity]()
    var popularMoviesContentOffset = CGPoint(x: 0, y:0)
    var topRatedMoviesContentOffset = CGPoint(x: 0, y:0)
    
    // State tracking
    var currentPageForPopularMovies = 0
    var currentPageForTopRatedMovies = 0
    var isLoading = false
    var isRequestingNextPage = false
    var lastLoadedIndexForPopularMovies = 0
    var lastLoadedIndexForTopRatedMovies = 0
    var maxPagesForPopularMovies = 1
    var maxPagesForTopRatedMovies = 1
    var isSearchActive = false
    
    // MARK: MovieListInteractorProtocol
    
    func cancelSearch() {
        isSearchActive = false
        searchList.removeAll()
        viewControllerDelegate.reloadList()
    }
    
    func filterSearchResultsForText(searchText: String) {
        
        if searchText.characters.count <= 0 {
            isSearchActive = false
            viewControllerDelegate.reloadList()
            return
        }
        
        isSearchActive = true
        
        if sortType == .Popularity {
            filterList(list: popularMoviesList, searchText: searchText)
        }
        else {
            filterList(list: topRatedMovielsList, searchText: searchText)
        }
        
        viewControllerDelegate.reloadList()
    }
    
    func filterList(list: [MovieEntity], searchText: String) {
        searchList = list.filter{movie in
            if let found = movie.name?.lowercased().contains(searchText.lowercased()) {
                return found
            }
            return false
        }
    }
    
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
    
    func loadNextPage() {
        if isLoading {
            //print("isLoading")
            return
        }
        
        if isSearchActive {
            return
        }
        
        isRequestingNextPage = true
        
        if sortType == .Popularity {
            makeDiscoverPopularMoviesWebserviceRequest()
        }
        else {
            makeDiscoverHighestRatedMoviesWebserviceRequest()
        }
    }
    
    func getMoviesCount() -> Int {
        
        if isSearchActive {
            return searchList.count
        }
        else {
            if sortType == .Popularity {
                return popularMoviesList.count
            }
            else {
                return topRatedMovielsList.count
            }
        } 
    }
    
    func getMovieElementForIndex(index: Int) -> MovieEntity? {
        
        if isSearchActive {
            if let movie = searchList[index] as MovieEntity? {
                return movie
            }
        }
        else{
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
        }
        
        return nil
    }
    
    func setContentOffsetForPopularMovies(point: CGPoint) {
        if !isSearchActive {
            popularMoviesContentOffset = CGPoint (x: point.x, y: point.y)
        }
    }
    
    func setContentOffsetForTopRatedMovies(point: CGPoint) {
        if !isSearchActive {
            topRatedMoviesContentOffset = CGPoint (x: point.x, y: point.y)
        }
    }
    
    
    // MARK: Webservice request
    
    func makeDiscoverPopularMoviesWebserviceRequest() {
        let pageToRequest = currentPageForPopularMovies+1
        if pageToRequest <= maxPagesForPopularMovies {
            self.makeDiscoverPopularMoviesWebserviceRequestForPage(page: pageToRequest)
        }
        else {
            print("Maximum page limit reached")
        }
    }
    
    func makeDiscoverHighestRatedMoviesWebserviceRequest() {
        let pageToRequest = currentPageForTopRatedMovies+1
        if pageToRequest <= maxPagesForTopRatedMovies {
            self.makeDiscoverHighestRateMoviesWebserviceRequestForPage(page: pageToRequest)
        }
        else {
            print("Maximum page limit reached")
        }
        
    }
    
    func makeDiscoverPopularMoviesWebserviceRequestForPage(page: Int) {
        isLoading = true
        let discoverPopularWS: DiscoverMoviesWebservice = DiscoverMoviesWebservice(type: .Popularity)
        discoverPopularWS.discoverMoviescallback = self
        discoverPopularWS.makeWebserviceRequest(parameters: "page=\(page)")
    }
    
    func makeDiscoverHighestRateMoviesWebserviceRequestForPage(page: Int) {
        isLoading = true
        let discoverTopRatedWS: DiscoverMoviesWebservice = DiscoverMoviesWebservice(type: .Rating)
        discoverTopRatedWS.discoverMoviescallback = self
        discoverTopRatedWS.makeWebserviceRequest(parameters: "page=\(page)")
    }
    
    
    // MARK: DiscoverMoviesCallback
    
    func prepareListOfIndexes(from: Int, to: Int) -> [IndexPath] {
        var indexPathsArray = [IndexPath]()
        for index in from...to{
            let indexPath = IndexPath(row: index, section: 0)
            indexPathsArray.append(indexPath)
        }
        return indexPathsArray
    }
    
    func discoverMoviesCallDidSucceed(response: DiscoverMoviesResponse, sortType: SortType) {
        
        let movies: [MovieEntity] = response.movies!
        isLoading = false
        
        if sortType == .Popularity {
            if popularMoviesList.count == 0 {
                //show list and stop loading
                viewControllerDelegate.showMoviesList()
                viewControllerDelegate.stopLoader()
            }
            self.popularMoviesList.append(contentsOf: movies)
            self.currentPageForPopularMovies = response.page!
            if isRequestingNextPage {
                viewControllerDelegate.updateListForIndexes(indexes: prepareListOfIndexes(from: lastLoadedIndexForPopularMovies+1, to: self.popularMoviesList.count-1))
            }
            else {
                viewControllerDelegate.reloadListWithContentOffset(point: popularMoviesContentOffset)
            }
            lastLoadedIndexForPopularMovies = self.popularMoviesList.count-1
            if let totalPages = response.totalPages {
                maxPagesForPopularMovies = totalPages
            }
        }
        else {
            if topRatedMovielsList.count == 0 {
                //show list and stop loading
                viewControllerDelegate.showMoviesList()
                viewControllerDelegate.stopLoader()
            }
            self.topRatedMovielsList.append(contentsOf: movies)
            self.currentPageForTopRatedMovies = response.page!
            if isRequestingNextPage {
                viewControllerDelegate.updateListForIndexes(indexes: prepareListOfIndexes(from: lastLoadedIndexForTopRatedMovies+1, to: self.topRatedMovielsList.count-1))
            }
            else {
                viewControllerDelegate.reloadListWithContentOffset(point: topRatedMoviesContentOffset)
            }
            lastLoadedIndexForTopRatedMovies = self.topRatedMovielsList.count-1
            if let totalPages = response.totalPages {
                maxPagesForTopRatedMovies = totalPages
            }
        }
        
        isRequestingNextPage = false
        
    }
    
    func discoverMoviesCallDidFail(response: HTTPURLResponse?, error:Error, sortType: SortType) {
        
        isLoading = false
        
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
        
        isRequestingNextPage = false
        
    }

}


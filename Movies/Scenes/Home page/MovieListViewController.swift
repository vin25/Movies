//
//  MovieListViewController.swift
//  Movies
//
//  Created by Vinay Nair on 14/10/16.
//  Copyright © 2016 vinaynair. All rights reserved.
//

import UIKit
import WebImage
import NVActivityIndicatorView

// MARK: Protocols

protocol MovieListViewControllerProtocol: class {
    func reloadListWithContentOffset(point: CGPoint)
    func reloadList()
    func updateListForIndexes(indexes: [IndexPath])
    func startLoader()
    func stopLoader()
    func showMoviesList()
    func hideMoviesList()
}


class MovieListViewController: UIViewController, MovieListViewControllerProtocol {
    
    // MARK: Properties    
    var interactorDelegate: MovieListInteractorProtocol!
    var activityIndicator: NVActivityIndicatorView!
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var movieCollectionView: UICollectionView!
    @IBOutlet weak var popularButton: UIButton!
    @IBOutlet weak var topRatedButton: UIButton!
    @IBOutlet weak var popularSelectedLine: UIView!
    @IBOutlet weak var topRatedLine: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK: View Lifecycle
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        //setup and connect the interactor and view controller
        let interactor = MovieListInteractor()
        interactor.viewControllerDelegate = self
        self.interactorDelegate = interactor
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //hide list view
        self.movieCollectionView.alpha = 0.0
        
        //set popular as selected
        setPopularButtonToSelectedState()

        //show activity indicator
        addActivityIndicatorView()
        activityIndicator.startAnimating()
        
        //fetch data for popular movies
        self.interactorDelegate.sortByPopularity()
        
        //customize search bar
        customizeSearchBar()

        //get keyboard events
        registerForKeyboardNotifications()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Action events
    
    @IBAction func topRatedButtonTapped(_ sender: UIButton) {
        cancelSearch()
        setTopButtonToSelectedState()
        interactorDelegate.sortByRating()
        interactorDelegate.setContentOffsetForPopularMovies(point: self.movieCollectionView.contentOffset)
    }
    
    @IBAction func popularButtonTapped(_ sender: AnyObject) {
        cancelSearch()
        setPopularButtonToSelectedState()
        interactorDelegate.sortByPopularity()
        interactorDelegate.setContentOffsetForTopRatedMovies(point: self.movieCollectionView.contentOffset)
    }
    
    // MARK: UI methods
    
    func customizeSearchBar() {
        self.searchBar.keyboardAppearance = UIKeyboardAppearance.dark
        self.searchBar.returnKeyType = UIReturnKeyType.done
    }
    
    func setTopButtonToSelectedState() {
        topRatedButton.setTitleColor(Colors.lightYellowColor, for: .normal)
        popularButton.setTitleColor(Colors.lightGrayColor, for: .normal)
        popularSelectedLine.alpha = 0.0
        topRatedLine.alpha = 1.0
    }
    
    func setPopularButtonToSelectedState() {
        popularButton.setTitleColor(Colors.lightYellowColor, for: .normal)
        topRatedButton.setTitleColor(Colors.lightGrayColor, for: .normal)
        popularSelectedLine.alpha = 1.0
        topRatedLine.alpha = 0.0
    }
    
    func addActivityIndicatorView() {
        
        //set dimensions and frame for the loader
        let loaderDimension: CGFloat = 40
        let frame: CGRect = CGRect(x: ((self.view.frame.size.width)/2) - (loaderDimension/2),
                                   y: ((self.view.frame.size.height)/2) - (loaderDimension/2),
                                   width: loaderDimension,
                                   height: loaderDimension)

        
        //initialize and start the loader
        activityIndicator = NVActivityIndicatorView(frame: frame, type: NVActivityIndicatorType.lineScale, color: Colors.lightGrayColor, padding: 0)
        self.view.addSubview(activityIndicator)
    }
    
    
    // MARK: MovieListViewControllerProtocol
    
    func reloadListWithContentOffset(point: CGPoint) {
        self.movieCollectionView.reloadData()
        self.movieCollectionView.setContentOffset(point, animated: false)
    }
    
    func reloadList() {
        self.movieCollectionView.reloadData()
        self.movieCollectionView.setContentOffset(CGPoint.zero, animated: false)
    }
    
    func updateListForIndexes(indexes: [IndexPath]) {
        self.movieCollectionView.performBatchUpdates({
            self.movieCollectionView.insertItems(at: indexes)
            }, completion: nil)
    }
    
    func showMoviesList() {
        UIView.animate(withDuration: 0.3) {
            self.movieCollectionView.alpha = 1.0
        }
    }
    
    func hideMoviesList() {
        UIView.animate(withDuration: 0.3) {
            self.movieCollectionView.alpha = 0.0
        }
    }
    
    func startLoader() {
        activityIndicator.startAnimating()
    }
    
    func stopLoader() {
        activityIndicator.stopAnimating()
    }
    
    // MARK: Search related methods
    
    func cancelSearch() {
        self.searchBar.text = nil
        self.searchBar.endEditing(true)
        interactorDelegate.cancelSearch()
    }
    
    // MARK: Keyboard events
    
    func registerForKeyboardNotifications() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: Notification.Name.UIKeyboardWillHide, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: Notification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    func adjustForKeyboard(notification: Notification) {
        let userInfo = notification.userInfo!
        
        let keyboardScreenEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == Notification.Name.UIKeyboardWillHide {
            self.movieCollectionView.contentInset = UIEdgeInsets.zero
        } else {
            self.movieCollectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height, right: 0)
        }
    }

}

// MARK: Search bar delegate

extension MovieListViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        interactorDelegate.filterSearchResultsForText(searchText: searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        cancelSearch()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        cancelSearch()
    }
    
}

// MARK: UICollectionViewDataSource

extension MovieListViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return interactorDelegate.getMoviesCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "movieListCellID", for: indexPath) as! MovieListCell
        
        if let movie = interactorDelegate.getMovieElementForIndex(index: indexPath.row) {
            cell.configureCell(movie: movie)
        }

        return cell
    }

}

extension MovieListViewController: UIScrollViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView == movieCollectionView {
            if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height)
            {
                interactorDelegate.loadNextPage()
            }
        }
    }
}

extension MovieListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "detailViewControllerID") as! DetailViewController
        if let movie = interactorDelegate.getMovieElementForIndex(index: indexPath.row) {
            detailVC.movie = movie
        }
        self.present(detailVC, animated: true, completion: nil)
    }

}

extension MovieListViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (self.view.frame.size.width - (7 * 4)) / 2.0 as CGFloat
        let height = 268.0 as CGFloat
        return CGSize(width: width, height: height)
    }
    
}

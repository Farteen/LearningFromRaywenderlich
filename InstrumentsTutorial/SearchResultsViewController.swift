//
//  SearchResultsViewController.swift
//  InstrumentsTutorial
//
//  Created by James Frost on 28/02/2015.
//  Copyright (c) 2015 Razeware LLC. All rights reserved.
//

import UIKit

class SearchResultsCollectionViewCell : UICollectionViewCell {
  
  @IBOutlet weak var heartButton: UIButton!
  @IBOutlet weak var imageView: UIImageView!
  
  var flickrPhoto: FlickrPhoto! {
    didSet {
      if flickrPhoto.isFavourite {
        heartButton.tintColor = UIColor(red:1, green:0, blue:0.517, alpha:1)
      } else {
        heartButton.tintColor = UIColor.whiteColor()
      }
    }
  }
  
  var heartToggleHandler: ((isFavourite: Bool) -> Void)?

  override func prepareForReuse() {
    imageView.image = nil
  }
  
  @IBAction func heartTapped(sender: AnyObject) {
    flickrPhoto.isFavourite = !flickrPhoto.isFavourite
    
    heartToggleHandler?(isFavourite: flickrPhoto.isFavourite)
  }
}

class SearchResultsViewController: UIViewController {
  
  @IBOutlet weak var collectionView: UICollectionView!
  
  var searchResults: FlickrSearchResults?
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    let resultsCount = searchResults!.searchResults.count
    
    title = "\(searchResults!.searchTerm) (\(resultsCount))"
  }
}

extension SearchResultsViewController : UICollectionViewDataSource {
  
  func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return searchResults!.searchResults.count
  }
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PhotoCell", forIndexPath: indexPath) as! SearchResultsCollectionViewCell
    
    if let flickrPhoto = searchResults?.searchResults[indexPath.item] {
      cell.flickrPhoto = flickrPhoto
      
      cell.heartToggleHandler = { isStarred in
        self.collectionView.reloadItemsAtIndexPaths([ indexPath ])
      }
      
      flickrPhoto.loadThumbnail { image, error in
        if cell.flickrPhoto == flickrPhoto {
          if flickrPhoto.isFavourite {
            cell.imageView.image = image
          } else {
            if let filteredImage = image?.applyTonalFilter() {
              cell.imageView.image = filteredImage
            }
          }
        }
      }
    }
    
    return cell
  }
  
}

extension SearchResultsViewController : UICollectionViewDelegateFlowLayout
{
  func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
    // 3 images across
    let width = view.bounds.width / 3
    
    // each image has a ratio of 4:3
    let height = (width / 4) * 3
    return CGSize(width: width, height: height)
  }
  
  func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
    return 0
  }
}




//  CollectionViewExtension.swift
//  MovieAppProject
//
//  Created by Shorouk Mohamed on 7/21/20.
//  Copyright © 2020 shorouk mohamed. All rights reserved.
//

import UIKit

extension MovieViewController{
func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      return  CGSize(width:collectionView.frame.width/2,height:collectionView.frame.height/2)
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      return results.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as? MovieCell
      indexNumber = indexPath.item
      movie = results[indexNumber!]  as!  [String : AnyObject]
      if let posterPath = movie["poster_path"] as? String {
          cell?.movieImage.sd_setImage(with: URL(string: baseURL + posterPath), placeholderImage: UIImage(named: "harry.jpg"))
      }
      return cell!
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      indexNumber = indexPath.item
      performSegue(withIdentifier: "mySegue", sender: self)
  }
}


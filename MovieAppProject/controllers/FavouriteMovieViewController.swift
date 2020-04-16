//
//  FavouriteMovieViewController.swift
//  MovieAppProject
//
//  Created by shorouk mohamed on 1/9/20.
//  Copyright © 2020 shorouk mohamed. All rights reserved.
//

import UIKit
import CoreData



class FavouriteMovieViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    var baseURL = "http://image.tmdb.org/t/p/w185"
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imgArr.count == 0 ? 1 : imgArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "favCell", for: indexPath) as? FavImgCollectionViewCell
        cell?.image.sd_setImage(with: URL(string: baseURL + imgArr[indexPath.item]), placeholderImage: UIImage(named: "harry.jpg"))
        return cell!
    }
    
    

    @IBOutlet weak var collectionView: UICollectionView!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var imgArr = [String]()
    var fetchedArray = [NSManagedObject]()
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchMovies()
        self.collectionView.reloadData()
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return  CGSize(width:collectionView.frame.width/2,height:collectionView.frame.height/2)
    }
    func fetchMovies()
    {
        imgArr.removeAll()
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "MovieData")
        do{
            fetchedArray = try managedObjectContext.fetch(fetchRequest)
            for i in fetchedArray{
                let imgStr = i.value(forKey: "image") as! String
                imgArr.append(imgStr)
            }
        }catch let error as NSError{
            print(error)
            
        }
    }





}


//
//  MovieViewController.swift
//  MovieAppProject
//
//  Created by shorouk mohamed on 1/3/20.
//  Copyright © 2020 shorouk mohamed. All rights reserved.
//

import UIKit
import SDWebImage
import BTNavigationDropdownMenu
import CoreData
import RevealingSplashView


class MovieViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet weak var movieCollection: UICollectionView!
   
    var indexNumber : Int?
    
    var baseURL = "http://image.tmdb.org/t/p/w185"
    var results = [[String : AnyObject]]()
    var movie = [ String : AnyObject]()
    let menuItems = ["Most Popular "," Top Rated"]
    var fetchedArray = [NSManagedObject]()
    var titleArray = [String]()
    var imageArray = [String]()
    var movieObjectArr = [Movie]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        let revealingSplashView = RevealingSplashView(iconImage: UIImage(named: "logo.jpg")!,iconInitialSize: CGSize(width: 70, height: 70), backgroundColor: UIColor(red: 0.3569, green: 0, blue: 0.4667, alpha: 1.0))
        
        revealingSplashView.animationType = SplashAnimationType.popAndZoomOut
        
        self.view.addSubview(revealingSplashView)
        
        revealingSplashView.startAnimation(){
            print("Completed")
        }
        
        movieCollection.dataSource = self
        movieCollection.delegate = self
     
        if (Reachability.isConnectedToNetwork())
        {
            
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "MovieData")
        do{
            fetchedArray = try managedObjectContext.fetch(fetchRequest)
            for i in fetchedArray{
                let title = i.value(forKey: "title") as! String
                titleArray.append(title)
            
            }
        }catch let error as NSError{
            print(error)
        
        }
       
            
        print(titleArray)
        let menuView = BTNavigationDropdownMenu(navigationController: self.navigationController, containerView: self.navigationController!.view, title: BTTitle.title("Menu"), items: menuItems)
        self.navigationItem.titleView = menuView
        
    
    
        let session = URLSession(configuration: URLSessionConfiguration.default)
        let url = URL(string:"https://api.themoviedb.org/3/movie/popular?api_key=b182ce2c340232cd10f698856b708ccd&language=en-US&page=1")
        let request = URLRequest(url: url!)
        let task = session.dataTask(with: request) { (data, response, error) in
            do
            {
                let moviesData = try JSONSerialization.jsonObject(with: data! , options: .allowFragments) as! [String : AnyObject]
                self.results = moviesData["results"]! as! [[String : AnyObject]]
                
                DispatchQueue.main.async{
                    self.movieCollection.reloadData()
                    print("Done")
                }
            }
                
            catch{
                print(error)
           }
        }
        task.resume()
        
        menuView.didSelectItemAtIndexHandler = {[weak self] (indexPath: Int) -> () in
            print("Did select item at index: \(indexPath)")
            
            if indexPath == 1 {
           let session1 = URLSession(configuration: URLSessionConfiguration.default)
                let url1 = URL(string:"https://api.themoviedb.org/3/movie/top_rated?api_key=b182ce2c340232cd10f698856b708ccd&language=en-US&page=1")
                let request1 = URLRequest(url: url1!)
                let task1 = session.dataTask(with: request1) { (data, response, error) in
                    do
                    {
                        let moviesData1 = try JSONSerialization.jsonObject(with: data! , options: .allowFragments) as! [String : AnyObject]
                        self!.results = moviesData1["results"]! as! [[String : AnyObject]]
                        
                        DispatchQueue.main.async{
                            self!.movieCollection.reloadData()
                          
                        }
                    }
                        
                    catch{
                        print(error)
                    }
                }
                task1.resume()
            }else{
                let session2 = URLSession(configuration: URLSessionConfiguration.default)
                let url2 = URL(string:"https://api.themoviedb.org/3/movie/popular?api_key=b182ce2c340232cd10f698856b708ccd&language=en-US&page=1")
                let request2 = URLRequest(url: url2!)
                let task2 = session.dataTask(with: request2) { (data, response, error) in
                    do
                    {
                        let moviesData2 = try JSONSerialization.jsonObject(with: data! , options: .allowFragments) as! [String : AnyObject]
                        self!.results = moviesData2["results"]! as! [[String : AnyObject]]
                        
                        DispatchQueue.main.async{
                            self!.movieCollection.reloadData()
                        }
                    }
                        
                    catch{
                        print(error)
                    }
                }
                task2.resume()
            }
        }
    
    }
    
   else{
            let alertController = UIAlertController(title: "Internet is disconnected", message:
                "misConnection", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
            
            self.present(alertController, animated: true, completion: nil)
    
    
    
    
    }
    
}

    
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
         if  movie != nil
         {
            print("results")
        }else{
            print("error null")
        }
        if let posterPath = movie["poster_path"] as? String {
            cell?.movieImage.sd_setImage(with: URL(string: baseURL + posterPath), placeholderImage: UIImage(named: "harry.jpg"))

            } else {
              cell?.movieImage.image = nil
            print("error")
            }
        return cell!
        }
    

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        indexNumber = indexPath.item
        performSegue(withIdentifier: "mySegue", sender: self)
    }
    
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is MovieDetailsViewController
        {
            var posterImage : UIImage?
            let vc = segue.destination as? MovieDetailsViewController
            var movieName = results[indexNumber!] as! Dictionary<String,Any>
 
            let posterTitle = movieName["title"]
            let filmOverview = movieName["overview"]
            let filmReleaseDate = movieName["release_date"]
            let filmVoteAverage = movieName["vote_average"]
            let filmID = movieName["id"] 
            let filmImage = movieName["poster_path"] as! String
            let imageUrl = URL(string: baseURL + filmImage)
            if let imageData = try? Data(contentsOf: imageUrl!)
            {
                print(imageData)
                posterImage = UIImage(data: imageData)!
            }

            vc?.movieOverview = filmOverview as! String
            vc?.movieTitle = posterTitle as! String
            vc?.movieReleaseDate = filmReleaseDate as! String
            vc?.movieVoteAverage = filmVoteAverage as! Double
            vc?.movieID = filmID as! Int
            vc?.movieImg = filmImage as! String
            vc?.movieImage = posterImage!
        }
   }
    
    @IBAction func favItem(_ sender: Any) {
       


        }
}
    
    






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
        movieCollection.dataSource = self
        movieCollection.delegate = self
        makeSplashScreen()
        getMovies(kind:"https://api.themoviedb.org/3/movie/popular?api_key=b182ce2c340232cd10f698856b708ccd&language=en-US&page=1")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if (Reachability.isConnectedToNetwork())
        {
            getMoviesMenu()
        }else{
            let alertController = UIAlertController(title: "Internet is disconnected", message:
                "misConnection", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
            self.present(alertController, animated: true, completion: nil)
        }
        
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
    }
    
    func getMovies(kind : String){
        let session = URLSession(configuration: URLSessionConfiguration.default)
        let url = URL(string: kind)
        let request = URLRequest(url: url!)
        let task = session.dataTask(with: request) { [weak self] (data, response, error) in
            do
            {
                let moviesData2 = try JSONSerialization.jsonObject(with: data! , options: .allowFragments) as! [String : AnyObject]
                self?.results = moviesData2["results"]! as! [[String : AnyObject]]
                DispatchQueue.main.async{
                    self?.movieCollection.reloadData()
                }
            }
            catch{
                print(error)
            }
        }
        task.resume()
    }

    func makeSplashScreen(){
        let revealingSplashView = RevealingSplashView(iconImage: UIImage(named: "logo.jpg")!,iconInitialSize: CGSize(width: 70, height: 70), backgroundColor: UIColor(red: 0.3569, green: 0, blue: 0.4667, alpha: 1.0))
        revealingSplashView.animationType = SplashAnimationType.popAndZoomOut
        self.view.addSubview(revealingSplashView)
        revealingSplashView.startAnimation(){}
    }
    
    func getMoviesMenu(){
        let menuView = BTNavigationDropdownMenu(navigationController: self.navigationController, containerView: self.navigationController!.view, title: BTTitle.title("Menu"), items: menuItems)
        self.navigationItem.titleView = menuView
        menuView.didSelectItemAtIndexHandler = {[weak self] (indexPath: Int) -> () in
            if indexPath == 1 {
                self!.getMovies(kind:"https://api.themoviedb.org/3/movie/top_rated?api_key=b182ce2c340232cd10f698856b708ccd&language=en-US&page=1")
            }else{
                self!.getMovies(kind:"https://api.themoviedb.org/3/movie/popular?api_key=b182ce2c340232cd10f698856b708ccd&language=en-US&page=1")
                
            }
        }
    }
}







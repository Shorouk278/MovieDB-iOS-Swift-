//
//  MovieDetailsViewController.swift
//  MovieAppProject
//
//  Created by shorouk mohamed on 1/3/20.
//  Copyright © 2020 shorouk mohamed. All rights reserved.
//

import UIKit
import Cosmos
import CoreData


class MovieDetailsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UICollectionViewDataSource,UICollectionViewDelegate{
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var cosmos: CosmosView!
    @IBOutlet weak var tableView: UITableView!
    var movieTitle:String = ""
    var movieOverview : String = ""
    var movieReleaseDate : String = ""
    var movieVoteAverage : Double = 0
    var movieID = 0
    var movieImg : String = ""
    var movieImage:UIImage = UIImage(named:"harry.jpg")!
    var results = [[String : AnyObject]]()
    var flag = 0
    var trailerNameArr = [String]()
    var trailerLinkArray = [String]()
    var reviewsArray = [URL]()
    var numberOfRows = 0
    var sectionTitle = ""
    var titleArr = [String]()
    var dateArray = [String]()
    var overviewArray = [String]()
    var rateArray = [Double]()
    var imageArr = [String]()
     var reviewArr = [String]()
    var movie = [String : AnyObject]()
    var indexNumber : Int?

    @IBOutlet weak var overviewTextField: UITextView!
    @IBOutlet weak var movieReleaseDateLabel: UILabel!
    @IBOutlet weak var movieImageLabel: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieVoteAverageLabel: UILabel!
    @IBOutlet weak var favBtnImage: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cosmos.settings.fillMode = .precise
        cosmos.rating = movieVoteAverage/2
        print("IMAGE = \(movieImg)")
        let session = URLSession(configuration: URLSessionConfiguration.default)
        let url = URL(string:"https://api.themoviedb.org/3/movie/\(movieID)/videos?api_key=b182ce2c340232cd10f698856b708ccd&language=en-US")
        let request = URLRequest(url: url!)
        let task = session.dataTask(with: request) { (data, response, error) in
            do
            {
                let moviesData = try JSONSerialization.jsonObject(with: data! , options: .allowFragments) as! [String : AnyObject]
                self.results = moviesData["results"]! as! [[String : AnyObject]]
                for result in self.results
                {
                    if (result["type"] as! String == "Trailer")
                    {
                        let key = result["name"] as! String
                        let trailerLink = result["key"] as! String
                        
                        self.trailerNameArr.append(key)
                       self.trailerLinkArray.append(trailerLink)
                    }
                }
                    for k in self.trailerLinkArray{
                              print(k)
                    }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }catch{
                print("error")
            }
            
        }
        task.resume()
        
    tableView.delegate = self
    tableView.dataSource = self
        collectionView.delegate = self
    collectionView.dataSource = self
        
        
        let session2 = URLSession(configuration: URLSessionConfiguration.default)
        let url2 = URL(string:"https://api.themoviedb.org/3/movie/419704/reviews?api_key=b182ce2c340232cd10f698856b708ccd")
        let request2 = URLRequest(url: url2!)
        let task2 = session.dataTask(with: request2) { (data, response, error) in
            do
            {
                let moviesData = try JSONSerialization.jsonObject(with: data! , options: .allowFragments) as! [String : AnyObject]
                self.results = moviesData["results"]! as! [[String : AnyObject]]
                for result in self.results
                {
                
                        let keys = result["content"] as! String
                    
                        self.reviewArr.append(keys)
                    print(self.reviewArr)
                    }
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
            }
                }catch{
                print("error")
            }
            
        }
    
        task2.resume()
        
        
    movieTitleLabel.text = movieTitle
    movieImageLabel.image = movieImage
    overviewTextField.text = movieOverview
    movieReleaseDateLabel.text = movieReleaseDate
     movieVoteAverageLabel.text = String(movieVoteAverage)
   

    }
  
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
  
        sectionTitle = "Trailers"
        return sectionTitle
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        numberOfRows = trailerNameArr.count
        return numberOfRows
    }

func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "VideoCell")
    cell?.textLabel?.text = trailerNameArr[indexPath.row]
    return cell!
}
    
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    print("did selected")
    DispatchQueue.main.async{
    UIApplication.shared.openURL(NSURL(string:"https://www.youtube.com/watch?v=\(self.trailerLinkArray[indexPath.row])")! as URL)
    }
    
    
   
  }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return reviewArr.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? CollectionViewCell
        indexNumber = indexPath.item
        cell?.myTextView.text = reviewArr[indexPath.item]
        return cell!
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.item)
        
    }
    
    @IBAction func favBtn(_ sender: Any) {
        print("clicked")
        favBtnImage.setImage(UIImage(named:"redheart.jpg")?.withRenderingMode(.alwaysOriginal), for: .normal)
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName :"MovieData", in: managedObjectContext )
        let film  = NSManagedObject(entity :entity!, insertInto: managedObjectContext)
        self.titleArr.append(movieTitle)
        self.dateArray.append(movieReleaseDate)
        self.overviewArray.append(movieOverview)
        self.rateArray.append(movieVoteAverage)
        self.imageArr.append(movieImg)
        film.setValue( movieTitle , forKey : "title")
        film.setValue(movieReleaseDate, forKey: "date" )
        film.setValue(movieOverview, forKey: "overview")
        film.setValue(movieVoteAverage, forKey: "rate")
        film.setValue(movieImg, forKey: "image")
    do{
    try managedObjectContext.save()
    }catch let error as NSError {
    print(error)
    }
         }
    
   
}




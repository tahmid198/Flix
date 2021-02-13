//
//  MoviesViewController.swift
//  Flix
//
//  Created by Tahmid Zaman on 2/11/21.
//

import UIKit
import AlamofireImage

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    
    @IBOutlet weak var tableView: UITableView!
    
    var movies = [[String:Any]]() //Any array of dictionaries, () indicates its an creation of something
    
    override func viewDidLoad() { //function that runs the first time a screen pops up
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        //Network Request Snippet
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
           // This will run when the network request returns
           if let error = error {
              print(error.localizedDescription)
           } else if let data = data {
              let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
            
            //Network snippet downloads array of movies and stores it below
            
            self.movies = dataDictionary["results"] as! [[String:Any]] //movie results are stored in movies property
            
            self.tableView.reloadData() //will call functions again
            print(dataDictionary)

              // TODO: Get the array of movies
              // TODO: Store the movies in a property to use elsewhere
              // TODO: Reload your table view data

           }
        }
        task.resume()
        // Do any additional setup after loading the view.
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return movies.count //number of rows to be created; values is pulled from API
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //let cell = UITableViewCell() //creates new cell
        
        let cell = tableView.dequeueReusableCell(withIdentifier:"MovieCell") as! MovieCell //at any given point you will have many rows that will take up alot of mem; if ther are any cells of screen, dequeueReusableCell will ask for reusable cells and if there are not any it will create some. cell is casted as a MovieCell
    
        let movie = movies[indexPath.row] //we access moveis from API and it is stored into movie variable
        
        //variable title has to be cast using as! String to let the variable know what type it needs
        let title = movie["title"] as! String//we access movie title by key from API
        let synopsis = movie["overview"] as! String
        
        cell.titleLabel.text = title //lets us access movie cell to print title
        cell.synopsisLabel.text = synopsis // lets us access movie cell to print synopsis
    
        
        let baseUrl = "https://image.tmdb.org/t/p/w185"
        let posterPath = movie["poster_path"] as! String
        let posterUrl = URL(string: baseUrl + posterPath)
        
        cell.posterView.af_setImage(withURL: posterUrl!)
         
          
        return cell
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


// STEPS TO CREATE TABLEVIEW
//1. Add UITableViewDataSource and UITableViewDelegate in class parameters
//2. Add tableView outlet
//3. Add tableView.dataSource = self and tableView.delegate = self
//4. Add 2 tableView function and movie count and cell creation within
//5. Reaload data

// STEPS TO CREATE CUSTOM CELL
//1. Design cell with titleLable, synopsisLabel, and imageView all within tableViewCell object
//2. Create swift file for cell and palce name in Created class and reuse identifier
//3. go back to conrtoller place dequeueReusableCell method and configure outlets

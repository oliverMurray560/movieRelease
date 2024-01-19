//
//  ViewController.swift
//  movieRelease
//
//  Created by OLIVER MURRAY on 1/18/24.
//


struct Movie: Codable{
    
var Actors: String
var Country: String
var Director: String
var Metascore: String
var Ratings: [Rating]
    
    
}

struct Rating: Codable{
    var Source: String
    var Value: String
    
    
}



import UIKit


class ViewController: UIViewController {
    @IBOutlet weak var yearLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        getMovie()
    }

    
    func getMovie(){
        // creating object of URLSession class to make api call
        let session = URLSession.shared
        
        //creating URL for api call (you need your apikey)
        let movieURL = URL(string: ("http://www.omdbapi.com/?apikey=8ac12c36&t=ghost"))!
        
        // Making an api call and creating data in the completion handler
        let dataTask = session.dataTask(with: movieURL) {
            // completion handler: happens on a different thread, could take time to get data
            (data: Data?, response: URLResponse?, error: Error?) in
            
            if let error = error {
                print("Error:\n\(error)")
            } else {
                // if there is data
                if let data = data {
                    // convert data to json Object
                    if let jsonObj = try? JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                        // print the jsonObj to see structure
                        print(jsonObj)
                        
                        //get Movie object with JSONDecoder
                                                if let movieObj = try? JSONDecoder().decode(Movie.self, from: data){
                                                    print(movieObj.Actors)
                                                    for r in movieObj.Ratings{
                                                        print("Rating \(r.Source): \(r.Value)")
                                                    }
                                                }
                        
                        
                        //get Movie object with JSONDecoder
                        if let movieObj = try? JSONDecoder().decode(Movie.self, from: data){
                            print(movieObj.Actors)
                        }
                        else{
                            print("error decoding to movie object")
                        }

                        
                       //search for year
                        if let year = jsonObj.value(forKey: "Year") as? String {
                            
                           
                                DispatchQueue.main.async {
                                   self.yearLabel.text = year
                               }
                                
                            
                        } else {
                            print("Error: unable to convert json data")
                        }
                    }
                    else {
                        print("Error: Can't convert data to json object")
                    }
                }else {
                    print("Error: did not receive data")
                }
            }
        }
        
        dataTask.resume()
    }

}


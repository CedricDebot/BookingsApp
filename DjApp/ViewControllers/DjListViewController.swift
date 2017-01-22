import UIKit
import Alamofire
import SwiftyJSON
import Foundation

var imageCache = NSCache<AnyObject, AnyObject>()

class DjListViewController: UITableViewController {
    
    var djs: [Dj] = []
    
    private var currentTask: URLSessionTask?
    var parameters: String!
    let service = Service()
    
    let loader = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
    
    override func viewDidLoad() {
        //initLoader()
        //djs = service.getDjs(parameterUrl: parameters)
        //for i in service.getDjs(parameterUrl: parameters) {
        //    djs.append(i)
        //}
            
        //print(djs)
       Alamofire.request("http://192.168.2.33:3000/api/profiles/djs\(parameters!)").responseJSON {
            response in
            print(response.result)
            
            if response.result.isSuccess {
                let resJson = JSON(response.result.value!)
                for (_, subjson) in resJson {
                    let djName = subjson["djName"].string!
                    let region = subjson["region"].string!
                    let price = subjson["price"].double!
                    let biography = subjson["biography"].string!
                    let genres: [String] = subjson["genres"].arrayValue.map{$0.string!}
                    let references: [String] = subjson["references"].arrayValue.map{$0.string!}
                    let image = subjson["image"].string!
                    
                    let dj = Dj.init(djName: djName, region: region, price: price, biography: biography, genres: genres, references: references, image: image)
                    self.djs.append(dj)
                }
                
                self.tableView.reloadData()
            }
        }
    }
    
    func initLoader() {
        loader.color = UIColor.red
        loader.startAnimating()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let profileViewController = segue.destination as! ProfileViewController
        let selectedIndex = tableView.indexPathForSelectedRow!.row
        profileViewController.dj = djs[selectedIndex]
    }
    
    override func didReceiveMemoryWarning() {
        
    }
}

extension DjListViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return djs.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "djsCell", for: indexPath) as! CustomDjCell
        let dj = djs[indexPath.row]
        
     //   cell.profilePic.addSubview(loader)
     //   self.loader.startAnimating()
       
        let url: String = dj.image
        let urlRequest = URL(string: url)
        
        if let image = imageCache.object(forKey: url as AnyObject) as? UIImage {
            cell.profilePic.image = image
        } else {
            URLSession.shared.dataTask(with: urlRequest!, completionHandler: {(data, response, error) in
                if(error != nil) {
                    return
                } else {
                    if (response as? HTTPURLResponse) != nil {
                        if let imageData = data {
                            let image = UIImage(data: imageData)
                            print(image!)
                            cell.profilePic.image = image
                            imageCache.setObject(image!, forKey: imageData as AnyObject)
                            //self.loader.stopAnimating()
                        }
                    }
                    
                }
            }).resume()
       }
        
        cell.djNameLabel!.text = dj.djName
        cell.priceLabel!.text = "€\(dj.price)"
        cell.regionLabel!.text = dj.region
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
}

extension DjListViewController {
}


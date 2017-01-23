import UIKit
import Alamofire
import SwiftyJSON
import Foundation

class DjListViewController: UITableViewController {
    
    @IBOutlet weak var errorView: UIView!
    
    var djs: [Dj] = []

    private var currentTask: URLSessionTask?
    var parameters: String!
        
    let loader = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        errorView.translatesAutoresizingMaskIntoConstraints = false
        tableView.addSubview(errorView)
        tableView.addConstraints([
            errorView.widthAnchor.constraint(equalTo: tableView.widthAnchor),
            errorView.heightAnchor.constraint(equalTo: tableView.heightAnchor)
            ])
        hideErrorview()
        
        let memoryCapacity = 500 * 1024 * 1024
        let diskCapacity = 500 * 1024 * 1024
        let urlCache = URLCache(memoryCapacity: memoryCapacity, diskCapacity: diskCapacity, diskPath: "djImages")
        URLCache.shared = urlCache
        
        doGet()
    }
    
    private func showErrorView() {
        tableView.separatorStyle = .none
        errorView.isHidden = false
        tableView.reloadData()
    }
    
    private func hideErrorview() {
        tableView.separatorStyle = .singleLine
        errorView.isHidden = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let profileViewController = segue.destination as! ProfileViewController
        let selectedIndex = tableView.indexPathForSelectedRow!.row
        profileViewController.dj = djs[selectedIndex]
    }
    
    func doGet() {
        Alamofire.request("http://localhost:3000/api/profiles/djs\(parameters!)").responseJSON {
            response in
            print(response.result)
            
            if response.result.isSuccess {
                let resJson = JSON(response.result.value!)
                
                if resJson.isEmpty {
                    self.showErrorView()
                }
                
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
            
            if response.result.isFailure {
                self.showErrorView()
            }
        }

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
        
        let url: String = dj.image
        let urlRequest = URL(string: url)

            URLSession.shared.dataTask(with: urlRequest!, completionHandler: {(data, response, error) in
                if(error != nil) {
                    return
                } else {
                    if (response as? HTTPURLResponse) != nil {
                        if let imageData = data {
                            let image = UIImage(data: imageData)
                                
                                DispatchQueue.main.async {
                                    cell.profilePic.image = image
                                }
                        }
                    }
                }
            }).resume()
               
        cell.djNameLabel!.text = dj.djName
        cell.priceLabel!.text = "€\(dj.price)/uur"
        cell.regionLabel!.text = dj.region
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
}

extension DjListViewController {
}


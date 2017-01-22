import UIKit
import Alamofire
import SwiftyJSON
import Foundation

class ProfileViewController: UITableViewController {
    
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var biography: UILabel!
    @IBOutlet weak var bookButton: UIBarButtonItem!

    var dj: Dj!
    var profileImage: UIImage!
    var genres : [String] = ["house", "pop"]
    var references: [String] = ["tml", "Summerfes", "Versuz"]
    
    override func viewDidLoad() {
        title = dj.djName
        
        let url: String = dj.image
        print(url)
        let urlRequest = URL(string: url)
        
        URLSession.shared.dataTask(with: urlRequest!, completionHandler: {(data, response, error) in
            if(error != nil) {
                return
            } else {
                if (response as? HTTPURLResponse) != nil {
                    if let imageData = data {
                        let image = UIImage(data: imageData)
                        self.profileImage = image
                        DispatchQueue.main.async {
                            self.profilePic.image = UIImage(data: imageData)
                        }
                        
                    }
                }
            }
        }).resume()

        profilePic.image = profileImage
        biography.text = dj.biography
        bookButton.title = "Boek nu | €\(dj.price)/uur"
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController!.isToolbarHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController!.isToolbarHidden = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let bookingViewController = segue.destination as! BookingViewController
        bookingViewController.dj = dj
    }
}

extension ProfileViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rowCount = 1
        if section == 2 {
            rowCount = dj.genres.count
        }
        if section == 3 {
            rowCount = dj.references.count
        }
        print(rowCount)
        return rowCount
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = Bundle.main.loadNibNamed("TableViewCellProfilePic", owner: self, options: nil)?.first as! TableViewCellProfilePic
           // cell.profilePic.image =
            return cell
        }
        
        if indexPath.section == 1 {
            let cell = Bundle.main.loadNibNamed("TableViewCellBiography", owner: self, options: nil)?.first as! TableViewCellBiography
            cell.biographyText.text = dj.biography
            return cell
        }
        if indexPath.section == 2 {
            let cell = Bundle.main.loadNibNamed("CustomTableViewCell", owner: self, options: nil)?.first as! CustomTableViewCell
            cell.titleLabel!.text = dj.genres[indexPath.row]
            return cell
        } else {
            let cell = Bundle.main.loadNibNamed("CustomTableViewCell", owner: self, options: nil)?.first as! CustomTableViewCell
            cell.titleLabel!.text = dj.references[indexPath.row]
            return cell
        } 
        
    }
    
    
}

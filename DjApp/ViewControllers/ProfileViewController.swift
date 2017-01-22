import UIKit

class ProfileViewController: UITableViewController {
    
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var biography: UILabel!
    @IBOutlet weak var bookButton: UIBarButtonItem!

    var dj: Dj!
    
    override func viewDidLoad() {
        title = dj.djName
        
        let url: String = dj.image
        print(url)
        let urlRequest = URL(string: url)
        if let image = imageCache.object(forKey: url as AnyObject) as? UIImage {
            self.profilePic.image = image
        } else {
            URLSession.shared.dataTask(with: urlRequest!, completionHandler: {(data, response, error) in
                if(error != nil) {
                    return
                } else {
                    if (response as? HTTPURLResponse) != nil {
                        if let imageData = data {
                            print(imageData)
                            let image = UIImage(data: imageData)
                            print(image!)
                            self.profilePic.image = image!
                            imageCache.setObject(image!, forKey: imageData as AnyObject)
                        }
                    }
                    
                }
            }).resume()

        biography.text = dj.biography
        bookButton.title = "Boek nu | 60€"
        }
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
        return (section == 2) ? dj.genres.count : dj.references.count
    }
    
  //  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

  //  }
    
    
}

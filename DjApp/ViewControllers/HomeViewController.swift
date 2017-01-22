import UIKit

class HomeViewController : UIViewController {
    
    @IBOutlet weak var genreTextField: UITextField!
    @IBOutlet weak var regionTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    
    let regions = ["Antwerpen", "Henegouwen", "Limburg", "Luik", "Luxemburg", "Namen", "Oost-Vlaanderen", "Vlaams-Brabant", "Waals-Brabant", "West-Vlaanderen"]
    let genres = ["house"]
    
    override func viewDidLoad() {
        initPickerViewRegion()
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let djListViewController = segue.destination as! DjListViewController
        djListViewController.parameters = buildParametersUrl()
    }
    
    func initPickerViewRegion() {
        let pickerViewRegion = UIPickerView()
        pickerViewRegion.delegate = self
        pickerViewRegion.dataSource = self
        regionTextField.inputView = pickerViewRegion

        let toolbar = UIToolbar()
        toolbar.barStyle = UIBarStyle.default
        //toolbar!.translucent = true
        toolbar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(HomeViewController.donePicker))
        doneButton.tintColor = UIColor(red: 2/255, green: 37/255, blue: 80/255, alpha: 1)
        toolbar.setItems([doneButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        regionTextField.inputAccessoryView = toolbar
    }
    
    func donePicker() {
        regionTextField.resignFirstResponder()
    }
    
    func dismissKeyboard() {
        genreTextField.resignFirstResponder()
        regionTextField.resignFirstResponder()
        priceTextField.resignFirstResponder()
    }
    
    func buildParametersUrl() -> String {
        let genre = genreTextField.text!
        let region = regionTextField.text!
        let price = priceTextField.text!
        
        print(region)
        
        var parametersUrl = ""
        switch true {
        case genre != "" && region != "" && price != "":
            parametersUrl = "?region=\(region)&genre=\(genre)&price=\(price)"
        case genre != "" && region != "":
            parametersUrl = "?region=\(region)&genre=\(genre)"
        case genre != "" && price != "":
            parametersUrl = "?genre=\(genre)&price=\(price)"
        case region != "" && price != "":
            parametersUrl = "?region=\(region)&price=\(price)"
        case genre != "":
            parametersUrl = "?genre=\(genre)"
        case region != "":
            parametersUrl = "?region=\(region)"
        case price != "":
            parametersUrl = "?price=\(price)"
        default:
            parametersUrl = ""
        }
        
        return parametersUrl
    }
    
}

extension HomeViewController: UIPickerViewDataSource {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return regions[row]
        
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return regions.count
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return  1
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        regionTextField.text = regions[row]
    }
}

extension HomeViewController: UIPickerViewDelegate {
    
}

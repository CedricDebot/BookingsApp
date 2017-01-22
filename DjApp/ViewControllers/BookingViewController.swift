import UIKit

class BookingViewController: UITableViewController {
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var telphone: UITextField!
    @IBOutlet weak var eventName: UITextField!
    @IBOutlet weak var eventAddress: UITextField!
    @IBOutlet weak var eventLocation: UITextField!
    @IBOutlet weak var eventDate: UITextField!
    @IBOutlet weak var message: UITextView!
    
    var dj: Dj!
    
    override func viewDidLoad() {
        initPickerDateView()
    }
    
    func initPickerDateView() {
        let pickerDate = UIDatePicker()
        pickerDate.datePickerMode = UIDatePickerMode.dateAndTime
        eventDate.inputView = pickerDate
        
        let toolbar = UIToolbar()
        toolbar.barStyle = UIBarStyle.default
        //toolbar!.translucent = true
        toolbar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(BookingViewController.donePicker))
        doneButton.tintColor = UIColor(red: 2/255, green: 37/255, blue: 80/255, alpha: 1)
        toolbar.setItems([doneButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        eventDate.inputAccessoryView = toolbar
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController!.isToolbarHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController!.isToolbarHidden = true
    }
    
    func donePicker() {
        eventDate.resignFirstResponder()
    }
    
    @IBAction func sendMessage() {
        
    }
}


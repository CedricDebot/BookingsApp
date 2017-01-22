import UIKit
import Alamofire

class BookingViewController: UITableViewController {
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var telphone: UITextField!
    @IBOutlet weak var eventName: UITextField!
    @IBOutlet weak var eventAddress: UITextField!
    @IBOutlet weak var eventLocation: UITextField!
    @IBOutlet weak var eventDate: UITextField!
    @IBOutlet weak var message: UITextView!
    @IBOutlet weak var sendButton: UIBarButtonItem!
    @IBOutlet weak var succesView: UIView!
    
    var dj: Dj!
        
    override func viewDidLoad() {
        initPickerDateView()

        succesView.translatesAutoresizingMaskIntoConstraints = false
        tableView.addSubview(succesView)
        tableView.addConstraints([
            NSLayoutConstraint(item: succesView, attribute: .centerX, relatedBy: .equal, toItem: tableView, attribute: .centerX, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: succesView, attribute: .centerY, relatedBy: .equal, toItem: tableView, attribute: .centerY, multiplier: 1, constant: 0),
            succesView.widthAnchor.constraint(equalTo: tableView.widthAnchor),
            succesView.heightAnchor.constraint(equalTo: tableView.heightAnchor)
            ])
        hideSuccesView()
        //checkRequiredFields()
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
    }
    
    func initPickerDateView() {
        let pickerDate = UIDatePicker()
        pickerDate.datePickerMode = UIDatePickerMode.dateAndTime
        eventDate.inputView = pickerDate
        pickerDate.addTarget(self, action: #selector(dateValuePickerChanged), for: UIControlEvents.valueChanged)
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
    
    
    func donePicker() {
        eventDate.resignFirstResponder()
    }
    
    func dismissKeyboard() {
        name.resignFirstResponder()
        email.resignFirstResponder()
        telphone.resignFirstResponder()
        eventName.resignFirstResponder()
        eventAddress.resignFirstResponder()
        eventLocation.resignFirstResponder()
        eventDate.resignFirstResponder()
        message.resignFirstResponder()
    }
    
    private func showSuccesView() {
        tableView.separatorStyle = .none
        for i in 0...3 {
            tableView.headerView(forSection: i)?.isHidden = true
        }
        succesView.isHidden = false
        tableView.reloadData()
    }
    
    private func hideSuccesView() {
        tableView.separatorStyle = .singleLine
        succesView.isHidden = true
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController!.isToolbarHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController!.isToolbarHidden = true
    }
    
    func dateValuePickerChanged(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.short
        eventDate.text = dateFormatter.string(from: sender.date)
    }
    
    /*func checkRequiredFields() {
        print(name.text ?? "")
        let nameReq = name.text ?? ""
        let emailReq = email.text ?? ""
        let telephoneReq = telphone.text ?? ""
        let eventNameReq = eventName.text ?? ""
        let eventAddressReq = eventAddress.text ?? ""
        let eventLocationReq = eventLocation.text ?? ""
        let eventDateReq = eventDate.text ?? ""
        let required = [nameReq, emailReq, telephoneReq, eventNameReq, eventAddressReq, eventLocationReq, eventDateReq]
        
        if required.contains("") {
            sendButton.isEnabled = false
        } else {
            sendButton.isEnabled = true
        }
    }*/
    
    @IBAction func sendMessage() {
        
        
        //code voor een post naar de backend te doen --> probleem in backend (geschreven in nodejs)
      /*  let parameters: Parameters = [
            "name" : "\(name.text)",
            "email" : "\(email.text)",
            "tel": "\(telphone.text)",
            "eventName": "\(eventName.text)",
            "eventAddress": "\(eventAddress.text)",
            "eventLocation": "\(eventLocation.text)",
            "eventDate" : "\(eventDate.text)",
            "message" : "\(message.text)"
        ]
        
        Alamofire.request("http://192.168.2.33:3000/api/profiles/djs/\(dj.djName)/message", method: .post, parameters: parameters, encoding: JSONEncoding.default)
        */
        showSuccesView()
        
    }
}



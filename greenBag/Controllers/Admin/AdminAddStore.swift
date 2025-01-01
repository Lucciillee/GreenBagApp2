import UIKit
import RealmSwift

class AdminAddStore: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Perform any additional setup after loading the view
    }
    
    // Outlets for store details input fields
    @IBOutlet weak var storeNameTextField: BlackBorderedTextField!// Store name input

    @IBOutlet weak var storeEmailTextField: BlackBorderedTextField!// Store email input
    
    @IBOutlet weak var storePasswordTextField: BlackBorderedTextField! // Store password input
    
    
    @IBOutlet weak var storePhoneNumberTextField: BlackBorderedTextField!// Store phone number input
    
    
    // Action triggered when the add store button is pressed
    @IBAction func addStoreButtonPressed(_ sender: Any) {
        // Validate all fields
        guard let storeName = storeNameTextField.text, !storeName.isEmpty else {
            showAlert(message: "Please enter store name.")
            return
        }
        guard let storeEmail = storeEmailTextField.text, !storeEmail.isEmpty else {
            showAlert(message: "Please enter store email.")
            return
        }
        guard let storePassword = storePasswordTextField.text, !storePassword.isEmpty else {
            showAlert(message: "Please enter store password.")
            return
        }
        guard let storePhoneNumber = storePhoneNumberTextField.text, !storePhoneNumber.isEmpty else {
            showAlert(message: "Please enter store Phone Number.")
            return
        }
        
        //n Swift, guard is used to check for conditions that must be true for the rest of the code to execute.
        
        
        // Show confirmation alert before proceeding
        showConfirmationAlert(
            title: "Add Store",
            message: "Are you sure you want to add this Store",
            confirmTitle: "Yes"
        ) {
            
            // Create a new UserModel object for the store
            let user = UserModel()
            user.email = storeEmail // Set store email
            user.password = storePassword  // Set store password
            user.name = storeName // Set store name
            user.phoneNumber = storePhoneNumber // Set store phone number
            user.role = "store" // Assign role as 'store'
            
            // Save the new store to Realm database
            do {
                let realm = try Realm() // Initialize Realm instance
                try realm.write {
                    realm.add(user)// Add the store user to the database
                }
                
                // Show success alert and navigate back to admin home screen
                self.showAlert(title: "Success", message: "Store Added", completion: {
                    let storyboard = UIStoryboard(name: "AdminScreens", bundle: nil)
                    if let homeViewController = storyboard.instantiateViewController(withIdentifier: "AdminTabBarVC") as? UITabBarController {
                        self.navigationController?.setViewControllers([homeViewController], animated: true) }
                })
            }  catch {
                
                // Handle any errors during the save operation
                self.showAlert(message: "Failed to add new store. Please try again.")
            }
        }
    }
}

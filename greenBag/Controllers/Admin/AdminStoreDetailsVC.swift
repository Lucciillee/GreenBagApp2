import UIKit
import RealmSwift
class AdminStoreDetailsVC:UIViewController {
    
    
    // Store details passed from the previous screen
    var storeDetails: UserModel?
    
    // Outlets for displaying and editing store information
    @IBOutlet weak var storeNameTextField: BlackBorderedTextField!// Store name input
    @IBOutlet weak var storeEmailTextField: BlackBorderedTextField!// Store email input (read-only)
    @IBOutlet weak var storePasswordTextField: BlackBorderedTextField!// Store password input
    @IBOutlet weak var storePhoneNumberTextField: BlackBorderedTextField!// Store phone number input
    
    
    // Realm database instance for performing database operations
    private let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Populate text fields with store details
        storeNameTextField.text = storeDetails?.name
        storeEmailTextField.text = storeDetails?.email
        storePasswordTextField.text = storeDetails?.password
        storePhoneNumberTextField.text = storeDetails?.phoneNumber
        
        // Make the email field read-only
        storeEmailTextField.isUserInteractionEnabled = false

    }
    
    // Action triggered when the back button is pressed
    @IBAction func backButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)// Navigate back to the previous screen
    }
    
    // Action triggered when the update store button is pressed
    @IBAction func updateStoreButtonPressed(_ sender: Any) {
        guard let store = storeDetails else { return } // Ensure store details exist
        
        // Retrieve new values from text fields
        let newName = storeNameTextField.text ?? ""
        let newEmail = storeEmailTextField.text ?? ""
        let newPassword = storePasswordTextField.text ?? ""
        let newPhoneNumber = storePhoneNumberTextField.text ?? ""
        
        // Check if any values have changed
        if newName == store.name &&
            newEmail == store.email &&
            newPassword == store.password &&
            newPhoneNumber == store.phoneNumber {
            // No changes detected, show an alert
            showAlert(message: "No changes detected.")
            return
        }
        
        // Update store values in Realm
        do {
            try realm.write {
                store.name = newName// Update store name
                store.email = newEmail //Update store email (unlikely to change due to read-only)
                store.password = newPassword// Update store password
                store.phoneNumber = newPhoneNumber// Update store phone number
            }
            // Show success alert and navigate back
            showAlert(title: "Success", message: "Store details updated successfully!") { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }
        } catch {
            // Handle any errors during the update process
            print("Error updating store details: \(error)")// Log the error
            showAlert(message: "Failed to update store details. Please try again.")
        }
    }
    
    // Helper method to show alerts with an optional completion handler
    private func showAlert(title: String = "Error", message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            completion?()
        }))
        present(alert, animated: true, completion: nil)
    }
}

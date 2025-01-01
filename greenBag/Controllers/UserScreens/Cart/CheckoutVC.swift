import UIKit
import RealmSwift

class CheckoutVC: UIViewController {
    
    // Array to store the cart items being checked out
    var checkOutCarts: [CartItemRealm] = []
    
    // Realm database instance for performing database operations
    //The try! forces the initialization and will crash the app if there’s an error.
    private let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Fetch cart items for the logged-in user
        checkOutCarts = LoggedInUserManager.shared.getUserCarts()
        
    }
    
    // Action triggered when the back button is pressed
    @IBAction func backbuttonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)// Navigate back to the previous screen
    }
    
    // Action triggered when the place order button is pressed
    @IBAction func placeOrderButtonPressed(_ sender: Any) {
        // Show confirmation alert before placing the order
        showConfirmationAlert(
            title: "Place Order",
            message: "Are you sure you want to place this order",
            confirmTitle: "Yes"
        ) {
            // Add the cart items to the order history and navigate to home
            self.addToOrderHistory()
            self.navigateToHome()
        }
    }
    
    /// Add the cart items to the order history of the logged-in user
    private func addToOrderHistory() {
        // Get the currently logged-in user
        guard let loggedInUser = LoggedInUserManager.shared.getLoggedInUser() else {
            showAlert(message: "No logged-in user found.")
            return
        }
        
        // Fetch the user from the database
        guard let user = realm.objects(UserModel.self).filter("email == %@", loggedInUser.email).first else {
            showAlert(message: "User not found in the database.")
            return
        }
        do {
            // Add the checkout carts to the user's order history
            try realm.write{
                user.orderHistoryCarts.append(objectsIn: self.checkOutCarts)
                print("The orders are \(user.orderHistoryCarts.count)")
            }
            
            // Empty all carts after the order is placed
            LoggedInUserManager.shared.emptyAllCarts()
        } catch {
            // Handle any errors during the update process
            print("Error updating order history: \(error)")
            showAlert(message: "Failed to place order. Please try again.")
        }
        
    }
    
    
    /// Navigate to the home screen after placing the order
    private func navigateToHome() {
        let storyboard = UIStoryboard(name: "UserScreens", bundle: nil)
        if let homeViewController = storyboard.instantiateViewController(withIdentifier: "HomeVCTabBar") as? UITabBarController {
            navigationController?.setViewControllers([homeViewController], animated: true)
        }
    }
}

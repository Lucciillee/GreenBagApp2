import UIKit
import RealmSwift
class StoreAddProductVC: UIViewController {
    
    // Outlets for user input fields
    @IBOutlet weak var productNameTextField: BlackBorderedTextField!  // Product name input
    @IBOutlet weak var productCategoryTextField: BlackBorderedTextField!// Product category input
    @IBOutlet weak var productPriceTextField: BlackBorderedTextField!// Product price input
    @IBOutlet weak var productQuantityTextField: BlackBorderedTextField!// Product quantity input
    
    // Realm database instance for performing database operations
    private let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Perform any additional setup after loading the view
    }
    
    // Action triggered when the add product button is pressed
    @IBAction func addProductButtonPressed(_ sender: Any) {
        // Validate the product name field
        guard let name = productNameTextField.text, !name.isEmpty else {
            showAlert(message: "Please enter the product name.") // Show alert if validation fails
            return
        }
        // Validate the product category field
        guard let category = productCategoryTextField.text, !category.isEmpty else {
            showAlert(message: "Please enter the product category.")// Show alert if validation fails
            return                    }
        // Validate the product price field
        guard let price = productPriceTextField.text, !price.isEmpty else {
            showAlert(message: "Please enter the product price.")  // Show alert if validation fails
            return
        }
        // Validate the product quantity field
        guard let quantity = productQuantityTextField.text, !quantity.isEmpty else {
            showAlert(message: "Please enter the product quantity.")// Show alert if validation fails
            return
        }

        // Show confirmation alert before adding the product
        showConfirmationAlert(
            title: "Add Product",
            message: "Are you sure you want to add this product?",
            confirmTitle: "Yes"
        ) { [weak self] in
            guard let self = self else { return }
            // Add the product to Realm database
            self.addProductToRealm(name: name, category: category, price: price, quantity: quantity)
            // Navigate to the store home screen
            let storyboard = UIStoryboard(name: "StoreScreens", bundle: nil)
            if let homeViewController = storyboard.instantiateViewController(withIdentifier: "StoreTabBarVC") as? UITabBarController {
                self.navigationController?.setViewControllers([homeViewController], animated: true) }
        }
        
    }
    
    // Method to add a product to the Realm database
    private func addProductToRealm(name: String, category: String, price: String, quantity: String) {
        let newProduct = ProductModelRealm()// Create a new product model instance
        newProduct.name = name // Set the product name
        newProduct.category = category// Set the product category
        newProduct.price = price// Set the product price
        newProduct.quantity = quantity// Set the product quantity
        // Save the new product to Realm database
        do {
            try realm.write {
                realm.add(newProduct)// Add the product to the database
            }
            // Show success alert and navigate to the home screen
            showAlert(title: "Success", message: "Product added successfully!") { [weak self] in
                guard let self = self else { return }
                let storyboard = UIStoryboard(name: "StoreScreens", bundle: nil)
                if let homeViewController = storyboard.instantiateViewController(withIdentifier: "StoreTabBarVC") as? UITabBarController {
                    self.navigationController?.setViewControllers([homeViewController], animated: true)
                }
            }
        } catch {
            // Handle any errors during the save operation
            showAlert(message: "Failed to add product. Please try again.")
            print("Error saving product to Realm: \(error)")// Log the error
        }
    }
}

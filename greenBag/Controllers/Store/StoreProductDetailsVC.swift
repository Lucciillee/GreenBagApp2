import UIKit
import RealmSwift

class StoreProductDetailsVC: UIViewController {
    
    // Product details passed from the previous screen
    var productDetails: ProductModelRealm?
    
    // Outlets for displaying and editing product information
    @IBOutlet weak var productNameTextField: BlackBorderedTextField!
    
    
    @IBOutlet weak var productCategoryTextField: BlackBorderedTextField!
    
    
    @IBOutlet weak var productPriceTextField: BlackBorderedTextField!
    
    
    @IBOutlet weak var productQuantityTextField: BlackBorderedTextField!
    
    // Realm database instance for performing database operations
    private let realm = try! Realm()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Populate text fields with product details
        productNameTextField.text = productDetails?.name
        productCategoryTextField.text = productDetails?.category
        productPriceTextField.text = productDetails?.price
        productQuantityTextField.text = productDetails?.quantity
        
    }
    
    // Action triggered when the back button is pressed
    @IBAction func backButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    // Action triggered when the update product button is pressed
    @IBAction func updateProductButtonPressed(_ sender: Any) {
        guard let product = productDetails else { return }
                
                // Check if any value has changed
                let newName = productNameTextField.text ?? ""
                let newCategory = productCategoryTextField.text ?? ""
                let newPrice = productPriceTextField.text ?? ""
                let newQuantity = productQuantityTextField.text ?? ""

                if newName == product.name &&
                    newCategory == product.category &&
                    newPrice == product.price &&
                    newQuantity == product.quantity {
                    // No changes, do nothing
                    showAlert(message: "No changes detected.")
                    return
                }

                // Update values in Realm
                do {
                    try realm.write {
                        product.name = newName
                        product.category = newCategory
                        product.price = newPrice
                        product.quantity = newQuantity
                    }
                    // Show success alert
                    showAlert(title: "Success", message: "Product updated successfully!") { [weak self] in
                        self?.navigationController?.popViewController(animated: true)
                    }
                } catch {
                    print("Error updating product: \(error)")
                    showAlert(message: "Failed to update product. Please try again.")
                }
    }
    
}

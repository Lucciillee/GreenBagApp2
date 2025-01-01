import UIKit
import RealmSwift

class ProductDetailsVC: UIViewController {
    
    // Realm database instance for performing database operations
    private let realm = try! Realm()
    
    // Product details passed from the previous screen
    var productDetails: ProductModelRealm?
    
    // Variables to track the current number of products and the total price
    private var currentNumberOfProducts: Int = 1
    private var totalPrice: Double = 0.0
    
    // Outlets for displaying product information
    @IBOutlet weak var numberOfProducts: UILabel! // Label to show the number of products selected
    
    @IBOutlet weak var productCategory: UILabel!// Label to display product category
    @IBOutlet weak var productName: UILabel!// Label to display product name
    @IBOutlet weak var productQuantity: UILabel!// Label to display product stock quantity
    @IBOutlet weak var productPrice: UILabel!// Label to display product price
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Populate labels with product details
        productCategory.text = productDetails?.category
        productName.text = productDetails?.name
        
        if let quantity = productDetails?.quantity, let quantityInt = Int(quantity) {
            productQuantity.text = "In Stock - \(quantityInt) Remaining"
        } else {
            productQuantity.text = "In Stock - 0 Remaining"
        }
        
        //Converts the product price to a string and appends "BHD" to show it in the UI. If no price exists, it defaults to "0.0".
        productPrice.text = "\(String(describing: productDetails?.price ?? "0.0")) BHD"
        
        // Calculate total price and update the number of products label
        calculateTotalPrice()
        updateNumberOfProductsLabel()
    }

    // Update the label showing the current number of products
    private func updateNumberOfProductsLabel() {
        numberOfProducts.text = "\(currentNumberOfProducts)"
    }
    
    // Calculate the total price based on the current number of products
    private func calculateTotalPrice() {
        guard let priceString = productDetails?.price,
              let pricePerItem = Double(priceString) else {
            totalPrice = 0.0
            return
        }
        
        totalPrice = pricePerItem * Double(currentNumberOfProducts)
    }
    
    // Action triggered when the add button is pressed
    @IBAction func addButtonPressed(_ sender: Any) {
        guard let maxQuantity = Int(productDetails?.quantity ?? "0"), maxQuantity > 0 else {
            showAlert(message: "No stock available.")
            return
        }
        
        if currentNumberOfProducts < maxQuantity {
            currentNumberOfProducts += 1
            updateNumberOfProductsLabel()
        } else {
            showAlert(message: "You can't add more than the available stock.")
        }
    }
    
    // Action triggered when the subtract button is pressed
    @IBAction func subtractButtonPressed(_ sender: Any) {
        if currentNumberOfProducts > 1 {
            currentNumberOfProducts -= 1
            updateNumberOfProductsLabel()
        } else {
            showAlert(message: "You must have at least one product.")
        }
    }
    
    // Action triggered when the back button is pressed
    @IBAction func backbuttonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)// Navigate back to the previous screen
    }
    
    // Action triggered when the product review button is pressed
    @IBAction func productReviewButtonPressed(_ sender: Any) {
        let productReviewsVC: ProductReviewsVC = ProductReviewsVC.instantiate(appStoryboard: .user)
        navigationController?.pushViewController(productReviewsVC, animated: true)
    }
    
    // Action triggered when the add to cart button is pressed
    @IBAction func addProductToCartPressed(_ sender: Any) {
        // Use the totalPrice and other details to add the product to the cart
        guard let productDetails = productDetails else { return }// Ensure product details exist
        
        // Add the product to the cart using LoggedInUserManager
        LoggedInUserManager.shared.addItemToCart(
            productName: productDetails.name,
            totalPrice: "\(totalPrice)", // Use calculated total price
            quantity: currentNumberOfProducts,
            productCategory: productDetails.category
        )
        
        // Show success alert and navigate to the home screen
        showAlert(message: "Product Added to Cart") {
            let storyboard = UIStoryboard(name: "UserScreens", bundle: nil)
            if let homeViewController = storyboard.instantiateViewController(withIdentifier: "HomeVCTabBar") as? UITabBarController {
                self.navigationController?.setViewControllers([homeViewController], animated: true)
            }
        }
    }
}

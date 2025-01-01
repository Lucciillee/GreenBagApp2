import UIKit
import RealmSwift
class StoreHomeVC: UIViewController, UITableViewDelegate, UITableViewDataSource, StoreProductListXibTableViewDelegate {

    
    
    // IBOutlet for the table view displaying the list of products
    @IBOutlet weak var productsListTableView: UITableView!
    
    // Array to store the list of products fetched from Realm database
    private var productsList: [ProductModelRealm] = []
    
    // Realm database instance for performing database operations
    private let realm = try! Realm()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the delegate and data source of the table view to the current view controller
        productsListTableView.delegate = self
        productsListTableView.dataSource = self
        
        // Define a fixed row height for each table view cell
        productsListTableView.rowHeight = 160

        // Register the custom XIB file for product list cells
        productsListTableView.register(UINib(nibName: "StoreProductListXibTableView", bundle: nil), forCellReuseIdentifier: "StoreProductListXibTableView")

        // Fetch products from the Realm database
        fetchProductsFromRealm()
        
    }
    
    // Fetch all products from the Realm database
    private func fetchProductsFromRealm() {
        let products = realm.objects(ProductModelRealm.self) // Fetch all ProductModelRealm objects
        productsList = Array(products) // Convert results to an array
        productsListTableView.reloadData() // Reload table view with updated data
    }
    
    // Method to delete a product, triggered by the custom cell delegate
    func deleteProduct(cell: StoreProductListXibTableView) {
        
        // Show confirmation alert to the user
        showConfirmationAlert(
            title: "Delete Product",
            message: "Are you sure you want to delete this product?",
            confirmTitle: "Yes"
        ) {
            // Get the index path of the selected cell
            guard let indexPath = self.productsListTableView.indexPath(for: cell) else { return }
            let productToDelete = self.productsList[indexPath.row] // Identify the product to delete

            // Delete from Realm
            do {
                try self.realm.write {
                    self.realm.delete(productToDelete)
                }
                // Remove from local list and update table view
                self.productsList.remove(at: indexPath.row)
                self.productsListTableView.deleteRows(at: [indexPath], with: .fade)
            } catch {
                print("Error deleting product: \(error)")
            }
        }
    }
    
    
    func showProductDetails(cell: StoreProductListXibTableView) {
        guard let indexPath = productsListTableView.indexPath(for: cell) else { return }
        let selectedProduct = productsList[indexPath.row]
        
        let storeProductDetailsVC: StoreProductDetailsVC = StoreProductDetailsVC.instantiate(appStoryboard: .store)
        storeProductDetailsVC.productDetails = selectedProduct // Pass the selected product details
        navigationController?.pushViewController(storeProductDetailsVC, animated: true)
    }
    
    
    @IBAction func reloadButtonPressed(_ sender: Any) {
        fetchProductsFromRealm()
    }
    
}


extension StoreHomeVC {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        productsList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StoreProductListXibTableView", for: indexPath) as! StoreProductListXibTableView
        cell.configureWithStoreData(productModelRealm: productsList[indexPath.row])
        cell.selectionStyle = .none
        cell.delegate = self
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let product = productsList[indexPath.row]
        print("Selected product: \(product.name)")
    }
}

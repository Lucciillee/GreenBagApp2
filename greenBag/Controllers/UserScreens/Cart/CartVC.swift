import UIKit

class CartVC: UIViewController, UITableViewDelegate, UITableViewDataSource, CartListXibTableViewDelegate {
    
    //A custom delegate to handle specific actions, like removing an item from the cart.
    
    // Outlet for the table view displaying the cart items
    @IBOutlet weak var cartListTableView: UITableView!
    
    
    // Outlet for the checkout button
    @IBOutlet weak var checkoutButton: CustomRoundedButton!
    
    // Data source for the cart items
    private var cartItems: [CartItemRealm] = [] // A private array that holds the list of items in the cart. Each item is of type CartItemRealm, which likely represents a model for cart items stored in the Realm database.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup TableView
        cartListTableView.delegate = self// Set the delegate for the table view
        cartListTableView.dataSource = self// Set the data source for the table view
        cartListTableView.rowHeight = 140// Set the row height for the table view
        cartListTableView.register(UINib(nibName: "CartListXibTableView", bundle: nil), forCellReuseIdentifier: "CartListXibTableView")// Register the custom XIB cell
        
        // Fetch cart items from the logged-in user's cart
        fetchCartItems()
    }
    
    /// Fetch cart items from the logged-in user's cart
    private func fetchCartItems() {
        cartItems = LoggedInUserManager.shared.getUserCarts()  // Fetch cart items using the shared manager
        
        
        // Hide the checkout button if the cart is empty
        if(cartItems.isEmpty){
            checkoutButton.isHidden = true
        }
        cartListTableView.reloadData()// Reload the table view with updated data
    }
    
    // MARK: - TableView Data Source
    
    
    
    /// Return the number of rows in the table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartItems.count
    }
    
    /// Configure and return a cell for a specific row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //Dequeues a reusable cell of type CartListXibTableView.
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartListXibTableView", for: indexPath) as! CartListXibTableView
        
        //Fetches the corresponding cart item for the row and populates the cell with the cart item data.
        let cartItem = cartItems[indexPath.row]
        cell.addDataToCartCell(cartModel: cartItem)
        
        cell.delegate = self // Set delegate for remove button functionality
        cell.selectionStyle = .none // Disable cell selection highlight
        return cell
    }
    
    // MARK: - TableView Delegate
    
   //Logs the name of the cart item that was selected by the user.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected cart item: \(cartItems[indexPath.row].productName)")// Log the selected cart item
    }
    
    // MARK: - CartListXibTableViewDelegate
    
    // Remove a cart item when the remove button is pressed
    func removeCartItem(cell: CartListXibTableView) {
        guard let indexPath = cartListTableView.indexPath(for: cell) else { return }
        
        // Identify the item to remove based on the cell
        let cartItemToRemove = cartItems[indexPath.row]
        LoggedInUserManager.shared.removeItemFromCart(productName: cartItemToRemove.productName)
        
        // Remove item from Realm
        cartItems.remove(at: indexPath.row) // Remove from local data source
        cartListTableView.deleteRows(at: [indexPath], with: .fade) // Update UI
        
        
        // Hide the checkout button if the cart is empty
        if(cartItems.isEmpty){
            checkoutButton.isHidden = true
        }
    }
    
    
    // Action triggered when the checkout button is pressed
    @IBAction func checkoutButtonPressed(_ sender: Any) {
        let checkoutVC: CheckoutVC = CheckoutVC.instantiate(appStoryboard: .user)// Instantiate the checkout screen
        navigationController?.pushViewController(checkoutVC, animated: true)// Navigate to the checkout screen
    }
}

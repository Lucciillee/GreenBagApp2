import UIKit
import RealmSwift

class OrderHistoryVC: UIViewController, UITableViewDelegate, UITableViewDataSource, CartListXibTableViewDelegate {
    
    @IBOutlet weak var orderListTableView: UITableView!
    
    private let realm = try! Realm()
    private var ordersList: [CartItemRealm] = [] // Data source for the cart items
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup TableView
        orderListTableView.delegate = self
        orderListTableView.dataSource = self
        orderListTableView.rowHeight = 140
        orderListTableView.register(UINib(nibName: "CartListXibTableView", bundle: nil), forCellReuseIdentifier: "CartListXibTableView")
        
        // Fetch cart items
        fetchCartItems()
    }
    
    
    @IBAction func backButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    /// Fetch cart items from the logged-in user's cart
    /// 
    private func fetchCartItems() {
            // Get the currently logged-in user
            guard let loggedInUser = LoggedInUserManager.shared.getLoggedInUser() else {
                showAlert(message: "No logged-in user found.")
                return
            }
            guard let user = realm.objects(UserModel.self).filter("email == %@", loggedInUser.email).first else {
                showAlert(message: "User not found in the database.")
                return
            }
            
        ordersList = Array(user.orderHistoryCarts) // Use the shared instance
        orderListTableView.reloadData()
    }
    
    // MARK: - TableView Data Source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ordersList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartListXibTableView", for: indexPath) as! CartListXibTableView
        let cartItem = ordersList[indexPath.row]
        cell.addDataToCartCell(cartModel: cartItem)
        cell.delegate = self // Set delegate for remove button
        cell.selectionStyle = .none
        return cell
    }
    
    // MARK: - TableView Delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected cart item: \(ordersList[indexPath.row].productName)")
    }
    
    // MARK: - CartListXibTableViewDelegate
    
    func removeCartItem(cell: CartListXibTableView) {
        guard let indexPath = orderListTableView.indexPath(for: cell) else { return }
        
        let cartItemToRemove = ordersList[indexPath.row]
        
        // Get the currently logged-in user
        guard let loggedInUser = LoggedInUserManager.shared.getLoggedInUser() else {
            print("Failed to retrieve current user's email.")
            return
        }
        
        // Fetch the user from Realm
        guard let currentUser = realm.objects(UserModel.self).filter("email == %@", loggedInUser.email).first else {
            print("User not found.")
            return
        }
        
        do {
            try realm.write {
                // Find the matching cart item in the user's orderHistoryCarts
                if let itemToRemove = currentUser.orderHistoryCarts.first(where: { $0.productName == cartItemToRemove.productName }) {
                    currentUser.orderHistoryCarts.remove(at: currentUser.orderHistoryCarts.index(of: itemToRemove)!)
                }
            }
            
            // Remove the item from the local data source and update the UI
            ordersList.remove(at: indexPath.row) // Remove from local data source
            orderListTableView.deleteRows(at: [indexPath], with: .fade) // Update UI
            
            print("Item successfully removed from order history.")
        } catch {
            print("Error removing item from order history: \(error)")
        }
    }

    
    @IBAction func checkoutButtonPressed(_ sender: Any) {
        let checkoutVC: CheckoutVC = CheckoutVC.instantiate(appStoryboard: .user)
        navigationController?.pushViewController(checkoutVC, animated: true)
    }
}

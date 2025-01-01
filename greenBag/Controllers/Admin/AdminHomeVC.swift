import UIKit
import RealmSwift

class AdminHomeVC: UIViewController, UITableViewDelegate, UITableViewDataSource, StoreXibTableViewDelegate {

    
    // Action triggered by the reload button to refresh the store list
    @IBAction func reloadButtonPressed(_ sender: Any) {
        fetchStoresFromRealm()
    }
    
    // Outlet for the table view displaying the list of stores
    @IBOutlet weak var storesListTableView: UITableView!
    
    // Array to store the list of stores fetched from Realm
    private var storesList: [UserModel] = []
    // Realm database instance for performing database operations
    private let realm = try! Realm()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set the delegate and data source of the table view to the current view controller
        storesListTableView.delegate = self
        storesListTableView.dataSource = self
        
        // Define a fixed row height for each table view cell
        storesListTableView.rowHeight = 160
        
        
        // Register the custom XIB file for store list cells
        storesListTableView.register(UINib(nibName: "StoresListXibTableView", bundle: nil), forCellReuseIdentifier: "StoresListXibTableView")
        
        // Fetch stores from the Realm database
        fetchStoresFromRealm()
    }
    
    // Fetch all stores with the role 'store' from the Realm database
    private func fetchStoresFromRealm() {
        let stores = realm.objects(UserModel.self).filter("role == 'store'")// Filter by role 'store'
        storesList = Array(stores)// Convert results to an array
        storesListTableView.reloadData()// Reload table view with updated data
    }
    
    // Method to delete a store, triggered by the custom cell delegate
    func deleteStore(cell: StoresListXibTableView) {
        // Show confirmation alert to the user
        showConfirmationAlert(
            title: "Submit Review",
            message: "Are you sure you want to add this Store",
            confirmTitle: "Yes"
        ) {
            // Get the index path of the selected cell
            guard let indexPath = self.storesListTableView.indexPath(for: cell) else { return }
            let storeToDelete = self.storesList[indexPath.row] // Identify the store to delete
            
            // Delete the store from Realm database
            do {
                try self.realm.write {
                    self.realm.delete(storeToDelete) // Remove from database
                }
                // Remove from local list and update table view
                self.storesList.remove(at: indexPath.row)
                self.storesListTableView.deleteRows(at: [indexPath], with: .fade)
            } catch {
                print("Error deleting store: \(error)")// Log any errors
            }
        }

    }
    
    // Method to display store details, triggered by the custom cell delegate
    func showStoreDetails(cell: StoresListXibTableView) {
        // Get the index path of the selected cell
        guard let indexPath = storesListTableView.indexPath(for: cell) else { return }
        let selectedStore = storesList[indexPath.row]// Identify the selected store
        
        // Navigate to the AdminStoreDetailsVC, passing the selected store details
        let adminStoreDetailsVC: AdminStoreDetailsVC = AdminStoreDetailsVC.instantiate(appStoryboard: .admin)
        adminStoreDetailsVC.storeDetails = selectedStore // Pass the selected product details
        navigationController?.pushViewController(adminStoreDetailsVC, animated: true)
    }
    
    
}


extension AdminHomeVC {
    // TableView DataSource method to specify the number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        storesList.count// Number of stores in the list
    }
    
    // TableView DataSource method to configure each cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Dequeue a reusable cell of type StoresListXibTableView
        let cell = tableView.dequeueReusableCell(withIdentifier: "StoresListXibTableView", for: indexPath) as! StoresListXibTableView
        cell.configureWithStoreData(userModel: storesList[indexPath.row])// Configure cell with store data
        cell.selectionStyle = .none// Disable cell selection highlight
        cell.delegate = self// Set the view controller as the delegate for cell actions
        return cell
        
    }
    
}
    



extension AdminHomeVC {
    // TableView Delegate method to handle row selection (currently empty)
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Action to perform on row selection can be added here
        
    }
}


import UIKit
import RealmSwift

class HomePageVC: UIViewController {
    
    @IBOutlet weak var productSearchField: CustomTextField!
    
    @IBOutlet weak var productsTableView: UITableView!
    
    // this Used for local database access
    private let realm = try! Realm()
    // arrays of products
    private var productsList: [ProductModelRealm] = []
    // array of filtered product
    private var filteredProductsList: [ProductModelRealm] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        productsTableView.delegate = self
        productsTableView.dataSource = self
        productsTableView.rowHeight = 120
        filteredProductsList = productsList
        //custom the cells and layout in the table view
        productsTableView.register(UINib(nibName: "ProductXibTableView", bundle: nil), forCellReuseIdentifier: "ProductXibTableView")
        
        productSearchField.delegate = self
        //populating the product list
        fetchProductsFromRealm()
    }
    
    
    // fetch all the product from the Relm database
    private func fetchProductsFromRealm() {
        //return a collection of all productModelRelm objects in the database
        let products = realm.objects(ProductModelRealm.self)
        //convert them to arraylist
        productsList = Array(products)
        //convert them to arraylist for filtering
        filteredProductsList = productsList
        //reloads the view with the products
        productsTableView.reloadData()
    }
    
}


extension HomePageVC: UITextFieldDelegate {
    // this fun calls what the user types
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Get the updated text in the search field after the change
        let currentText = textField.text ?? ""
        guard let range = Range(range, in: currentText) else { return true }
        
        // Calculate the updated text by replacing the characters
        let updatedText = currentText.replacingCharacters(in: range, with: string)
        
        // Filter the product list based on the updated text
        filterProducts(with: updatedText)
        // Allows the text field to update its display with the new text
        return true
    }

    // this fun filters the products
    private func filterProducts(with searchText: String) {
        if searchText.isEmpty {
            // If the search field is empty, show all products
            filteredProductsList = productsList
        } else {
            // Filter products by name matching the search text
            filteredProductsList = productsList.filter { product in
                return product.name.lowercased().contains(searchText.lowercased())
            }
        }
        
        // Reload the table view with the filtered results
        productsTableView.reloadData()
    }
}



extension HomePageVC: UITableViewDelegate {
    //This method is called whenever a user taps on a row in the table view
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Creates an instance of ProductDetailsVC from the user storyboard
        let productDetailsVC: ProductDetailsVC = ProductDetailsVC.instantiate(appStoryboard: .user)
        productDetailsVC.productDetails = filteredProductsList[indexPath.row] // Pass selected product details
        
        //Pushes the ProductDetailsVC onto the navigation stack, transitioning to the details screen with an animation
        navigationController?.pushViewController(productDetailsVC, animated: true)
    }
}

extension HomePageVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //Returns the number of rows in the given section of the table view
        return filteredProductsList.count
    }
    
    // This method is responsible for populating the cells in the table view with the data from the filtered product list.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Dequeue a Reusable Cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductXibTableView", for: indexPath) as! ProductXibTableView
        //Populate the Cell with Product Data
        cell.addCellDatawithProductData(productsListModel: filteredProductsList[indexPath.row])
        //Remove Row Selection Highlighting
        cell.selectionStyle = .none
        //Return the Configured Cell
        return cell
    }
}







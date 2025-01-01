import UIKit
class AddNewCardVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func backbuttonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addNewCardPressed(_ sender: Any) {
        showConfirmationAlert(
            title: "Add Card",
            message: "Are you sure you want to add this Card",
            confirmTitle: "Yes"
        ) {
            let storyboard = UIStoryboard(name: "UserScreens", bundle: nil)
            if let homeViewController = storyboard.instantiateViewController(withIdentifier: "HomeVCTabBar") as? UITabBarController {
                self.navigationController?.setViewControllers([homeViewController], animated: true) }
        }
    }
    
}

import UIKit
class StoreSettingsVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    @IBAction func logoutPressed(_ sender: Any) {
        showConfirmationAlert(
            title: "Log Out",
            message: "Are you sure you want to logout",
            confirmTitle: "Logout"
        ) {
            LoggedInUserManager.shared.logoutUser()
            let signinVC: SigninVC = SigninVC.instantiate(appStoryboard: .main)
            self.navigationController?.setViewControllers([signinVC], animated: true)
        }
    }
}

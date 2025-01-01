import UIKit
class WriteReviewVC: UIViewController {
    override func viewDidLoad() {
        //method called when the view is loaded into memory.
        super.viewDidLoad()
        // Perform any additional setup after loading the view
    }
    // Action triggered when the back button is pressed
    @IBAction func backbuttonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)// Navigate back to the previous screen
    }
    // Action triggered when the submit review button is pressed
    @IBAction func submitReviewButtonPressed(_ sender: Any) {

        // Show confirmation alert before submitting the review
        showConfirmationAlert(
            title: "Submit Review",
            message: "Are you sure you want to submit this Review?",
            confirmTitle: "Submit"
        ) {
            // Navigate back to the home screen upon confirmation
            
            //Loads the storyboard named UserScreens.
            let storyboard = UIStoryboard(name: "UserScreens", bundle: nil)
            
           // Finds a view controller in the storyboard with the identifier HomeVCTabBar.

            if let homeViewController = storyboard.instantiateViewController(withIdentifier: "HomeVCTabBar") as? UITabBarController {
                
                //Replaces the current navigation stack with the home screen.
                self.navigationController?.setViewControllers([homeViewController], animated: true) }
        }
        
        
    }
    

        

    
}

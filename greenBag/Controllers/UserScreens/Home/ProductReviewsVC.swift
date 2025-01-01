import UIKit
class ProductReviewsVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    // Action triggered when the back button is pressed
    @IBAction func backbuttonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)// Navigate back to the previous screen
    }
    // Action triggered when the write review button is pressed
    @IBAction func writeReviewButtonPressed(_ sender: Any) {
        // Instantiate the WriteReviewVC from the storyboard
        let writeReviewVC: WriteReviewVC = WriteReviewVC.instantiate(appStoryboard: .user)
        // Navigate to the write review screen
        navigationController?.pushViewController(writeReviewVC, animated: true)
    }
    
}

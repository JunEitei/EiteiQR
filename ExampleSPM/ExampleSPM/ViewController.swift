import UIKit
import EiteiQR

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func onButtonTapped(_ sender: Any) {
        let viewController = EiteiQR.ViewController()
        viewController.modalPresentationStyle = .fullScreen
        present(viewController, animated: true);
    }
    
}


import UIKit

class BaseViewController: UIViewController {
    @IBOutlet var mapImageView: UIImageView!

}

class Page1ViewController: BaseViewController {
    override func viewDidLoad() {
        mapImageView.image = UIImage(named: "Map-1")
    }
}

class Page2ViewController: BaseViewController {
    override func viewDidLoad() {
        mapImageView.image = UIImage(named: "Map-2")
    }
}

class Page3ViewController: BaseViewController {
    override func viewDidLoad() {
        mapImageView.image = UIImage(named: "Map-3")
    }
}

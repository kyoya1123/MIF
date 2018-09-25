import UIKit

final class TopViewController: UIViewController {

    @IBOutlet var buttons: [UIButton]!
    
    let vcs = [MapViewController(), GuideViewController(), StampRallyViewController(), VoteViewController(), CashierViewController(), IntroduceViewController()]
    
    override func viewDidLoad() {
        setupView()
    }
}

private extension TopViewController {
    
    func setupView() {
        setupButtons()
    }
    
    func setupButtons() {
        buttons.forEach {
            $0.addTarget(self, action: #selector(didtapButton(_:)), for: .touchUpInside)
        }
    }
    
    @objc func didtapButton(_ sender: UIButton) {
        let vc = vcs[sender.tag]
        navigationController?.pushViewController(vc, animated: true)
    }
}


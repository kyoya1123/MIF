import UIKit

final class TopViewController: UIViewController {

    @IBOutlet var buttons: [UIButton]!
    
    let vcs = [PageViewController(), TimeTableViewController(), StampRallyViewController(), VoteViewController(), NotificationSettingViewController()]
    
    override func viewDidLoad() {
        title = "ホーム"
        setupView()
    }
}

private extension TopViewController {
    
    func setupView() {
        setupButtons()
    }
    
    func setupButtons() {
        buttons.forEach {
            $0.layer.cornerRadius = 10
            $0.addTarget(self, action: #selector(didtapButton(_:)), for: .touchUpInside)
        }
    }
    
    @objc func didtapButton(_ sender: UIButton) {
        if sender.tag == 0 {
            let storyboard: UIStoryboard = UIStoryboard(name: "Map", bundle: nil)
            let next = storyboard.instantiateInitialViewController() as! PageViewController
            next.title = sender.titleLabel?.text
            navigationController?.pushViewController(next, animated: true)
            return
        }
        let vc = vcs[sender.tag]
        vc.title = sender.titleLabel?.text
        navigationController?.pushViewController(vc, animated: true)
    }
}


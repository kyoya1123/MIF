import UIKit

final class TimeTableViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var daySegment: UISegmentedControl!
    var timetableImageView: UIImageView!
    
    var imageNames = ["Sat", "Sun"]
    
    override func viewDidLoad() {
       setupView()
    }
}

private extension TimeTableViewController {
    func setupView() {
        setupImage()
        setupSegment()
    }
    
    func setupImage() {
        timetableImageView = UIImageView(frame: CGRect(x: 0, y: 30, width: 1057, height: 639))
        timetableImageView.image = UIImage(named: "Sat")
        timetableImageView.contentMode = .scaleAspectFit
        scrollView.contentSize = timetableImageView.frame.size
        scrollView.addSubview(timetableImageView)
    }
    
    func setupSegment() {
        daySegment.sizeToFit()
        daySegment.addTarget(self, action: #selector(didselectDay), for: .valueChanged)
        navigationItem.titleView = daySegment
    }
    
    @objc func didselectDay() {
        timetableImageView.image = UIImage(named: imageNames[daySegment.selectedSegmentIndex])
    }
}

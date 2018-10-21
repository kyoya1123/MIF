import UIKit

class PageViewController: UIPageViewController {
    
    var pages = [UIViewController]()
    var pageControl: UIPageControl!
    
    override func viewDidLoad() {
        readyViewControllers()
        setupPageControl()
        view.addSubview(pageControl)
        setViewControllers([pages[0]], direction: .forward, animated: true, completion: nil)
        self.dataSource = self
    }
    
    func readyViewControllers() {
        let mapStoryboard = UIStoryboard(name: "Map", bundle: nil)
        pages = [
            mapStoryboard.instantiateViewController(withIdentifier: "Page1ViewController") as! Page1ViewController,
            mapStoryboard.instantiateViewController(withIdentifier: "Page2ViewController") as! Page2ViewController,
            mapStoryboard.instantiateViewController(withIdentifier: "Page3ViewController") as! Page3ViewController,
        ]
    }
    
    func setupPageControl() {
        pageControl = UIPageControl(frame: CGRect(x: 0, y: view.frame.height - 60, width: view.frame.width, height: 40))
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0
        pageControl.isUserInteractionEnabled = true
        pageControl.pageIndicatorTintColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        pageControl.currentPageIndicatorTintColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
    }
}

extension PageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        pageControl.currentPage = viewController.view.tag
        if viewController.isKind(of: Page3ViewController.self) {
            return pages[1]
        } else if viewController.isKind(of: Page2ViewController.self) {
            return pages[0]
        } else {
            return nil
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        pageControl.currentPage = viewController.view.tag
        if viewController.isKind(of: Page1ViewController.self) {
            return pages[1]
        } else if viewController.isKind(of: Page2ViewController.self) {
            return pages[2]
        } else {
            return nil
        }
    }
}

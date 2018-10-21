import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let vc = TopViewController()
        let nav = UINavigationController(rootViewController: vc)
        nav.navigationBar.barTintColor = #colorLiteral(red: 0.231372549, green: 0.4470588235, blue: 0.8, alpha: 1)
        nav.navigationBar.tintColor = .white
        nav.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
        FIRApp.configure()
        return true
    }
}

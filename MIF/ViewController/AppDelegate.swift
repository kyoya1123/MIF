import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let vc = TopViewController()
        let nav = UINavigationController(rootViewController: vc)
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
        FIRApp.configure()
        return true
    }
}

import UIKit
import Firebase

final class TopViewController: UIViewController {

    var ref: FIRDatabaseReference!
    
    override func viewDidLoad() {
        ref = FIRDatabase.database().reference()
        let S2Vote = ref.child("S2-vote")
        let aVote = S2Vote.child("a")
        S2Vote.observe(.value, with: { snapshot in
            print(snapshot.value as! [String : Int])
        })
    }
}

fileprivate extension TopViewController {
    
}

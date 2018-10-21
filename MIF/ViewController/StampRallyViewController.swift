import UIKit
import ARKit
import SceneKit

class StampRallyViewController: UIViewController {
    
    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet var stampImageViews: [UIImageView]!
    @IBOutlet var certificateView: UIView!
    
    var imageNames = ["stamp1", "stamp2", "stamp3", "stamp4", "stamp5"]
    var indexArray = [Int]()
    let userDefault = UserDefaults.standard
    
    override func viewDidLoad() {
        if userDefault.bool(forKey: "finished") {
            showCertificate()
            return
        }
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        sceneView.session.run(setupConfiguration())
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        sceneView.session.pause()
    }
}

private extension StampRallyViewController {
    func setupView() {
        setupSceneView()
        setImages()
    }
    
    func setImages() {
        if let indexes = userDefault.array(forKey: "indexes") {
            indexArray = indexes as! [Int]
        }
        for i in indexArray {
            stampImageViews[i].image = UIImage(named: imageNames[i] + "-")
        }
    }
    
    func setupSceneView() {
        sceneView.delegate = self
        #if DEBUG
        sceneView.showsStatistics = true
        #endif
    }
    
    func setupConfiguration() -> ARWorldTrackingConfiguration {
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.vertical]
        guard let referenceImages = ARReferenceImage.referenceImages(inGroupNamed: "Stamps", bundle: nil) else {
            fatalError("Missing expected asset catalog resources.")
        }
        configuration.detectionImages = referenceImages
        return configuration
    }
}

extension StampRallyViewController: ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let imageAnchor = anchor as? ARImageAnchor else { return }
        guard let imageName = imageAnchor.referenceImage.name else { return }
        let index = self.imageNames.index(of: imageName)!
        if self.indexArray.contains(index) {
            return
        }
        let referenceImage = imageAnchor.referenceImage
        let plane = SCNPlane(width: referenceImage.physicalSize.width,
                             height: referenceImage.physicalSize.height)
        let planeNode = SCNNode(geometry: plane)
        planeNode.opacity = 0.25
        planeNode.eulerAngles.x = -.pi / 2
        planeNode.runAction(self.imageHighlightAction)
        node.addChildNode(planeNode)
        DispatchQueue.main.async {
            self.stampImageViews[index].image = UIImage(named: self.imageNames[index] + "-")
            self.indexArray.append(index)
            print(self.indexArray.count)
            self.userDefault.set(self.indexArray, forKey: "indexes")
            if self.indexArray.count == 5 {
                self.userDefault.set(true, forKey: "finished")
                DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.seconds(2)) {
                    self.showCertificate()
                }
            }
        }
    }
    
    var imageHighlightAction: SCNAction {
        return .sequence([
            .wait(duration: 0.25),
            .fadeOpacity(to: 0.85, duration: 0.25),
            .fadeOpacity(to: 0.15, duration: 0.25),
            .fadeOpacity(to: 0.85, duration: 0.25),
            .fadeOut(duration: 0.5),
            .removeFromParentNode()
            ])
    }
    
    func showObject() {
        
    }
    
    func showCertificate() {
        DispatchQueue.main.async {
            self.view.bringSubviewToFront(self.certificateView)
        }
    }
}

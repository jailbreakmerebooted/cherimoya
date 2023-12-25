import UIKit
import SwiftUI

class SwiftUIViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        // Create and present the SwiftUI view
        let swiftUIView = Cherimoya()
        let hostingController = UIHostingController(rootView: swiftUIView)
        
        // Set up the hosting controller
        addChild(hostingController)
        hostingController.view.frame = view.bounds // Set the frame to match the size of the hosting controller's view
        view.addSubview(hostingController.view)
        hostingController.didMove(toParent: self)
    }
}

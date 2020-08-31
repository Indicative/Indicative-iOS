import Foundation
import UIKit


class SwiftViewController : UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        Indicative.record("iOS Viewed Page 2 (Swift)")
        Indicative.record("iOS - Page View", withProperties: ["page": 2])
    }
}

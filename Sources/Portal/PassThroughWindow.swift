#if canImport(UIKit)
import UIKit
import SwiftUI

/// A window that lets touches pass through non-content areas
internal class PassThroughWindow: UIWindow {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard let view = super.hitTest(point, with: event) else { return nil }
        // If the hit is on the root view controller's background, pass it through
        return rootViewController?.view == view ? nil : view
    }
}
#else
import SwiftUI

/// Stub for non-UIKit platforms
internal class PassThroughWindow { }
#endif

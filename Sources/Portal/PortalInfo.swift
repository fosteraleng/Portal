import SwiftUI

/// Data record for a portal animation
public struct PortalInfo: Identifiable {
    public let id = UUID()
    public let infoID: String
    public var isActive = false
    public var layerView: AnyView? = nil
    public var animateView = false
    public var hideView = false
    public var sourceAnchor: Anchor<CGRect>? = nil
    public var destinationAnchor: Anchor<CGRect>? = nil
    public var sourceProgress: CGFloat = 0
    public var destinationProgress: CGFloat = 0
    public var completion: (Bool) -> Void = { _ in }

    public init(id: String) {
        self.infoID = id
    }
}

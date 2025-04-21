import SwiftUI

/// Marks this view as a portal destination (arriving view)
public struct PortalDestination<Content: View>: View {
    public let id: String
    @ViewBuilder public let content: Content
    @EnvironmentObject private var portalModel: CrossModel

    public init(id: String, @ViewBuilder content: () -> Content) {
        self.id = id
        self.content = content()
    }

    public var body: some View {
        content
            .opacity(opacity)
            .anchorPreference(key: AnchorKey.self, value: .bounds) { anchor in
                if let idx = index, portalModel.info[idx].isActive {
                    return [destKey: anchor]
                }
                return [:]
            }
            .onPreferenceChange(AnchorKey.self) { prefs in
                if let idx = index, portalModel.info[idx].isActive {
                    portalModel.info[idx].destinationAnchor = prefs[destKey]
                }
            }
    }

    private var destKey: String { "\(id)DEST" }

    private var index: Int? {
        portalModel.info.firstIndex { $0.infoID == id }
    }

    private var opacity: CGFloat {
        guard let idx = index else { return 1 }
        return portalModel.info[idx].isActive ? (portalModel.info[idx].hideView ? 1 : 0) : 1
    }
}

public extension View {
    /// Attach to the view that arrives
    func portalDestination(id: String) -> some View {
        PortalDestination(id: id) { self }
    }
}

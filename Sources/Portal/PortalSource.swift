import SwiftUI

/// Marks this view as a Portal source (leaving view)
public struct PortalSource<Content: View>: View {
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
                    return [id: anchor]
                }
                return [:]
            }
            .onPreferenceChange(AnchorKey.self) { prefs in
                if let idx = index, portalModel.info[idx].isActive, portalModel.info[idx].sourceAnchor == nil {
                    portalModel.info[idx].sourceAnchor = prefs[id]
                }
            }
    }

    private var index: Int? {
        portalModel.info.firstIndex { $0.infoID == id }
    }

    private var opacity: CGFloat {
        guard let idx = index else { return 1 }
        return portalModel.info[idx].destinationAnchor == nil ? 1 : 0
    }
}

public extension View {
    /// Attach to the view that leaves
    func portalSource(id: String) -> some View {
        PortalSource(id: id) { self }
    }
}

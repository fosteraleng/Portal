import SwiftUI

/// Shared model for Portal animations
public class CrossModel: ObservableObject {
    @Published public var info: [PortalInfo] = []
    public init() {}
}

import SwiftUI

/// PreferenceKey for collecting Portal anchors
public struct AnchorKey: PreferenceKey {
    public static var defaultValue: [String: Anchor<CGRect>] = [:]
    public static func reduce(value: inout [String : Anchor<CGRect>], nextValue: () -> [String : Anchor<CGRect>]) {
        value.merge(nextValue()) { $1 }
    }
}

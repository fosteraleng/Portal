import SwiftUI

/// Internal overlay view that renders and animates portal layers
internal struct PortalLayerView: View {
    @EnvironmentObject private var portalModel: CrossModel

    var body: some View {
        GeometryReader { proxy in
            ForEach($portalModel.info) { $info in
                ZStack {
                    if let source = info.sourceAnchor,
                       let destination = info.destinationAnchor,
                       let layer = info.layerView,
                       !info.hideView {
                        let sRect = proxy[source]
                        let dRect = proxy[destination]
                        let animate = info.animateView
                        let width = animate ? dRect.size.width : sRect.size.width
                        let height = animate ? dRect.size.height : sRect.size.height
                        let x = animate ? dRect.minX : sRect.minX
                        let y = animate ? dRect.minY : sRect.minY

                        layer
                            .frame(width: width, height: height)
                            .offset(x: x, y: y)
                            .transition(.identity)
                    }
                }
                .onChangeCompat(of: info.animateView) { newValue in
                    // Delay to allow animation to finish
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.61) {
                        if !newValue {
                            info.isActive = false
                            info.layerView = nil
                            info.sourceAnchor = nil
                            info.destinationAnchor = nil
                            info.sourceProgress = 0
                            info.destinationProgress = 0
                            info.completion(false)
                        } else {
                            info.hideView = true
                            info.completion(true)
                        }
                    }
                }
            }
        }
    }
}

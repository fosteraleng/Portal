import SwiftUI

/// Drives the Portal floating layer for a given id
@available(iOS 15.0, macOS 13.0, *)
public struct PortalTransitionModifier<Layer: View>: ViewModifier {
    public let id: String
    @Binding public var animate: Bool
    public let sourceProgress: CGFloat
    public let destinationProgress: CGFloat
    public let animation: Animation
    public let delay: TimeInterval
    public let layer: () -> Layer
    public let completion: (Bool) -> Void

    @EnvironmentObject private var portalModel: CrossModel

    public init(
        id: String,
        animate: Binding<Bool>,
        sourceProgress: CGFloat = 0,
        destinationProgress: CGFloat = 0,
        animation: Animation = .easeInOut(duration: 0.55),
        delay: TimeInterval = 0.06,
        layer: @escaping () -> Layer,
        completion: @escaping (Bool) -> Void = { _ in }
    ) {
        self.id = id
        self._animate = animate
        self.sourceProgress = sourceProgress
        self.destinationProgress = destinationProgress
        self.animation = animation
        self.delay = delay
        self.layer = layer
        self.completion = completion
    }

    public func body(content: Content) -> some View {
        content
            .onAppear {
                if !portalModel.info.contains(where: { $0.infoID == id }) {
                    portalModel.info.append(PortalInfo(id: id))
                }
            }
            .onChangeCompat(of: animate) { newValue in
                guard let idx = portalModel.info.firstIndex(where: { $0.infoID == id }) else { return }
                // activate and configure
                portalModel.info[idx].isActive = true
                portalModel.info[idx].layerView = AnyView(layer())
                portalModel.info[idx].sourceProgress = sourceProgress
                portalModel.info[idx].destinationProgress = destinationProgress
                portalModel.info[idx].completion = completion

                if newValue {
                    DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                        withAnimation(animation) {
                            portalModel.info[idx].animateView = true
                        }
                    }
                } else {
                    portalModel.info[idx].hideView = false
                    withAnimation(animation) {
                        portalModel.info[idx].animateView = false
                    }
                }
            }
    }
}

@available(iOS 15.0, macOS 13.0, *)
public extension View {
    /// Triggers a portal animation for the given id
    func portalTransition<Layer: View>(
        id: String,
        animate: Binding<Bool>,
        sourceProgress: CGFloat = 0,
        destinationProgress: CGFloat = 0,
        animation: Animation = .easeInOut(duration: 0.55),
        delay: TimeInterval = 0.06,
        @ViewBuilder layer: @escaping () -> Layer,
        completion: @escaping (Bool) -> Void = { _ in }
    ) -> some View {
        self.modifier(
            PortalTransitionModifier(
                id: id,
                animate: animate,
                sourceProgress: sourceProgress,
                destinationProgress: destinationProgress,
                animation: animation,
                delay: delay,
                layer: layer,
                completion: completion
            )
        )
    }
}

import SwiftUI

/// Drives the Portal floating layer for a given id.
///
/// Use this view modifier to trigger and control a portal transition animation between
/// a source and destination view. The modifier manages the floating overlay layer,
/// animation timing, and transition state for the specified `id`.
///
/// - Parameters:
///   - id: A unique string identifier for the portal transition. This should match the `id` used for the corresponding portal source and destination.
///   - animate: A binding that triggers the transition when set to `true`.
///   - sourceProgress: The progress value for the source view (default: 0).
///   - destinationProgress: The progress value for the destination view (default: 0).
///   - animation: The animation to use for the transition (default: `.bouncy(duration: 0.3)`).
///   - animationDuration: The duration of the transition animation (default: 0.3).
///   - delay: The delay before starting the animation (default: 0.06).
///   - layer: A closure that returns the floating overlay view to animate.
///   - completion: A closure called when the transition completes, with a `Bool` indicating success.
///
/// Example usage:
/// ```swift
/// .portalTransition(
///     id: "Book1",
///     animate: $showDetail,
///     animation: .smooth(duration: 0.6),
///     animationDuration: 0.6
/// ) {
///     Image("cover")
/// }
/// ```
@available(iOS 15.0, macOS 13.0, *)
public struct PortalTransitionModifier<Layer: View>: ViewModifier {
    public let id: String
    @Binding public var animate: Bool
    public let sourceProgress: CGFloat
    public let destinationProgress: CGFloat
    public let animation: Animation
    public let animationDuration: TimeInterval
    public let delay: TimeInterval
    public let layer: () -> Layer
    public let completion: (Bool) -> Void

    @EnvironmentObject private var portalModel: CrossModel
    public init(
        id: String,
        animate: Binding<Bool>,
        sourceProgress: CGFloat = 0,
        destinationProgress: CGFloat = 0,
        animation: Animation = .bouncy(duration: 0.3),
        animationDuration: TimeInterval = 0.3,
        delay: TimeInterval = 0.06,
        layer: @escaping () -> Layer,
        completion: @escaping (Bool) -> Void = { _ in }
    ) {
        self.id = id
        self._animate = animate
        self.sourceProgress = sourceProgress
        self.destinationProgress = destinationProgress
        self.animation = animation
        self.animationDuration = animationDuration
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
                portalModel.info[idx].animationDuration = animationDuration
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

/// Drives the portal animation for the given id.
///
/// Attach this modifier to a container view to drive a portal transition between
/// a source and destination. The modifier manages the floating overlay, animation,
/// and transition state for the specified `id`.
///
/// - Parameters:
///   - id: A unique string identifier for the portal transition. This should match the `id` used for the corresponding portal source and destination.
///   - animate: A binding that triggers the transition when set to `true`.
///   - sourceProgress: The progress value for the source view (default: 0).
///   - destinationProgress: The progress value for the destination view (default: 0).
///   - animation: The animation to use for the transition (default: `.smooth(duration: 0.42, extraBounce: 0.2)`).
///   - animationDuration: The duration of the transition animation (default: 0.72).
///   - delay: The delay before starting the animation (default: 0.06).
///   - layer: A closure that returns the floating overlay view to animate.
///   - completion: A closure called when the transition completes, with a `Bool` indicating success.
///
/// Example usage:
/// ```swift
/// .portalTransition(
///     id: "Book1",
///     animate: $showDetail,
///     animation: .smooth(duration: 0.6),
///     animationDuration: 0.6
/// ) {
///     Image("cover")
/// }
/// ```
@available(iOS 15.0, macOS 13.0, *)
public extension View {
    /// Triggers a portal animation for the given id
    func portalTransition<Layer: View>(
        id: String,
        animate: Binding<Bool>,
        sourceProgress: CGFloat = 0,
        destinationProgress: CGFloat = 0,
        animation: Animation = .smooth(duration: 0.42, extraBounce: 0.2),
        animationDuration: TimeInterval = 0.72,
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
                animationDuration: animationDuration,
                delay: delay,
                layer: layer,
                completion: completion
            )
        )
    }
}

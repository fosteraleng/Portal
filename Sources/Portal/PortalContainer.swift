import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

public struct PortalContainer<Content: View>: View {
    @ViewBuilder public var content: Content
    @Environment(\.scenePhase) private var scene
    @StateObject private var portalModel = CrossModel()
    @State private var overlayWindow: PassThroughWindow?

    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    public var body: some View {
        content
            .onChange(of: scene) { newValue in
                if newValue == .active {
                    addOverlayWindow()
                }
            }
            .environmentObject(portalModel)
    }

    private func addOverlayWindow() {
      #if canImport(UIKit)
      for scene in UIApplication.shared.connectedScenes {
        guard let windowScene = scene as? UIWindowScene,
              scene.activationState == .foregroundActive,
              overlayWindow == nil else { continue }

        let window = PassThroughWindow(windowScene: windowScene)
        window.backgroundColor = .clear
        window.isUserInteractionEnabled = false
        window.isHidden = false

        // Use your hidden‐status hosting controller
        let root = HiddenStatusHostingController(
          rootView: PortalLayerView()
                      .environmentObject(portalModel)
        )
        root.view.backgroundColor = .clear
        root.view.frame = windowScene.screen.bounds

        window.rootViewController = root
        overlayWindow = window
        break
      }
      #endif
    }

}


import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

/// A HostingController that always hides the status bar
final class HiddenStatusHostingController<Content: View>: UIHostingController<Content> {
  override var prefersStatusBarHidden: Bool { true }
  override var preferredStatusBarUpdateAnimation:
             UIStatusBarAnimation { .slide }
}

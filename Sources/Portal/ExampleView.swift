#if DEBUG
import SwiftUI

/// A demo view to showcase SheetShow Portal transitions
public struct ExampleView: View {
    @State private var showDetail = false

    public init() {}

    public var body: some View {
        PortalContainer {
            VStack {
                Spacer()

                Rectangle()
                    .fill(Color.red)
                    .frame(width: 100, height: 100)
                    .portalSource(id: "demo")
                    .onTapGesture { showDetail.toggle() }

                Spacer()
            }
            .sheet(isPresented: $showDetail) {
                Rectangle()
                    .fill(Color.red)
                    .frame(width: 200, height: 200)
                    .portalDestination(id: "demo")
                    .onTapGesture { showDetail.toggle() }
            }
            .portalTransition(id: "demo", animate: $showDetail, animation: .smooth) {
                Rectangle()
                    .fill(Color.red)
            }
        }
    }
}

struct ExampleView_Previews: PreviewProvider {
    static var previews: some View {
        ExampleView()
    }
}
#endif

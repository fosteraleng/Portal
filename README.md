# Portal

Portal is a SwiftUI package for seamless element transitions between views—including across sheets and navigation pushes—using a portal metaphor for maximum flexibility.

## **Overview**

![Example](/assets/example1.gif)

## Features

- `.portalSource(id:)` — Mark the view that is leaving (source anchor)
- `.portalDestination(id:)` — Mark the view that is arriving (destination anchor)
- `.portalTransition(id:animate:animation:delay:layer:completion:)` — Drive the floating overlay animation, with customizable animation and delay
- No custom presentation modifiers required
- Works on iOS 15+ and macOS 13+

## Installation

In Xcode: File → Add Packages → `https://github.com/Aeastr/Portal.git`

Or in `Package.swift`:

```swift
.package(url: "https://github.com/Aeastr/Portal.git", from: "1.0.0")
```

## Usage

Wrap your root view with `PortalContainer`:

```swift
import SwiftUI
import Portal

@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            PortalContainer {
                ContentView()
            }
        }
    }
}
```

Mark the source and destination views (the exact element to animate):

```swift
Image("cover")
    .portalSource(id: "Book1")
```

```swift
Image("cover")
    .portalDestination(id: "Book1")
```

Kick off the portal transition (typically on the parent container):

```swift
.portalTransition(
    id: "Book1",
    animate: $showDetail, // your binding
    animation: .spring(response: 0.7, dampingFraction: 0.6), // customizable
    delay: 0.1 // optional
) {
    FloatingLayerView()
}
```

See the `Sources/Portal` folder for full API details and example usage.

## Example

```swift
import SwiftUI
import Portal

struct DemoView: View {
    @State private var showDetail = false

    var body: some View {
        PortalContainer {
            VStack {
                Spacer()
                // The source view (the view that will animate out)
                Image(systemName: "star.fill")
                    .resizable()
                    .foregroundColor(.yellow)
                    .frame(width: 80, height: 80)
                    .portalSource(id: "star")
                    .onTapGesture { showDetail = true }
                Spacer()
            }
            .sheet(isPresented: $showDetail) {
                VStack {
                    // The destination view (the view that will animate in)
                    Image(systemName: "star.fill")
                        .resizable()
                        .foregroundColor(.yellow)
                        .frame(width: 180, height: 180)
                        .portalDestination(id: "star")
                        .onTapGesture { showDetail = false }
                    Text("Star Details")
                        .font(.title)
                        .padding()
                }
            }
            // The floating layer that animates between source and destination
            .portalTransition(
                id: "star",
                animate: $showDetail,
                animation: .spring(response: 0.7, dampingFraction: 0.6)
            ) {
                Image(systemName: "star.fill")
                    .resizable()
                    .foregroundColor(.yellow)
            }
        }
    }
}
```
How it works:

- Wrap your root view in PortalContainer.
- Attach .portalSource(id:) to the view you want to animate out.
- Attach .portalDestination(id:) to the view you want to animate in.
- Use .portalTransition(id:animate:animation:...) to provide the floating layer and control the animation.
You can use any SwiftUI view as your source/destination/floating layer—images, shapes, custom views, etc.

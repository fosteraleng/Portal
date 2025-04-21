# Portal

Portal is a SwiftUI package for seamless element transitions between views—including across sheets and navigation pushes—using a portal metaphor for maximum flexibility.

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

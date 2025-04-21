<div align="center">
  <img width="300" height="300" src="/assets/icon.png" alt="Portal Logo">
  <h1><b>Portal</b></h1>
  <p>
    Portal is a SwiftUI package for seamless element transitions between views—including across sheets and navigation pushes—using a portal metaphor for maximum flexibility.
    <br>
    <i>Compatible with iOS 15.0 and later</i>
  </p>
</div>

<div align="center">
  <a href="https://swift.org">
<!--     <img src="https://img.shields.io/badge/Swift-5.9%20%7C%206-orange.svg" alt="Swift Version"> -->
    <img src="https://img.shields.io/badge/Swift-5.9-orange.svg" alt="Swift Version">
  </a>
  <a href="https://www.apple.com/ios/">
    <img src="https://img.shields.io/badge/iOS-13%2B-blue.svg" alt="iOS">
  </a>
  <a href="LICENSE">
    <img src="https://img.shields.io/badge/License-MIT-green.svg" alt="License: MIT">
  </a>
</div>


> **⚠️ Work in Progress (v0.0.1)**
>
> Portal's API is still early, and behavior may change.  
> Known issues:
> - Shadows may flicker during animation
> - Customizing hide timing requires manual duration settings  
> - Edge cases around layout updates may not yet be fully handled  
>
> Use at your own risk and please report bugs or missing features on GitHub!

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
.package(url: "https://github.com/Aeastr/Portal.git", from: "0.0.1")
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

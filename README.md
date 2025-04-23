<div align="center">
  <img width="300" height="300" src="/assets/icon.png" alt="Portal Logo">
  <h1><b>Portal</b></h1>
  <p>
    Portal is a SwiftUI package for seamless element transitions between views—including across sheets and navigation pushes (NavigationStack, .navigationDestination, etc)—using a portal metaphor for maximum flexibility.
    <br>
    <i>Compatible with iOS 15.0 and later</i>
  </p>
</div>

<div align="center">
  <a href="https://swift.org">
<!--     <img src="https://img.shields.io/badge/Swift-5.9%20%7C%206-orange.svg" alt="Swift Version"> -->
    <img src="https://img.shields.io/badge/Swift-5.7-orange.svg" alt="Swift Version">
  </a>
  <a href="https://www.apple.com/ios/">
    <img src="https://img.shields.io/badge/iOS-15%2B-blue.svg" alt="iOS">
  </a>
  <a href="LICENSE">
    <img src="https://img.shields.io/badge/License-MIT-green.svg" alt="License: MIT">
  </a>
</div>

## **Demo**

![Example](/assets/example1.gif)

<details>
  <summary><strong>Real Examples</strong></summary>

  https://github.com/user-attachments/assets/1658216e-dabd-442f-a7fe-7c2a19bf427d

  https://github.com/user-attachments/assets/7bba5836-f6e0-4d0b-95d7-f2c44c86c80a
</details>

## Features

- **`PortalContainer(hideStatusBar:) { ... }`**  
  Manages overlay window logic for floating portal animations. The `hideStatusBar` parameter controls whether the status bar is hidden when the overlay is active.

- **`.portalContainer(hideStatusBar:)`**  
  View extension for easily wrapping any view in a portal container, with optional status bar hiding.

- **`.portalSource(id:)`**  
  Marks a view as the source anchor for portal transitions.

- **`.portalDestination(id:)`**  
  Marks a view as the destination anchor for portal transitions.

- **`.portalTransition(id: animate: animation: animationDuration: delay: layer: completion:)`**  
  Drives the floating overlay animation, with options for animation type, duration, delay, layering, and completion handling.

- **No custom presentation modifiers required**  
  Works directly with standard SwiftUI views.

- **iOS 15+ support**


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

struct ExampleView: View {
    @State private var showDetail = false

    var body: some View {
        PortalContainer {
            VStack {
                // Source image in the main view
                Image("cover")
                    .onTapGesture {
                        showDetail = true
                    }
            }
            // Present the destination in a sheet
            .sheet(isPresented: $showDetail) {
                // Destination image in the sheet
                Image("cover")
                    .portalDestination(id: "Book1")
            }
        }
    }
}
```

Mark the source view (the element to animate from):

```swift
Image("cover")
    .portalSource(id: "Book1")
```

Mark the destination view (the element to animate to, typically in a sheet or detail view):

```swift
Image("cover")
    .portalDestination(id: "Book1")
```

Kick off the portal transition:

```swift
.portalTransition(
    id: "Book1",
    animate: $showDetail, // your binding
    animation: .smooth(duration: 0.6), // customizable
    animationDuration: 0.6, // required as the animation duration isn't exposed, and transition requires it
    delay: 0.1 // optional
) {
    FloatingLayerView()
}
```

All together, 

```swift
import SwiftUI
import Portal

struct ExampleView: View {
    @State private var showDetail = false

    var body: some View {
        PortalContainer {
            VStack {
                // Source image in the main view
                Image("cover")
                    .portalSource(id: "Book1")
                    .onTapGesture {
                        showDetail = true
                    }
            }
            // Present the destination in a sheet
            .sheet(isPresented: $showDetail) {
                // Destination image in the sheet
                Image("cover")
                    .portalDestination(id: "Book1")
            }
            // Attach the portal transition to the parent container
            .portalTransition(
                id: "Book1",
                animate: $showDetail, // your binding
                animation: .smooth(duration: 0.6), // customizable
                animationDuration: 0.6, // required as the animation duration isn't exposed, and transition requires it
                delay: 0.1 // optional
            ) {
                // The floating overlay content during the transition
                Image("cover")
            }
        }
    }
}
```

See the `Sources/Portal` folder for full API details and example usage.

### Summary:

- Wrap your root view in PortalContainer.
- Attach .portalSource(id:) to the view you want to animate out.
- Attach .portalDestination(id:) to the view you want to animate in.
- Use .portalTransition(id:animate:animation:...) to provide the floating layer and control the animation.
You can use any SwiftUI view as your source/destination/floating layer—images, shapes, custom views, etc.

## 🌀 Custom Portal Transitions

### Creating a Scale Effect Transition

This guide shows how to create a custom transition that scales up and bounces when the portal activates. We'll create a reusable view that handles the scale animation.

#### 1. **Define Animation Constants**

First, set up your animation parameters:

```swift
let transitionDuration: TimeInterval = 0.4

let scaleAnimation = Animation.smooth(
    duration: transitionDuration, 
    extraBounce: 0.25
)

let bounceAnimation = Animation.smooth(
    duration: transitionDuration + 0.12, 
    extraBounce: 0.55
)
```

#### 2. **Create a Custom Transition View**

Create a view that manages the scale animation:

```swift
struct ScaleTransitionView<Content: View>: View {
    @EnvironmentObject private var portalModel: CrossModel
    let id: String
    @ViewBuilder let content: () -> Content

    @State private var scale: CGFloat = 1

    var body: some View {
        let isActive = portalModel.info
            .first(where: { $0.infoID == id })?
            .animateView ?? false

        content()
            .scaleEffect(scale)
            .onAppear { scale = 1 }
            .onChangeCompat(of: isActive) { newValue in
                if newValue {
                    // Scale up
                    withAnimation(scaleAnimation) {
                        scale = 1.25
                    }
                    
                    // Bounce back
                    DispatchQueue.main.asyncAfter(
                        deadline: .now() + (transitionDuration / 2) - 0.1
                    ) {
                        withAnimation(bounceAnimation) {
                            scale = 1
                        }
                    }
                } else {
                    // Reset scale
                    withAnimation { scale = 1 }
                }
            }
    }
}
```

#### 3. **Use the Transition in Your Views**

Apply the transition to your portal source, destination, and transition views:

```swift
// Source view
ScaleTransitionView(id: "myPortal") {
    RoundedRectangle(cornerRadius: 16)
        .fill(gradient)
}
.frame(width: 100, height: 100)
.portalSource(id: "myPortal")

// Destination view
ScaleTransitionView(id: "myPortal") {
    RoundedRectangle(cornerRadius: 16)
        .fill(gradient)
}
.frame(width: 220, height: 220)
.portalDestination(id: "myPortal")

// Transition
.portalTransition(
    id: "myPortal",
    animate: $isShowing,
    animation: scaleAnimation,
    animationDuration: transitionDuration
) {
    ScaleTransitionView(id: "myPortal") {
        RoundedRectangle(cornerRadius: 16)
            .fill(gradient)
    }
}
```

### Summary

1. The `ScaleTransitionView` observes the portal's state through the `portalModel`.
2. When the portal activates:
   - The view scales up to 1.25x with a smooth animation
   - After a brief delay, it bounces back to 1.0x with extra bounce
3. When the portal deactivates, the scale smoothly returns to 1.0x

### Tips for Customization

- Adjust the `scale` values (1.25) to change the intensity of the effect
- Modify the animation timing and bounce parameters
- Add additional transforms like rotation or opacity
- Combine with other effects for more complex transitions

> **Note:**  
> This is just one way to create custom transitions. The portal system is flexible and allows for many different animation approaches. A more declarative API for transitions is in development - this is temporary.

---

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## Support

If you like this project, please consider giving it a ⭐️

## Where to find me:  
- here, obviously.  
- [Twitter](https://x.com/AetherAurelia)  
- [Threads](https://www.threads.net/@aetheraurelia)  
- [Bluesky](https://bsky.app/profile/aethers.world)  
- [LinkedIn](https://www.linkedin.com/in/willjones24)

---

<p align="center">Built with <3 by Aether</p>



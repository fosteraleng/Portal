#if DEBUG
import SwiftUI

@available(iOS 18.0, *)
/// A demo view to showcase SheetShow Portal transitions and iOS 18 transitions
public struct Portal_DifferExample: View {
    @State private var showDetailRed = false
    @State private var showDetailPurple = false
    @State private var useMatchingColors = true

    @Namespace private var transitionNamespace

    private let redGradient = [
        Color(red: 0.98, green: 0.36, blue: 0.35),
        Color(red: 0.92, green: 0.25, blue: 0.48)
    ]
    private let purpleGradient = [
        Color(red: 0.6, green: 0.4, blue: 0.9),
        Color(red: 0.4, green: 0.2, blue: 0.8)
    ]
    private let alternateGradient1 = [
        Color(red: 0.3, green: 0.8, blue: 0.5),
        Color(red: 0.1, green: 0.6, blue: 0.4)
    ]

    public init() {}

    @available(iOS 18.0, *)
    public var body: some View {
        NavigationView {
            PortalContainer {
                ScrollView {
                    VStack(spacing: 24) {

                        Text("Demo: Custom Portal (Red) & iOS 18 Zoom (Purple)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .padding(.horizontal)
                            .multilineTextAlignment(.center)

                        Text("Tap either shape to expand it")
                            .font(.subheadline)
                            .foregroundColor(.secondary)

                        HStack(spacing: 30) {
                            VStack {
                                AnimatedLayer(id: "demo1") {
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(
                                            LinearGradient(
                                                gradient: Gradient(colors: redGradient),
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                }
                                .frame(width: 100, height: 100)
                                .portalSource(id: "demo1")
                                .onTapGesture { withAnimation(animationExample) { showDetailRed.toggle() } }

                                Text("Cross-View (Portal)")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }

                            
                            VStack {
                                
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(
                                            LinearGradient(
                                                gradient: Gradient(colors: purpleGradient),
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                
                                .frame(width: 100, height: 100)
                                
                                .matchedTransitionSource(id: "demo2_shape", in: transitionNamespace)
                                .onTapGesture {
                                    withAnimation(.smooth) { showDetailPurple.toggle() }
                                }

                                Text("navigationTransition (SwiftUI)")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }

                    }
                    .frame(maxWidth: .infinity)
                }
                .safeAreaInset(edge: .bottom, content: {
                    // Toggle section - Keep for red portal example
                    VStack(alignment: .leading, spacing: 12) {
                        Toggle(isOn: $useMatchingColors) {
                            VStack(alignment: .leading){
                                Text("Use matching colors for Red Portal")
                                Text(
                                    useMatchingColors
                                    ? "Red elements match for smooth portal transition"
                                    : "Red elements differ to show portal transition break"
                                )
                                .font(.caption)
                                .foregroundColor(.secondary)
                            }
                        }
                    }
                    .padding(.vertical, 18)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 12)
                    .background{
                        Color(.systemGray6)
                            .clipShape(.rect(cornerRadius: 20))
                            .ignoresSafeArea()
                    }
                })

                // First sheet (red square) - Unchanged (Uses Custom Portal)
                .sheet(isPresented: $showDetailRed) {
                    ScrollView {
                        VStack(spacing: 24) {
                            Text("Red Square Expanded (Custom Portal)")
                                .font(.title2)
                                .fontWeight(.bold)
                                .padding(.top, 16)
                            Spacer().frame(height: 30)
                            AnimatedLayer(id: "demo1") {
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(
                                        LinearGradient(
                                            gradient: Gradient(colors: redGradient),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                            }
                            .frame(width: 220, height: 220)
                            .portalDestination(id: "demo1") // Use custom portal destination
                            .onTapGesture { withAnimation(animationExample) { showDetailRed.toggle() } }
                            Spacer().frame(height: 30)
                            Text("Tap to collapse")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .padding(.bottom, 40)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                    }
                    .background(Color(UIColor.systemGroupedBackground))
                }

                // Second sheet (purple square) - MODIFIED for iOS 18 Transition
                .sheet(isPresented: $showDetailPurple) {
                    ScrollView {
                        VStack(spacing: 24) {
                            Text("Purple Square Expanded (iOS 18 Zoom)")
                                .font(.title2)
                                .fontWeight(.bold)
                                .padding(.top, 16)
                            Spacer().frame(height: 30)

                                RoundedRectangle(cornerRadius: 16)
                                    .fill(
                                        LinearGradient(
                                            gradient: Gradient(colors: purpleGradient),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                            
                            .frame(width: 220, height: 220)
                            .onTapGesture {
                                withAnimation(.smooth) { showDetailPurple.toggle() }
                            }

                            Spacer().frame(height: 30)
                            Text("Tap to collapse")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .padding(.bottom, 40)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                    }
                    .background(Color(UIColor.systemGroupedBackground))
                    .navigationTransition(.zoom(sourceID: "demo2_shape", in: transitionNamespace))
                }

                .portalTransition(
                    id: "demo1",
                    animate: $showDetailRed,
                    animation: animationExample,
                    animationDuration: animationDuration
                ) {
                    AnimatedLayer(id: "demo1") {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: useMatchingColors ? redGradient : alternateGradient1),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                    }
                }


            }
            
            .navigationTitle("Mixed Transitions Demo")
        }
    }
}

#endif

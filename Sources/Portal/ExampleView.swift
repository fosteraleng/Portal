#if DEBUG
import SwiftUI

/// A demo view to showcase SheetShow Portal transitions
public struct ExampleView: View {
    @State private var showDetailRed = false
    @State private var showDetailPurple = false
    @State private var useMatchingColors = true
    
    // Different gradient sets
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
    
    private let alternateGradient2 = [
        Color(red: 0.95, green: 0.6, blue: 0.2),
        Color(red: 0.9, green: 0.4, blue: 0.1)
    ]
    
    public init() {}
    
    public var body: some View {
        PortalContainer {
            ScrollView {
                VStack(spacing: 24) {
                    Text("Portal Transition Demo")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.top, 16)
                    
                    // Explanation section
                    Text("This demo shows how multiple portal transitions can work simultaneously.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .padding(.horizontal)
                        .multilineTextAlignment(.center)
                    
                    // Toggle for matching/different colors
                    VStack(alignment: .leading, spacing: 12) {
                        Toggle("Use matching colors for all elements", isOn: $useMatchingColors)
                            .padding(.horizontal)
                        
                        Text(useMatchingColors
                             ? "All elements have the same appearance for smooth transitions"
                             : "Elements have different colors to show how transitions can break")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .padding(.horizontal)
                    }
                    .padding(.vertical, 12)
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    .padding(.horizontal)
                    
                    Spacer().frame(height: 24)
                    
                    Text("Tap either shape to expand it")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    // Two squares side by side
                    HStack(spacing: 30) {
                        // First square (red)
                        VStack {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(LinearGradient(
                                    gradient: Gradient(colors: redGradient),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ))
                                .frame(width: 100, height: 100)
                                .portalSource(id: "demo1")
                                .onTapGesture { withAnimation { showDetailRed.toggle() } }
                            
                            Text("Portal 1")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        // Second square (purple)
                        VStack {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(LinearGradient(
                                    gradient: Gradient(colors: purpleGradient),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ))
                                .frame(width: 100, height: 100)
                                .portalSource(id: "demo2")
                                .onTapGesture { withAnimation { showDetailPurple.toggle() } }
                            
                            Text("Portal 2")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    Spacer().frame(height: 30)
                    
                    Text("Each portal operates independently with its own transition")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                        .padding(.bottom, 40)
                }
                .frame(maxWidth: .infinity)
            }
            
            // First sheet (red square)
            .sheet(isPresented: $showDetailRed) {
                ScrollView {
                    VStack(spacing: 24) {
                        Text("Red Square Expanded")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.top, 16)
                        
                        Spacer().frame(height: 30)
                        
                        // Destination element for first square
                        RoundedRectangle(cornerRadius: 16)
                            .fill(LinearGradient(
                                gradient: Gradient(colors: useMatchingColors ? redGradient : alternateGradient1),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ))
                            .frame(width: 220, height: 220)
                            .portalDestination(id: "demo1")
                            .onTapGesture { withAnimation { showDetailRed.toggle() } }
                        
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
            
            // Second sheet (purple square)
            .sheet(isPresented: $showDetailPurple) {
                ScrollView {
                    VStack(spacing: 24) {
                        Text("Purple Square Expanded")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.top, 16)
                        
                        Spacer().frame(height: 30)
                        
                        // Destination element for second square
                        RoundedRectangle(cornerRadius: 16)
                            .fill(LinearGradient(
                                gradient: Gradient(colors: useMatchingColors ? purpleGradient : alternateGradient2),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ))
                            .frame(width: 220, height: 220)
                            .portalDestination(id: "demo2")
                            .onTapGesture { withAnimation { showDetailPurple.toggle() } }
                        
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
            
            // Transition for first square (red)
            .portalTransition(id: "demo1", animate: $showDetailRed) {
                RoundedRectangle(cornerRadius: 16)
                    .fill(LinearGradient(
                        gradient: Gradient(colors: useMatchingColors ? redGradient : alternateGradient1),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ))
            }
            
            // Transition for second square (purple)
            .portalTransition(id: "demo2", animate: $showDetailPurple) {
                RoundedRectangle(cornerRadius: 16)
                    .fill(LinearGradient(
                        gradient: Gradient(colors: useMatchingColors ? purpleGradient : alternateGradient2),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ))
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

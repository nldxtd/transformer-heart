import SwiftUI

struct NavigationButton: View {
    let icon: String
    let action: () -> Void
    let isDisabled: Bool
    
    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(isDisabled ? .gray.opacity(0.5) : .white)
                .frame(width: 32, height: 32)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(isDisabled ? Color.gray.opacity(0.2) : Color.green.opacity(0.8))
                        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                )
        }
        .buttonStyle(NavigationButtonStyle())
        .disabled(isDisabled)
    }
}

struct NavigationButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
    }
}

// Add zoom reset button
struct ZoomResetButton: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: "arrow.counterclockwise")
                .foregroundColor(.white)
                .padding(8)
                .background(Color.blue)
                .clipShape(Circle())
                .shadow(radius: 3)
        }
    }
}

struct GPTIllustrationView: View {

    @State private var currentView = "Transformer Overview"
    @Namespace private var animationNamespace
    @State private var scale: CGFloat = 0.7
    @State private var offset: CGSize = CGSize(width: -170, height: -30)
    @State private var lastOffset: CGSize = .zero
    @State private var indexSelected: Int = Int.random(in: 0..<7)

    let pipelineNames = [
        "Transformer Overview",
        "Embedding Pipeline",
        "KQV Matrix Pipeline",
        "Cross Attention Pipeline",
        "Feed-Forward Network Pipeline",
        "Prediction Pipeline",
    ]

    var body: some View {     
        ZStack(alignment: .top)  { 
            if currentView == "Transformer Overview" {
                OverviewView(currentView: $currentView, animationNamespace: animationNamespace, scale: $scale, offset: $offset, lastOffset: $lastOffset, indexSelected: $indexSelected)
                VStack {
                    HStack {
                        // Chat-like input box
                        HStack(spacing: 0) {
                            Text("Transformer visualization empowers user to ")
                                .font(.system(size: 18))
                            Text(constTokenLabels[indexSelected])
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(.purple)
                        }
                        .padding(.vertical, 16)
                        .padding(.horizontal, 24)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.white)
                                .shadow(
                                    color: Color.black.opacity(0.1),
                                    radius: 8,
                                    x: 0,
                                    y: 2
                                )
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                        )

                        ZoomResetButton {
                            withAnimation {
                                indexSelected = Int.random(in: 0..<7)
                                scale = 0.7
                                offset = CGSize(width: -170, height: -30)
                                lastOffset = .zero
                            }
                        }
                    }
                    Spacer()
                }
                .padding(.top, 20)
            } else if currentView == "Embedding Pipeline" {
                InputEmbeddingView(
                    currentView: $currentView, animationNamespace: animationNamespace)
            } else if currentView == "KQV Matrix Pipeline" {
                AttentionQKVView(
                    currentView: $currentView, animationNamespace: animationNamespace)
            } else if currentView == "Cross Attention Pipeline" {
                SingleAttentionHeadView(
                    currentView: $currentView, animationNamespace: animationNamespace)
            } else if currentView == "Feed-Forward Network Pipeline" {
                TransformerFFNView(
                    currentView: $currentView, animationNamespace: animationNamespace)
            } else if currentView == "Prediction Pipeline" {
                ProbabilityOutputView(
                    currentView: $currentView, animationNamespace: animationNamespace)
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack(spacing: 16) {
                    HStack(spacing: 8) {
                        NavigationButton(
                            icon: "chevron.left",
                            action: {
                                let curIdx = pipelineNames.firstIndex(of: currentView)!
                                currentView = pipelineNames[curIdx == 0 ? 0 : curIdx - 1]
                            },
                            isDisabled: currentView == "Transformer Overview"
                        )
                        
                        NavigationButton(
                            icon: "house.fill",
                            action: {
                                currentView = "Transformer Overview"
                            },
                            isDisabled: currentView == "Transformer Overview"
                        )
                        
                        NavigationButton(
                            icon: "chevron.right",
                            action: {
                                let curIdx = pipelineNames.firstIndex(of: currentView)!
                                currentView = pipelineNames[
                                    curIdx == pipelineNames.count - 1
                                        ? pipelineNames.count - 1 : curIdx + 1]
                            },
                            isDisabled: currentView == "Prediction Pipeline"
                        )
                    }
                    .padding(8)
                    
                    Divider()
                        .frame(height: 24)
                        .padding(.horizontal, 8)
                    
                    NavigationButton(
                        icon: "info.circle",
                        action: { },
                        isDisabled: false
                    )
                }
                .padding(.horizontal)
            }
            
            ToolbarItem(placement: .principal) {
                Text(currentView)
                    .font(.system(.headline, design: .rounded))
                    .foregroundColor(.primary)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 16)
                    .background(
                        Capsule()
                            .fill(Color.blue.opacity(0.1))
                    )
            }
        }
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarBackground(Color.white.opacity(0.95), for: .navigationBar)
        .animation(.easeInOut, value: currentView)
    }
}

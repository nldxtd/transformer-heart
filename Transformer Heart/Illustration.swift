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

    @State private var currentView = "Model Overview"
    @Namespace private var animationNamespace
    @State private var scale: CGFloat = 0.7
    @State private var offset: CGSize = CGSize(width: -190, height: -30)
    @State private var lastOffset: CGSize = .zero
    @State private var indexSelected: Int = Int.random(in: 0..<7)

    // @AppStorage("hasSeenGuide") private var hasSeenGuide = false
    @State private var showingGuide = false
    @State private var selectedComponent: ModelComponent = .embedding

    let pipelineNames = [
        "Model Overview",
        "Embedding Layer",
        "KQV Matrix Pipeline",
        "Cross Attention Pipeline",
        "Feed-Forward Network Pipeline",
        "Prediction Pipeline",
    ]

    var body: some View {     
        ZStack  { 

            ZStack(alignment: .center) {
                if currentView == "Model Overview" {
                    OverviewView(currentView: $currentView, animationNamespace: animationNamespace, scale: $scale, offset: $offset, lastOffset: $lastOffset, indexSelected: $indexSelected, selectedComponent: $selectedComponent)
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
                                    offset = CGSize(width: -190, height: -30)
                                    lastOffset = .zero
                                }
                            }
                        }
                        Spacer()
                    }
                    .padding(.top, 20)
                } else if currentView == "Embedding Layer" {
                    InputEmbeddingView(
                        currentView: $currentView, animationNamespace: animationNamespace, selectedComponent: $selectedComponent)
                } else if currentView == "KQV Matrix Pipeline" {
                    AttentionQKVView(
                        currentView: $currentView, animationNamespace: animationNamespace, selectedComponent: $selectedComponent)
                } else if currentView == "Cross Attention Pipeline" {
                    SingleAttentionHeadView(
                        currentView: $currentView, animationNamespace: animationNamespace, selectedComponent: $selectedComponent)
                } else if currentView == "Feed-Forward Network Pipeline" {
                    TransformerFFNView(
                        currentView: $currentView, animationNamespace: animationNamespace, selectedComponent: $selectedComponent)
                        .scaleEffect(0.9)
                } else if currentView == "Prediction Pipeline" {
                    ProbabilityOutputView(
                        currentView: $currentView, animationNamespace: animationNamespace, selectedComponent: $selectedComponent)
                        .scaleEffect(0.9)
                }
            }
            
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    ExpandableBottomSheet(selectedComponent: $selectedComponent)
                        .padding(.trailing, 40)
                        .padding(.bottom, 10)
                }
            }
            .ignoresSafeArea()
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
                            isDisabled: currentView == "Model Overview"
                        )
                        
                        NavigationButton(
                            icon: "house.fill",
                            action: {
                                currentView = "Model Overview"
                            },
                            isDisabled: currentView == "Model Overview"
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
                        action: {
                            showingGuide = true
                        },
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
        .onAppear {
            showingGuide = true
        }
        .sheet(isPresented: $showingGuide) {
            GuideView()
        }
    }
}

struct GuideView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 25) {
                    // Title
                    Text("Welcome to Transformer Visualization")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    // Transformer Introduction Section
                    VStack(alignment: .leading, spacing: 15) {
                        Text("What is a Transformer?")
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        Text("Transformer is a neural network architecture that has fundamentally changed the approach to Artificial Intelligence. Transformer was first introduced in the seminal paper 'Attention is All You Need' in 2017 and has since become the go-to architecture for deep learning models, powering text-generative models like OpenAI's GPT, Meta's Llama, and Google's Gemini.")
                            .font(.body)
                            .foregroundColor(.secondary)
                        
                        Text("Fundamentally, text-generative Transformer models operate on the principle of next-word prediction: given a text prompt from the user, what is the most probable next word that will follow this input? The core innovation and power of Transformers lie in their use of self-attention mechanism, which allows them to process entire sequences and capture long-range dependencies more effectively than previous architectures. We illustrate this process using GPT-2 which is not the latest model but shares common architecture and components with SOTA models.")
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.blue.opacity(0.1))
                    )
                    
                    // Interaction Guide Section
                    VStack(alignment: .leading, spacing: 20) {
                        Text("How to Interact")
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        VStack(alignment: .leading, spacing: 15) {
                            GuideItem(
                                icon: "hand.draw.fill",
                                title: "Zoom & Drag",
                                text: "The model architecture can be zoomed and dragged to serve your best observation"
                            )
                            
                            GuideItem(
                                icon: "hand.tap.fill",
                                title: "Interactive Elements",
                                text: "Everything is clickable! Click on any element that makes you confused to learn more"
                            )
                            
                            GuideItem(
                                icon: "arrow.left.and.right.square.fill",
                                title: "Step-by-Step",
                                text: "Follow the visualization to understand how Transformer processes and predicts the next token"
                            )
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.green.opacity(0.1))
                    )
                    
                    // Dismiss Button
                    Button("Start Exploring") {
                        dismiss()
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(width: 200, height: 44)
                    .background(Color.blue)
                    .cornerRadius(10)
                }
                .padding()
            }
        }
    }
}

struct GuideItem: View {
    let icon: String
    let title: String
    let text: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 15) {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .font(.title3)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                Text(text)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
    }
}

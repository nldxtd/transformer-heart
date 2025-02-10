import SwiftUI

struct IllustrationView: View {

    @State private var currentView = "Transformer Overview"
    @Namespace private var animationNamespace

    let pipelineNames = [
        "Embedding Pipeline",
        "KQV Matrix Pipeline",
        "Cross Attention Pipeline",
        "Feed-Forward Network Pipeline",
        "Prediction Pipeline",
    ]

    var body: some View {
        VStack {
            // menu bar
            HStack {
                HStack(spacing: 30) {
                    Button(action: {
                        let curIdx = pipelineNames.firstIndex(of: currentView)!
                        currentView = pipelineNames[curIdx == 0 ? 0 : curIdx - 1]
                    }) {
                        Image(systemName: "triangle.fill")
                            .rotationEffect(.degrees(-90))
                            .foregroundColor(
                                (currentView == "Transformer Overview"
                                    || currentView == "Embedding Pipeline") ? .gray : .blue)
                    }
                    .disabled(
                        currentView == "Transformer Overview" || currentView == "Embedding Pipeline"
                    )

                    Button(action: {
                        currentView = "Transformer Overview"
                    }) {
                        Image(systemName: "house.fill")
                            .foregroundColor(
                                (currentView == "Transformer Overview") ? .gray : .blue)
                    }
                    .disabled(currentView == "Transformer Overview")

                    Button(action: {
                        let curIdx = pipelineNames.firstIndex(of: currentView)!
                        currentView =
                            pipelineNames[
                                curIdx == pipelineNames.count - 1
                                    ? pipelineNames.count - 1 : curIdx + 1]
                    }) {
                        Image(systemName: "triangle.fill")
                            .rotationEffect(.degrees(90))
                            .foregroundColor(
                                (currentView == "Transformer Overview"
                                    || currentView == "Prediction Pipeline") ? .gray : .blue)
                    }
                    .disabled(
                        currentView == "Transformer Overview"
                            || currentView == "Prediction Pipeline")
                }
                .frame(maxWidth: .infinity)
                .overlay(
                    HStack {
                        Text(currentView)
                            .foregroundColor(.white)
                            .padding()  // Aligns to leading edge

                        Spacer()

                        Button(action: {
                        }) {
                            Image(systemName: "info.circle.fill")
                                .foregroundColor(.blue)
                        }
                        .padding()  // Aligns to trailing edge
                    }
                )
            }
            .padding()
            .background(Color.gray.opacity(0.2))

            HStack {
                Spacer()
                VStack {
                    Spacer()
                    if currentView == "Transformer Overview" {
                        OverviewView(
                            currentView: $currentView, animationNamespace: animationNamespace)
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
                    Spacer()
                }
                Spacer()
            }
        }
        .animation(.easeInOut, value: currentView)  // Smooth transition
    }
}

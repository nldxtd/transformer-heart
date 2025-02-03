import SwiftUI

struct IllustrationView: View {
    
    @State private var currentView = "EmbeddingPipeline"
    @Namespace private var animationNamespace
    
    var body: some View {
        VStack {
            if currentView == "EmbeddingPipeline" {
                InputEmbeddingView(currentView: $currentView, animationNamespace: animationNamespace)
            } else if currentView == "AttentionKQVPipeline" {
                AttentionQKVView(currentView: $currentView, animationNamespace: animationNamespace)
            } else if currentView == "AttentionHeadPipiline" {
                SingleAttentionHeadView(currentView: $currentView, animationNamespace: animationNamespace)
            } else if currentView == "FeedForwardPipeline" {
                TransformerFFNView(currentView: $currentView, animationNamespace: animationNamespace)
            }
            HStack(spacing: 10) {
                Button(action: {
                    withAnimation(.easeInOut(duration: 2.0)) { // 设置持续时间为 1 秒
                        currentView = "EmbeddingPipeline"
                    }
                }) {
                    Text("Go to embedding")
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                Button(action: {
                    withAnimation(.easeInOut(duration: 2.0)) { // 设置持续时间为 1 秒
                        currentView = "AttentionKQVPipeline"
                    }
                }) {
                    Text("Go to kqv")
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                Button(action: {
                    withAnimation(.easeInOut(duration: 2.0)) { // 设置持续时间为 1 秒
                        currentView = "AttentionHeadPipiline"
                    }
                }) {
                    Text("Go to head")
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                Button(action: {
                    withAnimation(.easeInOut(duration: 2.0)) { // 设置持续时间为 1 秒
                        currentView = "FeedForwardPipeline"
                    }
                }) {
                    Text("Go to ffn")
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .padding()
        }
        .animation(.easeInOut, value: currentView) // Smooth transition
    }
}

import SwiftUI

struct InputEmbeddingView: View {
    @State private var embeddingMatrix: VectorListViewModel = VectorListViewModel(matrixWeight: embeddingMatrixWeight)
    @State private var isHorizontal = true // Toggle between horizontal and vertical views
    @State private var showComponents = [false, false, false, false] // Controls visibility of components
    @State private var isMatrixMode = false // Controls the mode of embedding output
    
    @Binding var currentView: String
    var animationNamespace: Namespace.ID
    @Binding var selectedComponent: ModelComponent

    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            Text("Input Sentence")
                .font(.headline)
            // Example prompt
            Text("\"Data visualization empowers users to\"")
                .font(.system(.body, design: .monospaced))
                .padding(12)
                .background(Color.blue.opacity(0.1))
                .cornerRadius(8)

            Image(systemName: "arrow.down")
                .frame(width: 30, height: 30)
            HStack(spacing: 20) {

                TokenList(tokens: tokens, title: "Tokenization", isHorizontal: isHorizontal)
                    .animation(.easeInOut(duration: 0.5), value: isHorizontal)
                    .onTapGesture {
                        selectedComponent = .tokenization
                    }

                if !isHorizontal {
                    HStack{
                        if showComponents[0] {
                            HStack(spacing: 20) {
                                // Arrow column
                                Image(systemName: "arrow.right")
                                    .frame(width: 30, height: 30)
                                
                                // Final Embedding
                                VectorList(dimention: 10, vectors: embeddingMatrix, labels: embeddingMatrixWeight, color: .green, title: "Token Embedding")
                            }
                            .opacity(showComponents[0] ? 1 : 0)
                            .offset(x: showComponents[0] ? 0 : -30)
                            .animation(.easeInOut(duration: 0.5), value: showComponents[0])
                            .onTapGesture {
                                selectedComponent = .tokenEmbedding
                            }
                        }

                        if showComponents[1] {
                            HStack(spacing: 20) {
                                // Plus sign column
                                Text("+")
                                    .font(.title2)
                                    .frame(width: 30, height: 30)
                                
                                // Position Encoding
                                VectorList(dimention: 10, vectors: embeddingMatrix, labels: embeddingMatrixWeight, color: .orange, title: "Positional Encoding")                            }
                            .opacity(showComponents[1] ? 1 : 0)
                            .offset(x: showComponents[1] ? 0 : -30)
                            .animation(.easeInOut(duration: 0.5), value: showComponents[1])
                            .onTapGesture {
                                selectedComponent = .positionEncoding
                            }
                        }

                        if showComponents[2] {
                            HStack(spacing: 20) {
                                Text("=")
                                    .font(.title2)
                                    .frame(width: 30, height: 30)
                                
                                VectorList(
                                    dimention: 10,
                                    vectors: embeddingMatrix,
                                    labels: embeddingMatrixWeight,
                                    color: .gray,
                                    defaultWidth: isMatrixMode ? 12 : 10,
                                    defaultHeight: isMatrixMode ? 13 : 30,
                                    spacing: isMatrixMode ? 2 : 16,
                                    title: isMatrixMode ? "Final Embedding" : "Embedding Output",
                                    matrixMode: isMatrixMode
                                )
                                .matchedGeometryEffect(id: "EmbeddingMatrix", in: animationNamespace)
                            }
                            .opacity(showComponents[2] ? 1 : 0)
                            .offset(x: showComponents[2] ? 0 : -30)
                            .animation(.easeInOut(duration: 0.5), value: showComponents[2])
                            .animation(.spring(duration: 0.3), value: isMatrixMode)
                            .onTapGesture {
                                selectedComponent = .finalEmbedding
                            }
                        }
                    }
                    .transition(.move(edge: .leading).combined(with: .opacity))
                }
            }
        }
        .offset(y: -80)
        .onAppear {
            selectedComponent = .embedding
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                isHorizontal = false
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                showComponents[0] = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                showComponents[1] = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                showComponents[2] = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                isMatrixMode = true
            }
        }
    }
}

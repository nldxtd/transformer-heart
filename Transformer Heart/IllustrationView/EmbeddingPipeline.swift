import SwiftUI

/// Todo
/// Modify the hard-encoding of the embeddingWeight, turn into dictionary
/// Modify the bezeir curve part on the screen, still got some bugs in the coordinates
/// Add detail in the graph and

struct InputEmbeddingView: View {
    @State private var embeddingMatrix: VectorListViewModel = VectorListViewModel(matrixWeight: embeddingMatrixWeight)
    @State private var isHorizontal = true // Toggle between horizontal and vertical views
    @State private var showComponents = [false, false, false, false] // Controls visibility of components
    @State private var isMatrixMode = false // Controls the mode of embedding output
    @State private var animationEnded = true
    
    @Binding var currentView: String
    var animationNamespace: Namespace.ID

    private func revealComponents() {
        guard !isHorizontal else { return }
        for index in showComponents.indices {
            let delay = Double(index)
            withAnimation(.easeInOut(duration: 0.5).delay(delay)) {
                showComponents[index] = true
            }
        }

        // Calculate the total time for all animations to complete
        let totalDuration = Double(showComponents.count)-0.5
        DispatchQueue.main.asyncAfter(deadline: .now() + totalDuration) {
            isMatrixMode = true
            animationEnded = true  // Set the flag to true when all animations finish
        }
    }

    private func hideComponents() {
        showComponents = [false, false, false, false]
        animationEnded = true
        isMatrixMode = false
    }

    var body: some View {
        ZStack {
            HStack(spacing: 20) {
                TokenList(tokens: tokens, title: "Input Tokens", isHorizontal: isHorizontal)
                    .offset(y: -28)
                    .animation(.easeInOut(duration: 0.5), value: isHorizontal)

                if !isHorizontal {
                    HStack{
                        if showComponents[0] {
                            HStack(spacing: 20) {
                                // Arrow column
                                Image(systemName: "arrow.right")
                                    .frame(width: 30, height: 30)
                                
                                // Embedding Matrix
                                VectorList(dimention: 10, vectors: embeddingMatrix, labels: embeddingMatrixWeight, color: .green, title: "Token Embedding")
                                    .offset(y: -28)
                            }
                            .opacity(showComponents[0] ? 1 : 0)
                            .offset(x: showComponents[0] ? 0 : -30)
                            .animation(.easeInOut(duration: 0.5), value: showComponents[0])
                        }

                        if showComponents[1] {
                            HStack(spacing: 20) {
                                // Plus sign column
                                Text("+")
                                    .font(.title2)
                                    .frame(width: 30, height: 30)
                                
                                // Position Encoding
                                VectorList(dimention: 10, vectors: embeddingMatrix, labels: embeddingMatrixWeight, color: .orange, title: "Positional Encoding")
                                    .offset(y: -28)
                            }
                            .opacity(showComponents[1] ? 1 : 0)
                            .offset(x: showComponents[1] ? 0 : -30)
                            .animation(.easeInOut(duration: 0.5), value: showComponents[1])
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
                                    title: isMatrixMode ? "Embedding Matrix" : "Embedding Output",
                                    matrixMode: isMatrixMode
                                )
                                .offset(y: isMatrixMode ? -32 : -28)
                                .matchedGeometryEffect(id: "EmbeddingMatrix", in: animationNamespace)
                            }
                            .opacity(showComponents[2] ? 1 : 0)
                            .offset(x: showComponents[2] ? 0 : -30)
                            .animation(.easeInOut(duration: 0.5), value: showComponents[2])
                            .animation(.spring(duration: 0.3), value: isMatrixMode)
                        }
                    }
                    .transition(.move(edge: .leading).combined(with: .opacity))
                }
            }
        }
        .onTapGesture {
            if animationEnded {
                animationEnded = false
                // Cancel the outer animation and toggle isHorizontal
                isHorizontal.toggle() // No animation applied to this state change
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                    // Trigger the sequential component animations after the state toggle
                    if isHorizontal {
                        hideComponents()
                    } else {
                        revealComponents()
                    }
                }
            }
        }
    }
}

struct CurveBetweenPointsView: View {
    var point1: CGPoint
    var point2: CGPoint
    
    var body: some View {
        Path { path in
            path.move(to: point1)  // Start at point1
            path.addQuadCurve(to: point2, control: CGPoint(x: (point1.x + point2.x) / 2, y: (point1.y + point2.y)/2-(point2.y-point1.y)/5)) // Control point for curve
        }
        .stroke(Color.gray, lineWidth: 2)  // Customize the color and width of the curve
    }
}

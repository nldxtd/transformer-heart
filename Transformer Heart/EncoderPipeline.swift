import SwiftUI

/// Todo
/// Modify the hard-encoding of the embeddingWeight, turn into dictionary
/// Modify the bezeir curve part on the screen, still got some bugs in the coordinates
/// Add detail in the graph and

struct InputEmbeddingView: View {
    // Default tokens
    let embeddingWeight: [[Double]] = [
        [0.67, 0.47, 0.3, 0.41, 0.67, 0.62, 0.59, 0.66, 0.49, 0.49],
        [0.34, 0.6, 0.38, 0.35, 0.59, 0.63, 0.44, 0.63, 0.42, 0.64],
        [0.37, 0.41, 0.41, 0.68, 0.51, 0.64, 0.69, 0.48, 0.41, 0.34],
        [0.66, 0.51, 0.55, 0.56, 0.44, 0.58, 0.63, 0.57, 0.65, 0.6],
        [0.47, 0.48, 0.7, 0.32, 0.56, 0.4, 0.54, 0.36, 0.39, 0.5],
        [0.31, 0.54, 0.59, 0.7, 0.37, 0.49, 0.39, 0.34, 0.53, 0.37],
        [0.35, 0.44, 0.47, 0.55, 0.54, 0.39, 0.64, 0.4, 0.32, 0.54]
    ]
    
    @State private var embeddingOutputFrames: [CGRect] = Array(repeating: .zero, count: 7)
    @State private var embeddingMatrixFrames: [CGRect] = Array(repeating: .zero, count: 7)
    @State private var framesReady: Bool = false
    
    var body: some View {
        ZStack {
            HStack(spacing: 50) {
                VStack(alignment: .leading, spacing: 16) {
                    // Column headers
                    HStack(spacing: 20) {
                        Text("Token")
                            .font(.headline)
                            .frame(width: 150, alignment: .center)
                        Text("") // Arrow column header placeholder
                            .font(.headline)
                            .frame(width: 30, alignment: .center)
                        Text("Token Embedding")
                            .font(.headline)
                            .frame(width: 120, alignment: .center)
                        Text("") // Plus sign column header
                            .font(.headline)
                            .frame(width: 30, alignment: .center)
                        Text("Positional Encoding")
                            .font(.headline)
                            .frame(width: 120, alignment: .center)
                        Text("") // Equal sign column header
                            .font(.headline)
                            .frame(width: 20, alignment: .center)
                        Text("Embedding Output")
                            .font(.headline)
                            .frame(width: 120, alignment: .center)
                    }
                    
                    // Data rows
                    ForEach(tokens.indices, id: \.self) { index in
                        HStack(spacing: 20) {
                            // Token column
                            Text(tokens[index])
                                .padding()
                                .frame(width: 150, height: 30)
                                .background(Color.blue.opacity(0.2))
                                .cornerRadius(8)
                            
                            // Arrow column
                            Image(systemName: "arrow.right")
                                .frame(width: 30, height: 30)
                            
                            // Token Embedding column
                            HStack(spacing: 2) {
                                ForEach(0..<10, id: \.self) { _ in
                                    Rectangle()
                                        .fill(Color.green.opacity(Double.random(in: 0.3...0.7)))
                                        .frame(width: 10, height: 30)
                                }
                            }
                            .frame(width: 120, height: 30)
                            .background(Color.green.opacity(0.1))
                            .cornerRadius(4)
                            
                            // Plus sign column
                            Text("+")
                                .font(.title2)
                                .frame(width: 30, height: 30)
                            
                            // Positional Encoding column
                            HStack(spacing: 2) {
                                ForEach(0..<10, id: \.self) { rec_index in
                                    Rectangle()
                                        .fill(index == rec_index ? Color.orange : Color.orange.opacity(Double.random(in: 0.3...0.5)))
                                        .frame(width: 10, height: 30)
                                }
                            }
                            .frame(width: 120, height: 30)
                            .background(Color.orange.opacity(0.1))
                            .cornerRadius(4)
                            
                            // Equal sign column
                            Text("=")
                                .font(.title2)
                                .frame(width: 20, height: 30)
                            
                            // Final Encoding column
                            HStack(spacing: 2) {
                                ForEach(0..<10, id: \.self) { rec_index in
                                    Rectangle()
                                        .fill(Color.gray.opacity(embeddingWeight[index][rec_index]))
                                        .frame(width: 10, height: 30)
                                }
                            }
                            .frame(width: 120, height: 30)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(4)
                        }
                        .overlay(
                            GeometryReader { geometry in
                                Color.clear.preference(key: EmbeddingOutputPositionKey.self, value: geometry.frame(in: .global))
                            }
                        )
                        .onPreferenceChange(EmbeddingOutputPositionKey.self) { value in
                            embeddingOutputFrames[index] = value
                            checkFramesReady()
                        }
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(12)
                .shadow(radius: 2)
                
                
                // Represent the accumulation of embedding vector
                VStack(alignment: .leading, spacing: 2) {
                    Text("Embedding Matrix")
                        .font(.headline)
                        .frame(width: 120, alignment: .center)
                    
                    // Data rows
                    ForEach(tokens.indices, id: \.self) { index in
                        HStack(spacing: 2) {
                            ForEach(0..<10, id: \.self) { rec_index in
                                Rectangle()
                                    .fill(Color.gray.opacity(embeddingWeight[index][rec_index]))
                                    .frame(width: 10, height: 12)
                            }
                        }
                        .frame(width: 120, height: 12)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(4)
                        .overlay(
                            GeometryReader { geometry in
                                Color.clear.preference(key: EmbeddingMatrixPositionKey.self, value: geometry.frame(in: .global))
                            }
                        )
                        .onPreferenceChange(EmbeddingMatrixPositionKey.self) { value in
                            embeddingMatrixFrames[index] = value
                            checkFramesReady()
                        }
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(12)
                .shadow(radius: 2)
            }
            
            if framesReady {
                drawLines()
            }
        }
    }
    
    private func checkFramesReady() {
        framesReady = !embeddingOutputFrames.contains(.zero) && !embeddingMatrixFrames.contains(.zero)
    }
    
    // Draw the lines
    @ViewBuilder
    private func drawLines() -> some View {
        ForEach(tokens.indices, id: \.self) { index in
            if embeddingOutputFrames[index] != .zero && embeddingMatrixFrames[index] != .zero {
                CurveBetweenPointsView(
                    point1: CGPoint(x: embeddingOutputFrames[index].maxX+5, y: embeddingOutputFrames[index].midY-25),
                    point2: CGPoint(x: embeddingMatrixFrames[index].minX-3, y: embeddingMatrixFrames[index].minY-18)
                )
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


// Preference Key to pass CGRect positions
struct EmbeddingOutputPositionKey: PreferenceKey {
    static var defaultValue: CGRect = .zero

    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
}

struct EmbeddingMatrixPositionKey: PreferenceKey {
    static var defaultValue: CGRect = .zero

    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
}

struct InputEmbeddingView_Previews: PreviewProvider {
    static var previews: some View {
        InputEmbeddingView()
            .previewDevice("iPad Pro (12.9-inch) (5th generation)")
            .previewInterfaceOrientation(.landscapeRight)
    }
}

import SwiftUI

// A key to track positions for the embedding matrix (optional, based on your original code).
struct EmbeddingMatrixFFNPositionKey: PreferenceKey {
    static var defaultValue: [CGRect] = []
    static func reduce(value: inout [CGRect], nextValue: () -> [CGRect]) {
        value.append(contentsOf: nextValue())
    }
}

struct TransformerFFNView: View {
    // Mock data for tokens and embedding weights
    let tokens: [String] = ["USC", "is", "located", "near", "the", "downtown", "of"]
    let tokensId: [Int] = [9007, 58, 256, 174, 13, 347, 41]
    let QKVMatrixWeight: [[Double]] = [
        [0.48, 0.32, 0.76, 0.39, 0.55, 0.5, 0.39, 0.55, 0.5, 0.62, 0.65, 0.62, 0.54, 0.37, 0.42, 0.34, 0.63, 0.36, 0.65, 0.41, 0.69, 0.59, 0.37, 0.4, 0.74, 0.56, 0.7, 0.78, 0.43, 0.53],
        [0.5, 0.52, 0.62, 0.45, 0.35, 0.33, 0.56, 0.66, 0.66, 0.31, 0.7, 0.65, 0.5, 0.54, 0.72, 0.79, 0.34, 0.58, 0.75, 0.6, 0.41, 0.67, 0.55, 0.78, 0.36, 0.41, 0.75, 0.59, 0.79, 0.63],
        [0.48, 0.34, 0.74, 0.45, 0.54, 0.43, 0.74, 0.79, 0.31, 0.36, 0.54, 0.34, 0.46, 0.61, 0.61, 0.76, 0.45, 0.71, 0.74, 0.74, 0.59, 0.53, 0.57, 0.64, 0.61, 0.56, 0.47, 0.74, 0.79, 0.67],
        [0.36, 0.34, 0.8, 0.74, 0.8, 0.46, 0.72, 0.58, 0.72, 0.63, 0.3, 0.46, 0.32, 0.43, 0.43, 0.73, 0.72, 0.69, 0.41, 0.4, 0.76, 0.69, 0.52, 0.45, 0.38, 0.52, 0.39, 0.5, 0.41, 0.49],
        [0.4, 0.6, 0.37, 0.37, 0.62, 0.68, 0.62, 0.57, 0.32, 0.58, 0.32, 0.46, 0.4, 0.62, 0.4, 0.37, 0.49, 0.51, 0.62, 0.66, 0.45, 0.57, 0.53, 0.75, 0.34, 0.8, 0.44, 0.67, 0.78, 0.69],
        [0.5, 0.76, 0.57, 0.79, 0.78, 0.35, 0.36, 0.78, 0.61, 0.42, 0.47, 0.73, 0.49, 0.79, 0.71, 0.58, 0.53, 0.36, 0.75, 0.6, 0.56, 0.69, 0.3, 0.64, 0.69, 0.37, 0.73, 0.57, 0.68, 0.56],
        [0.75, 0.8, 0.37, 0.65, 0.69, 0.49, 0.69, 0.77, 0.33, 0.68, 0.78, 0.38, 0.39, 0.34, 0.47, 0.6, 0.75, 0.52, 0.46, 0.62, 0.72, 0.61, 0.46, 0.52, 0.75, 0.41, 0.73, 0.36, 0.38, 0.69],
        [0.39, 0.37, 0.43, 0.32, 0.46, 0.34, 0.33, 0.71, 0.71, 0.52, 0.5, 0.65, 0.31, 0.76, 0.79, 0.32, 0.38, 0.35, 0.63, 0.55, 0.57, 0.67, 0.43, 0.42, 0.38, 0.79, 0.69, 0.45, 0.72, 0.48],
        [0.7, 0.71, 0.38, 0.46, 0.7, 0.37, 0.69, 0.7, 0.75, 0.46, 0.62, 0.64, 0.44, 0.69, 0.73, 0.39, 0.45, 0.73, 0.45, 0.52, 0.67, 0.46, 0.68, 0.31, 0.66, 0.7, 0.74, 0.57, 0.76, 0.37],
        [0.67, 0.53, 0.48, 0.49, 0.43, 0.77, 0.38, 0.56, 0.8, 0.47, 0.63, 0.4, 0.65, 0.36, 0.53, 0.69, 0.69, 0.56, 0.63, 0.5, 0.42, 0.53, 0.68, 0.61, 0.71, 0.55, 0.47, 0.6, 0.71, 0.72]
    ]
    
    @State private var embeddingMatrixFrames: [CGRect] = Array(repeating: .zero, count: 5)
    
    var body: some View {
        HStack(spacing: 20) {
            // Embedding Matrix + Multi-Head Attention
            VStack(alignment: .center, spacing: 10) {
                
                VStack(spacing: 2) {
                    Text("Embedding Matrix")
                        .font(.headline)
                    
                    ForEach(tokens.indices, id: \.self) { index in
                        HStack(spacing: 2) {
                            ForEach(0..<10, id: \.self) { recIndex in
                                Rectangle()
                                    .fill(Color.gray.opacity(QKVMatrixWeight[index][recIndex]))
                                    .frame(width: 10, height: 12)
                            }
                        }
                        .cornerRadius(4)
                    }
                }
                .padding()
                .frame(width: 200)
                
                VStack(spacing: 2) {
                    Text("Multi-Head Attention")
                        .font(.headline)
                    
                    ForEach(tokens.indices, id: \.self) { index in
                        HStack(spacing: 2) {
                            ForEach(0..<10, id: \.self) { recIndex in
                                Rectangle()
                                    .fill(Color.gray.opacity(QKVMatrixWeight[index][recIndex]))
                                    .frame(width: 10, height: 12)
                            }
                        }
                        .cornerRadius(4)
                    }
                }
                .padding()
                .frame(width: 200)
            }
            
            // Residual Connection and Layer Norm
//            HStack(spacing: 10) {
//                // Plus sign column
//                Text("+")
//                    .font(.title2)
//                    .frame(width: 30, height: 30)
//                    .cornerRadius(15)
//                    .background(Color.gray.opacity(0.
                // Arrow column
//                Image(systemName: "arrow.right")
//                    .frame(width: 30, height: 30)
//                Text("Layer Norm")
//                    .font(.title2)
//                    .padding()
//                    .background(Color.gray.opacity(0.1))
//                    .cornerRadius(12)
//                    .shadow(radius: 2)
//            }
            
            // output after Layer Norm
            VStack(spacing: 2) {
                Text("Norm Output")
                    .font(.headline)
                
                ForEach(tokens.indices, id: \.self) { index in
                    HStack(spacing: 2) {
                        ForEach(0..<10, id: \.self) { recIndex in
                            Rectangle()
                                .fill(Color.gray.opacity(QKVMatrixWeight[index][recIndex]))
                                .frame(width: 10, height: 12)
                        }
                    }
                    .cornerRadius(4)
                }
            }
            .padding()
            .frame(width: 200)
            
            // Feed-Forward Network
            VStack(spacing: 20) {
                Text("Feed-Forward Network")
                    .font(.headline)
                    .padding()
                
                HStack(spacing: 30) {
                    // Input Layer (7 dimensions)
                    FFNLayerView(dimensions: 7, color: .blue)
                    
                    // Hidden Layer (14 dimensions)
                    FFNLayerView(dimensions: 14, color: .orange)
                    
                    // Output Layer (7 dimensions)
                    FFNLayerView(dimensions: 7, color: .green)
                }
            }
            .padding()
            
            // FFN output plus residual and Norm
            VStack(spacing: 2) {
                Text("FFN Output")
                    .font(.headline)
                
                ForEach(tokens.indices, id: \.self) { index in
                    HStack(spacing: 2) {
                        ForEach(0..<10, id: \.self) { recIndex in
                            Rectangle()
                                .fill(Color.gray.opacity(QKVMatrixWeight[index][recIndex]))
                                .frame(width: 10, height: 12)
                        }
                    }
                    .cornerRadius(4)
                }
            }
            .padding()
            .frame(width: 200)
            
            // Transformer output plus residual and Norm
            VStack(spacing: 2) {
                Text("Transformer Output")
                    .font(.headline)
                
                ForEach(tokens.indices, id: \.self) { index in
                    HStack(spacing: 2) {
                        ForEach(0..<10, id: \.self) { recIndex in
                            Rectangle()
                                .fill(Color.gray.opacity(QKVMatrixWeight[index][recIndex]))
                                .frame(width: 10, height: 12)
                        }
                    }
                    .cornerRadius(4)
                }
            }
            .padding()
            .frame(width: 200)
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(20)
        .shadow(radius: 2)
    }
}

// Helper view to represent the "bracelet" connection for residuals
struct BraceletView: View {
    var body: some View {
        Capsule()
            .fill(Color.gray.opacity(0.5))
            .frame(width: 100, height: 10)
    }
}

// Helper view to represent arrows
struct ArrowView: View {
    var body: some View {
        Path { path in
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: 100, y: 0))
            path.addLine(to: CGPoint(x: 90, y: -10))
            path.move(to: CGPoint(x: 100, y: 0))
            path.addLine(to: CGPoint(x: 90, y: 10))
        }
        .stroke(Color.gray, lineWidth: 2)
    }
}

// Helper view to represent a layer in the FFN
struct FFNLayerView: View {
    let dimensions: Int
    let color: Color
    
    var body: some View {
        VStack(spacing: 5) {
            ForEach(0..<dimensions, id: \.self) { _ in
                Circle()
                    .fill(color.opacity(0.8))
                    .frame(width: 30, height: 30)
            }
        }
    }
}

// Preview
struct TransformerFFNView_Previews: PreviewProvider {
    static var previews: some View {
        TransformerFFNView()
    }
}

import SwiftUI

struct ProbabilityOutputView: View {
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
            // Transformer output
            VStack(spacing: 2) {
                Text("Transformer Output")
                    .font(.headline)
                
                ForEach(tokens.indices, id: \.self) { index in
                    HStack(spacing: 2) {
                        ForEach(0..<10, id: \.self) { recIndex in
                            if index==tokens.count-1 {
                                Rectangle()
                                    .fill(Color.orange.opacity(QKVMatrixWeight[index][recIndex]))
                                    .frame(width: 10, height: 12)
                            } else {
                                Rectangle()
                                    .fill(Color.gray.opacity(QKVMatrixWeight[index][recIndex]))
                                    .frame(width: 10, height: 12)
                            }
                        }
                    }
                    .cornerRadius(4)
                }
            }
            .padding()
            .frame(width: 200)
            
            // output after Layer Norm
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
            
            // Embedding output vector
            VStack(spacing: 2) {
                Text("Output Logits")
                    .font(.headline)
                
                ForEach(tokens.indices, id: \.self) { index in
                    Rectangle()
                        .fill(Color.gray.opacity(QKVMatrixWeight[0][index]))
                        .frame(width: 5, height: 20)
                    .cornerRadius(4)
                }
            }
            .padding()
            
            // Output logits and probabilities
            VStack(alignment: .center, spacing: 2) {
                Text("Next token probabilities")
                    .font(.headline)
                
                ProbabilityView(probs: [66.27, 14.2, 5.93, 2.07, 1.99, 1.77, 1.57])
                
            }
            .padding()
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(20)
        .shadow(radius: 2)
    }
}

struct ProbabilityView: View {
    
    let probs: [Double]
    
    var body: some View {
        HStack(alignment: .center, spacing: 10) {
            VStack(alignment: .center) {
                Text("Tokens")
                    .font(.subheadline)
                    .padding()
                VStack(spacing: 2) {
                    ForEach(["USC", "is", "located", "near", "the", "downtown", "of"], id:\.self) { token in
                        Text(token)
                            .font(.caption)
                    }
                }
            }
            
            VStack(alignment: .center) {
                Text("Logits")
                    .font(.subheadline)
                    .padding()
                VStack(spacing: 2) {
                    ForEach(["-135.91", "-136.68", "-137.12", "-137.65", "-137.67", "-138.54", "-147.34"], id:\.self) { logits in
                        Text(logits)
                            .font(.caption)
                    }
                }
            }
            
            VStack(alignment: .center) {
                Text("Exponents")
                    .font(.subheadline)
                    .padding()
                VStack(spacing: 2) {
                    ForEach(["1.00e+0", "2.14e-1", "8.94e-2", "3.12e-2", "2.22e-2", "7.35e-3", "3.31e-3"], id:\.self) { expo in
                        Text(expo)
                            .font(.caption)
                    }
                }
            }
            
            VStack(alignment: .center) {
                Text("Softmax")
                    .font(.subheadline)
                    .padding()
                VStack(alignment: .leading, spacing: 2) {
                    ForEach(probs, id:\.self) { prob in
                        HStack(spacing: 2) {
                            Rectangle()
                                .frame(width: CGFloat(prob), height: 3)
                                .foregroundColor(.blue)
                            Text(String(format: "%.2f%", prob))
                                .font(.caption)
                        }
                    }
                }
            }
        }
    }
}
 
// Preview
struct ProbabilityOutputView_Previews: PreviewProvider {
    static var previews: some View {
        ProbabilityOutputView()
    }
}

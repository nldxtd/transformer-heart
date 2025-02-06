import SwiftUI

struct ProbabilityOutputView: View {
    // Mock data for tokens and embedding weights

    @State private var finalOutputMatrix: VectorListViewModel = VectorListViewModel(
        matrixWeight: feedForwardOutputMatrixWeight)

    @State private var finalOutputPosition: CGPoint = CGPoint(x: 0, y: 0)
    @State private var verticalVectorPosition: CGPoint = CGPoint(x: 0, y: 0)

    @Binding var currentView: String
    var animationNamespace: Namespace.ID

    var body: some View {

        // overall is a zstack
        ZStack {
            HStack {
                // Represent of final tansformer output
                // TODO: add a parameter to control the last row vector highligted
                VectorList(
                    dimention: 10,
                    vectors: finalOutputMatrix,
                    color: .gray,
                    defaultWidth: 12,
                    defaultHeight: 13,
                    spacing: 2,
                    title: "Final Output",
                    matrixMode: true
                )
                .matchedGeometryEffect(id: "Final Output", in: animationNamespace)

                // TODO: back ground draw sign lines
                // each block represent a token
                VStack {
                    Text("Unembedded Vector")
                        .padding()
                    VStack(spacing: 2) {
                        ForEach(0..<8, id: \.self) { idx in
                            Rectangle()
                                .fill(Color.gray.opacity(Double.random(in: 0...1)))
                                .frame(width: 40, height: 15)
                                .overlay(alignment: .center) {
                                    Text("\(idx)")
                                }
                        }
                        Text("⋮")
                            .frame(height: 20)
                        ForEach(0..<5, id: \.self) { idx in
                            Rectangle()
                                .fill(Color.gray.opacity(Double.random(in: 0...1)))
                                .frame(width: 40, height: 15)
                                .overlay(alignment: .center) {
                                    Text("\(idx)")
                                }
                        }
                        Text("⋮")
                            .frame(height: 20)
                        ForEach(0..<3, id: \.self) { idx in
                            Rectangle()
                                .fill(Color.gray.opacity(Double.random(in: 0...1)))
                                .frame(width: 40, height: 15)
                                .overlay(alignment: .center) {
                                    Text("\(idx)")
                                }
                        }
                        Text("⋮")
                            .frame(height: 20)
                        ForEach(0..<6, id: \.self) { idx in
                            Rectangle()
                                .fill(Color.gray.opacity(Double.random(in: 0...1)))
                                .frame(width: 40, height: 15)
                                .overlay(alignment: .center) {
                                    Text("\(idx)")
                                }
                        }
                    }
                    .cornerRadius(4)
                    .overlay(
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(Color.white, lineWidth: 1)
                    )
                    Text("Dimension: D(Dic)")
                        .padding()
                }

                // Output logits and probabilities
                // TODO: randomly select
                VStack(alignment: .center, spacing: 2) {
                    Text("Next token probabilities")
                        .font(.headline)
                    ProbabilityView(probs: [66.27, 14.2, 5.93, 2.07, 1.99, 1.77, 1.57])

                }
            }

            // TODO: add a selector here to change the temperature
        }
    }
}

struct ProbabilityView: View {

    let probs: [Double]

    var body: some View {
        HStack(alignment: .center) {
            VStack(alignment: .trailing) {
                Text("Tokens")
                    .font(.subheadline)
                VStack(alignment: .trailing, spacing: 2) {
                    ForEach(["USC", "is", "located", "near", "the", "downtown", "of"], id: \.self) {
                        token in
                        Text(token)
                            .font(.caption)
                    }
                }
            }

            VStack(alignment: .center) {
                Text("Logits")
                    .font(.subheadline)
                VStack(spacing: 2) {
                    ForEach(
                        [
                            "-135.91", "-136.68", "-137.12", "-137.65", "-137.67", "-138.54",
                            "-147.34",
                        ], id: \.self
                    ) { logits in
                        Text(logits)
                            .font(.caption)
                    }
                }
            }

            VStack(alignment: .center) {
                Text("Exponents")
                    .font(.subheadline)
                VStack(spacing: 2) {
                    ForEach(
                        [
                            "1.00e+0", "2.14e-1", "8.94e-2", "3.12e-2", "2.22e-2", "7.35e-3",
                            "3.31e-3",
                        ], id: \.self
                    ) { expo in
                        Text(expo)
                            .font(.caption)
                    }
                }
            }

            VStack(alignment: .center) {
                Text("Softmax")
                    .font(.subheadline)
                VStack(alignment: .leading, spacing: 2) {
                    ForEach(probs, id: \.self) { prob in
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

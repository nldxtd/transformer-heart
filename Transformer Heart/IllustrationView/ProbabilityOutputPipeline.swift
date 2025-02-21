import SwiftUI

struct ProbabilityOutputView: View {
    // Mock data for tokens and embedding weights

    @State private var finalOutputMatrix: VectorListViewModel = VectorListViewModel(
        matrixWeight: feedForwardOutputMatrixWeight)

    @State private var finalOutputPosition: CGPoint = CGPoint(x: 0, y: 0)
    @State private var verticalVectorPosition: CGPoint = CGPoint(x: 0, y: 0)
    @State private var highlightLastRow: Int = -1
    @State private var downEmbeddingProgress: CGFloat = 0
    @State private var verticleVectorVisible: Bool = false
    @State private var probPredictionVisible: Bool = false
    @State private var temperature: Double = 1.0

    let fisrtTokenChoices: [String] = ["", "", "", "visualize", "", "", "see", ""]
    let firstTokenOpacity: [CGFloat] = [0.13, 0.24, 0.31, 0.87, 0.05, 0.15, 0.64, 0.22]
    let secondTokenChoices: [String] = ["", "understand", "", "create", ""]
    let secondTokenOpacity: [CGFloat] = [0.27, 0.62, 0.19, 0.52, 0.05]
    let thirdTokenChoices: [String] = ["", "explore", ""]
    let thirdTokenOpacity: [CGFloat] = [0.11, 0.68, 0.13]
    let forthTokenChoices: [String] = ["", "easily", "", "", "build", ""]
    let forthTokenOpacity: [CGFloat] = [0.1, 0.52, 0.09, 0.21, 0.55, 0.14]

    @Binding var currentView: String
    var animationNamespace: Namespace.ID
    @Binding var selectedComponent: ModelComponent

    var body: some View {

        // overall is a zstack
        ZStack {
            HStack {
                // Represent of final tansformer output
                VectorList(
                    dimention: 10,
                    vectors: finalOutputMatrix,
                    labels: feedForwardOutputMatrixWeight,
                    color: .blue,
                    defaultWidth: 12,
                    defaultHeight: 13,
                    spacing: 2,
                    title: "Final Output",
                    matrixMode: true,
                    highlightRowIndex: highlightLastRow
                )
                .matchedGeometryEffect(id: "Final Output", in: animationNamespace)
                .background {
                    GeometryReader { geo in
                        Color.clear
                            .onAppear {
                                finalOutputPosition = CGPoint(
                                    x: geo.frame(in: .named("probRootView")).maxX + 2,
                                    y: geo.frame(in: .named("probRootView")).maxY
                                )
                            }
                    }
                }
                
                Text("Unembedding")
                    .font(.subheadline)
                    .offset(x: 20, y: 100)
                    .opacity(downEmbeddingProgress)
                    .underline()
                    .onTapGesture {
                        selectedComponent = .unembeddingMatrix
                    }

                // each block represent a token
                VStack {
                    Text("Unembedded Vector")
                        .padding()
                    VStack(spacing: 2) {
                        ForEach(0..<8, id: \.self) { idx in
                            Rectangle()
                                .fill(Color.blue.opacity(firstTokenOpacity[idx]))
                                .frame(width: 90, height: 20)
                                .overlay(alignment: .center) {
                                    Text(fisrtTokenChoices[idx])
                                }
                        }
                        Text("⋮")
                            .frame(height: 20)
                        ForEach(0..<5, id: \.self) { idx in
                            Rectangle()
                                .fill(Color.blue.opacity(secondTokenOpacity[idx]))
                                .frame(width: 90, height: 20)
                                .overlay(alignment: .center) {
                                    Text(secondTokenChoices[idx])
                                }
                        }
                        Text("⋮")
                            .frame(height: 20)
                        ForEach(0..<3, id: \.self) { idx in
                            Rectangle()
                                .fill(Color.blue.opacity(thirdTokenOpacity[idx]))
                                .frame(width: 90, height: 20)
                                .overlay(alignment: .center) {
                                    Text(thirdTokenChoices[idx])
                                }
                        }
                        Text("⋮")
                            .frame(height: 20)
                        ForEach(0..<6, id: \.self) { idx in
                            Rectangle()
                                .fill(Color.blue.opacity(forthTokenOpacity[idx]))
                                .frame(width: 90, height: 20)
                                .overlay(alignment: .center) {
                                    Text(forthTokenChoices[idx])
                                }
                        }
                    }
                    .cornerRadius(4)
                    .overlay(
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(Color.white, lineWidth: 1)
                    )
                    .background {
                        GeometryReader { geo in
                            Color.clear
                                .onAppear {
                                    verticalVectorPosition = CGPoint(
                                        x: geo.frame(in: .named("probRootView")).minX - 2,
                                        y: geo.frame(in: .named("probRootView")).maxY
                                    )
                                }
                        }
                    }
                    Text("Dimension: D(Dic)")
                        .padding()
                }
                .opacity(verticleVectorVisible ? 1 : 0)

                // Output logits and probabilities
                VStack(alignment: .center, spacing: 2) {

                    Text("Probability calculation")
                        .font(.title)
                        .padding()
                    ProbabilityView(selectedComponent: $selectedComponent)
                }
                .opacity(probPredictionVisible ? 1 : 0)
                .offset(x: probPredictionVisible ? 0 : -30, y: -40)
                .frame(width: 500)
            }
            .background {
                AnimatedCurveShape(
                    corner1: CGPoint(x: finalOutputPosition.x, y: finalOutputPosition.y - 13),
                    corner2: CGPoint(
                        x: verticalVectorPosition.x, y: verticalVectorPosition.y - 542),
                    corner3: verticalVectorPosition,
                    corner4: finalOutputPosition,
                    progress: downEmbeddingProgress
                )
                .fill(Color.blue.opacity(0.3))
            }
        }
        .coordinateSpace(name: "probRootView")
        .onAppear {
            selectedComponent = .outputProbability
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                withAnimation(.easeInOut(duration: 0.5)) {
                    highlightLastRow = 5
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation(.easeInOut(duration: 0.5)) {
                    downEmbeddingProgress = 1.0
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                withAnimation(.easeInOut(duration: 0.5)) {
                    verticleVectorVisible = true
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                withAnimation(.easeInOut(duration: 0.5)) {
                    probPredictionVisible = true
                }
            }
        }
    }
}

struct ProbabilityView: View {
    let tokens = ["visualize", "understand", "see", "explore", "create", "easily", "build"]
    let logits: [Double] = [-0.5, -0.8, -1.0, -1.2, -1.5, -2.0, -2.5]
    
    @State private var temperature: Double = 1.0
    @State private var expos: [Double] = []
    @State private var probs: [Double] = []
    @State private var finalTokenIndex: Int? = nil
    @Binding var selectedComponent: ModelComponent
    
    var body: some View {
        VStack {
            HStack {
                Text("Temperature: ")
                    .underline()
                    .onTapGesture {
                        selectedComponent = .temperature
                    }
                Text(String(format: "%.1f", temperature))
                    .foregroundColor(.green)
                Slider(value: $temperature, in: 0.5...2.0, step: 0.1)
                    .frame(width: 200)
                    .onChange(of: temperature) { _ in
                        computeSoftmax()
                    }
            }
            .padding(.bottom, 20)
            
            HStack(alignment: .center, spacing: 16) {
                VStack(alignment: .trailing) {
                    Text("Tokens")
                        .font(.subheadline)
                    VStack(alignment: .trailing, spacing: 8) {
                        ForEach(tokens.indices, id: \.self) { index in
                            Text(tokens[index])
                                .font(.body)
                                .padding(4)
                                .background(finalTokenIndex == index ? Color.purple.opacity(0.3) : Color.clear)
                                .cornerRadius(4)
                        }
                    }
                }
                
                VStack(alignment: .center) {
                    Text("Logits")
                        .font(.subheadline)
                    VStack(spacing: 8) {
                        ForEach(logits, id: \.self) { logit in
                            Text(String(format: "%.2f", logit))
                                .font(.body)
                                .padding(4)
                                .frame(width: 75)
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(4)
                        }
                    }
                }
                
                VStack(alignment: .center) {
                    Text("Exponents")
                        .font(.subheadline)
                    VStack(spacing: 8) {
                        ForEach(expos.indices, id: \.self) { index in
                            Text(String(format: "%.2f", expos[index]))
                                .font(.body)
                                .padding(4)
                                .frame(width: 75)
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(4)
                        }
                    }
                }
                
                VStack(alignment: .leading) {
                    Text("Softmax")
                        .font(.subheadline)
                        .underline()
                        .onTapGesture {
                            selectedComponent = .softmaxProbability
                        }
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(probs.indices, id: \.self) { index in
                            HStack(spacing: 8) {
                                Rectangle()
                                    .frame(width: CGFloat(probs[index] * 1.5), height: 6)
                                    .foregroundColor(.blue)
                                Text(String(format: "%.2f%%", probs[index]))
                                    .font(.body)
                            }
                            .padding(4)
                            .background(finalTokenIndex == index ? Color.purple.opacity(0.3) : Color.clear)
                            .cornerRadius(4)
                        }
                    }
                }
            }
            
            HStack(spacing: 0) {
                Text("Transformer visualization empowers user to ")
                Text(tokens[finalTokenIndex ?? 0])
                    .foregroundColor(.purple)
            }
            .padding(.top, 20)
            .font(.callout)
        }
        .onAppear {
            computeSoftmax()
        }
    }
    
    private func computeSoftmax() {
        let scaledLogits = logits.map { $0 / temperature }
        let expValues = scaledLogits.map { exp($0) }
        let sumExp = expValues.reduce(0, +)
        let probabilities = expValues.map { ($0 / sumExp) * 100 }
        
        self.expos = expValues
        self.probs = probabilities
        self.finalTokenIndex = sampleFromDistribution(probabilities)
    }
    
    private func sampleFromDistribution(_ probabilities: [Double]) -> Int? {
        let sum = probabilities.reduce(0, +)
        let threshold = Double.random(in: 0..<sum)
        var cumulative = 0.0
        
        for (index, prob) in probabilities.enumerated() {
            cumulative += prob
            if threshold < cumulative {
                return index
            }
        }
        return nil
    }
}

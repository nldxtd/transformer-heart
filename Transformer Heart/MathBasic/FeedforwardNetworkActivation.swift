//
//  VectorMatrix.swift
//  Transformer Heart
//
//  Created by nldxtd on 2025/2/10.
//

import SwiftUI

struct FeedforwardNetworkActivationView: View {
    // MARK: - State Properties
    @State private var matrix: VectorListViewModel = VectorListViewModel(matrixWeight: firstMatrixWeight)
    @State private var vec: VectorViewModel = VectorViewModel(weight: vecWeight)
    @State private var res: VectorViewModel = VectorViewModel(weight: resWeight)
    @State private var connectProgress: [[Double]] = Array(repeating: Array(repeating: 1.0, count: 3), count: 2)
    @State private var inputLayerPositions: [CGPoint] = []
    @State private var outputLayerPositions: [CGPoint] = []
    @State private var animationEnable: Bool = true
    @State private var currentOutputValues: [Double] = resWeight  // Track current output values
    @State private var preReluValues: [Double] = [-0.5, 0.3, -0.2, 0.8]
    @State private var postReluValues: [Double] = [-0.5, 0.3, -0.2, 0.8]
    @State private var isShowingRelu: Bool = false
    @State private var preSigmoidValues: [Double] = [-2.0, -0.5, 0.5, 2.0]
    @State private var postSigmoidValues: [Double] = [-2.0, -0.5, 0.5, 2.0]
    @State private var isShowingSigmoid: Bool = false
    
    // MARK: - View Components
    private var headerView: some View {
        VStack(spacing: 10) {
            Text("IV. Feed-Forward Network & Activation")
                .font(.largeTitle)
                .fontWeight(.bold)

            Rectangle()
                .frame(height: 2)
                .foregroundColor(.gray.opacity(0.3))
                .padding(.horizontal)
        }
        .padding(.top, 40)
    }
    
    private var multiplicatitonView: some View {
        HStack {
            Spacer()
            VectorList(
                dimention: 3,
                vectors: matrix,
                labels: firstMatrixWeight,
                color: .green,
                defaultWidth: 30,
                defaultHeight: 40,
                spacing: 2,
                vectorSpacing: 2,
                matrixMode: true,
                withLabel: true
            )
            .padding()

            Text("\u{00D7}")

            VerticalVectorView(
                dimention: 3,
                vector: vec,
                labels: vecWeight.map{String($0)},
                color: .yellow,
                zoom: 1.0,
                defaultWidth: 30,
                defaultHeight: 40,
                spacing: 2,
                cornerRadius: 4,
                withLabel: true
            )
            .padding()

            Text("=")

            VerticalVectorView(
                dimention: 2,
                vector: res,
                labels: resWeight.map{String($0)},
                color: .blue,
                zoom: 1.0,
                defaultWidth: 30,
                defaultHeight: 40,
                spacing: 2,
                cornerRadius: 4,
                withLabel: true
            )
            .padding()
            Spacer()
        }
    }
    
    private var networkVisualizationView: some View {
        VStack {
            HStack(spacing: 50) {
                Spacer()
                // Input Layer
                VStack(spacing: 30) {
                    ForEach(0..<3, id: \.self) { idx in
                        NetworkNode(
                            value: vecWeight[idx],
                            color: .yellow,
                            position: $inputLayerPositions,
                            index: idx
                        )
                    }
                }
                
                // Output Layer
                VStack(spacing: 30) {
                    ForEach(0..<2, id: \.self) { idx in
                        NetworkNode(
                            value: currentOutputValues[idx],  // Use current values instead of final values
                            color: .blue,
                            position: $outputLayerPositions,
                            index: idx
                        )
                    }
                }
                Spacer()
            }
            .coordinateSpace(name: "ffnRootView")
            .background(ConnectionLinesView(
                inputPositions: inputLayerPositions,
                outputPositions: outputLayerPositions,
                weights: firstMatrixWeight,
                progress: connectProgress
            ))
            Button(action: {
                        playMatrixMultiplication()
                    }) {
                        Image(systemName: "play.fill")
                            .font(.system(size: 20))
                            .foregroundColor(.white)
                            .frame(width: 30, height: 30)
                            .background(
                                Circle()
                                    .fill(animationEnable ? Color.blue : Color.gray)
                            )
                            .shadow(radius: 4)
                    }
                    .disabled(!animationEnable)
        }
    }
    
    // Add these computed properties for activation function graphs
    private var reluGraph: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let height = geometry.size.height
            let midY = height/2
            
            ZStack {
                // Axes
                Path { path in
                    // X axis
                    path.move(to: CGPoint(x: 0, y: midY))
                    path.addLine(to: CGPoint(x: width, y: midY))
                    // Y axis
                    path.move(to: CGPoint(x: width/2, y: 0))
                    path.addLine(to: CGPoint(x: width/2, y: height))
                }
                .stroke(Color.gray, lineWidth: 1)
                
                // ReLU function
                Path { path in
                    path.move(to: CGPoint(x: 0, y: midY))
                    path.addLine(to: CGPoint(x: width/2, y: midY))
                    path.addLine(to: CGPoint(x: width, y: 0))
                }
                .stroke(Color.blue, lineWidth: 2)
                
                // Labels
                Text("ReLU(x) = max(0,x)")
                    .font(.caption)
                    .position(x: width * 0.8, y: height * 0.2)
            }
        }
        .frame(width: 300, height: 150)
        .padding()
    }

    private var sigmoidGraph: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let height = geometry.size.height
            let midY = height/2
            
            ZStack {
                // Axes
                Path { path in
                    path.move(to: CGPoint(x: 0, y: midY))
                    path.addLine(to: CGPoint(x: width, y: midY))
                    path.move(to: CGPoint(x: width/2, y: 0))
                    path.addLine(to: CGPoint(x: width/2, y: height))
                }
                .stroke(Color.gray, lineWidth: 1)
                
                // Sigmoid curve
                Path { path in
                    path.move(to: CGPoint(x: 0, y: height * 0.9))
                    for x in stride(from: 0, through: width, by: 2) {
                        let normalizedX = (x/width - 0.5) * 6 // Scale to reasonable sigmoid input
                        let y = 1.0 / (1.0 + exp(-normalizedX))
                        path.addLine(to: CGPoint(x: x, y: height * (1-y)))
                    }
                }
                .stroke(Color.purple, lineWidth: 2)
                
                // Labels
                Text("Sigmoid(x) = 1/(1+e⁻ˣ)")
                    .font(.caption)
                    .position(x: width * 0.8, y: height * 0.2)
            }
        }
        .frame(width: 300, height: 150)
        .padding()
    }
    
    // Add this computed property for the ReLU example
    private var reluExampleView: some View {
        HStack {
            Spacer()
            VStack(alignment: .center, spacing: 20) {
                HStack(spacing: 40) {
                    // Input vector
                    VStack {
                        Text("Input")
                            .font(.caption)
                            .foregroundColor(.gray)
                        VerticalVectorView(
                            dimention: 4,
                            vector: VectorViewModel(weight: preReluValues),
                            labels: preReluValues.map{String($0)},
                            color: .yellow,
                            zoom: 1.0,
                            defaultWidth: 40,
                            defaultHeight: 40,
                            spacing: 2,
                            cornerRadius: 4,
                            withLabel: true
                        )
                        .cornerRadius(10)
                    }
                    
                    // ReLU transformation
                    VStack {
                        Text("ReLU")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(isShowingRelu ? .blue : .gray)
                        Image(systemName: "arrow.right")
                            .foregroundColor(isShowingRelu ? .blue : .gray)
                    }
                    
                    // Output vector
                    VStack {
                        Text("Output")
                            .font(.caption)
                            .foregroundColor(.gray)
                        VerticalVectorView(
                            dimention: 4,
                            vector: VectorViewModel(weight: postReluValues),
                            labels: postReluValues.map{String($0)},
                            color: .blue,
                            zoom: 1.0,
                            defaultWidth: 40,
                            defaultHeight: 40,
                            spacing: 2,
                            cornerRadius: 4,
                            withLabel: true
                        )
                        .cornerRadius(10)
                    }
                }
                .padding(20)
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.white)
                        .shadow(
                            color: Color.black.opacity(0.1),
                            radius: 10,
                            x: 0,
                            y: 5
                        )
                )
                
                // Animation control
                Button(action: {
                    animateRelu()
                }) {
                    HStack {
                        Image(systemName: "play.fill")
                        Text(isShowingRelu ? "Reset" : "Apply ReLU")
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
            }
            Spacer()
        }
        .padding()
    }
    
    // Add this computed property for the sigmoid example
    private var sigmoidExampleView: some View {
        HStack {
            Spacer()
            VStack(alignment: .center, spacing: 20) {
                HStack(spacing: 40) {
                    // Input vector
                    VStack {
                        Text("Input")
                            .font(.caption)
                            .foregroundColor(.gray)
                        VerticalVectorView(
                            dimention: 4,
                            vector: VectorViewModel(weight: preSigmoidValues),
                            labels: preSigmoidValues.map{String($0)},
                            color: .yellow,
                            zoom: 1.0,
                            defaultWidth: 40,
                            defaultHeight: 40,
                            spacing: 2,
                            cornerRadius: 4,
                            withLabel: true
                        )
                        .cornerRadius(10)
                    }
                    
                    // Sigmoid transformation
                    VStack {
                        Text("Sigmoid")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(isShowingSigmoid ? .purple : .gray)
                        Image(systemName: "arrow.right")
                            .foregroundColor(isShowingSigmoid ? .purple : .gray)
                    }
                    
                    // Output vector
                    VStack {
                        Text("Output")
                            .font(.caption)
                            .foregroundColor(.gray)
                        VerticalVectorView(
                            dimention: 4,
                            vector: VectorViewModel(weight: postSigmoidValues),
                            labels: postSigmoidValues.map{String($0)},
                            color: .purple,
                            zoom: 1.0,
                            defaultWidth: 40,
                            defaultHeight: 40,
                            spacing: 2,
                            cornerRadius: 4,
                            withLabel: true
                        )
                        .cornerRadius(10)
                    }
                }
                .padding(20)
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.white)
                        .shadow(
                            color: Color.black.opacity(0.1),
                            radius: 10,
                            x: 0,
                            y: 5
                        )
                )
                
                // Animation control
                Button(action: {
                    animateSigmoid()
                }) {
                    HStack {
                        Image(systemName: "play.fill")
                        Text(isShowingSigmoid ? "Reset" : "Apply Sigmoid")
                    }
                    .padding()
                    .background(Color.purple)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
            }
            Spacer()
        }
        .padding()
    }
    
    // Add this computed property for the network architecture visualization
    private var networkArchitectureView: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("3. Feed-Forward Network Architecture")
                .font(.title)
                .fontWeight(.semibold)
            
            Text("A feed-forward network consists of multiple layers stacked together. Each layer applies a linear transformation followed by an activation function. The information flows from input through hidden layers to output, with no backward connections.")
                .font(.body)
                .lineSpacing(8)
            
            // Network architecture visualization
            HStack {
                Spacer()
                VStack {
                    HStack(spacing: 60) {
                        // Input Layer
                        VStack(spacing: 15) {
                            ForEach(0..<4, id: \.self) { _ in
                                Circle()
                                    .fill(Color.yellow)
                                    .frame(width: 40, height: 40)
                                    .overlay(Circle().stroke(Color.black, lineWidth: 1))
                            }
                        }
                        
                        // Hidden Layer 1
                        VStack(spacing: 15) {
                            ForEach(0..<5, id: \.self) { _ in
                                Circle()
                                    .fill(Color.blue)
                                    .frame(width: 40, height: 40)
                                    .overlay(Circle().stroke(Color.black, lineWidth: 1))
                            }
                        }
                        
                        // Hidden Layer 2
                        VStack(spacing: 15) {
                            ForEach(0..<5, id: \.self) { _ in
                                Circle()
                                    .fill(Color.blue)
                                    .frame(width: 40, height: 40)
                                    .overlay(Circle().stroke(Color.black, lineWidth: 1))
                            }
                        }
                        
                        // Output Layer
                        VStack(spacing: 15) {
                            ForEach(0..<3, id: \.self) { _ in
                                Circle()
                                    .fill(Color.green)
                                    .frame(width: 40, height: 40)
                                    .overlay(Circle().stroke(Color.black, lineWidth: 1))
                            }
                        }
                    }
                    .background {
                        // Draw connections between layers
                        ConnectionsView()
                    }
                    
                    // Layer labels
                    HStack(spacing: 60) {
                        Text("Input")
                            .frame(width: 40)
                        Text("Hid1")
                            .frame(width: 40)
                        Text("Hid2")
                            .frame(width: 40)
                        Text("Output")
                            .frame(width: 40)
                    }
                    .font(.caption)
                }
                Spacer()
            }
        }
        .padding()
    }
    
    // Add this struct for drawing connections between layers
    struct ConnectionsView: View {
        var body: some View {
            GeometryReader { geometry in
                let width = geometry.size.width
                let height = geometry.size.height
                
                Path { path in
                    // Draw connections between layers
                    for fromLayer in 0..<3 {
                        let startX = CGFloat(fromLayer) * (width/3-12) + 20
                        let endX = startX + (width/3-12)
                        
                        let startNodes = fromLayer == 0 ? 4 : 5
                        let endNodes = fromLayer == 2 ? 3 : 5
                        
                        // Calculate vertical offsets to center each layer
                        let startOffset = (height - CGFloat(startNodes) * 55) / 2
                        let endOffset = (height - CGFloat(endNodes) * 55) / 2
                        
                        for i in 0..<startNodes {
                            let startY = startOffset + CGFloat(i) * 55 + 25
                            
                            for j in 0..<endNodes {
                                let endY = endOffset + CGFloat(j) * 55 + 25
                                
                                path.move(to: CGPoint(x: startX, y: startY))
                                path.addLine(to: CGPoint(x: endX, y: endY))
                            }
                        }
                    }
                }
                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
            }
        }
    }
    
    // MARK: - Body
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                headerView
                
                // Feed-Forward Network Section
                VStack(alignment: .leading, spacing: 20) {
                    Text("1. Single Layer Network")
                        .font(.title)
                        .fontWeight(.semibold)

                    Text("A single layer network transforms input data through two steps: linear transformation (matrix multiplication) and non-linear activation. This is the fundamental building block of neural networks. The linear transformation is actually matrix vector multiplication.")
                        .font(.body)
                        .lineSpacing(8)

                    Text("Let's take the example from previous chapter, where we have the following matrix and vector:")
                        .font(.body)
                        .lineSpacing(8)

                    multiplicatitonView

                    Text("This process can also be drawn as:")
                        .font(.body)
                        .lineSpacing(8)

                    networkVisualizationView
                }
                .padding()

                Divider()
                    .padding(.horizontal)

                // Activation Function Section
                VStack(alignment: .leading, spacing: 20) {
                    Text("2. Activation Functions")
                        .font(.title)
                        .fontWeight(.semibold)

                    Text("Activation functions introduce non-linearity into the network. If we just using matrix multiplication in every network layer, the overall effect would equal to apply matrix multiplication once. So in the second part of a network layer, we want to introduce activation function to improve the fitting ability of the network.")
                        .font(.body)
                        .lineSpacing(8)

                    Text("Common Activation Functions:")
                        .font(.headline)
                        .padding(.top)
                    
                    VStack(alignment: .leading, spacing: 30) {
                        // ReLU section
                        VStack(alignment: .leading, spacing: 10) {
                            Text("a. ReLU (Rectified Linear Unit)")
                                .font(.title3)
                                .fontWeight(.semibold)
                            
                            Text("The most popular activation function in modern neural networks. It's simple yet effective: outputs the input directly if it's positive, and zero otherwise. This helps networks learn non-linear patterns while avoiding the vanishing gradient problem.")
                                .font(.body)
                                .lineSpacing(8)
                            
                            HStack {
                                reluGraph
                                reluExampleView
                            }
                        }
                        
                        // Sigmoid section
                        VStack(alignment: .leading, spacing: 10) {
                            Text("b. Sigmoid")
                                .font(.title3)
                                .fontWeight(.semibold)
                            
                            Text("Squashes input values into the range (0,1). Historically popular but less used in hidden layers now due to the vanishing gradient problem. Still useful for binary classification output layers.")
                                .font(.body)
                                .lineSpacing(8)
                            
                            HStack {
                                sigmoidGraph
                                sigmoidExampleView
                            }
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.white)
                            .shadow(
                                color: Color.black.opacity(0.1),
                                radius: 10,
                                x: 0,
                                y: 5
                            )
                    )
                }
                .padding()

                Divider()
                    .padding(.horizontal)

                networkArchitectureView
            }
            .background(Color.white)
        }
        .background(Color.gray.opacity(0.1))
    }

    func playMatrixMultiplication() {
        let row = 2
        let col = 3
        var rowIndex = 0
        var colIndex = 0
        animationEnable = false
        
        // Reset values
        currentOutputValues = [0.0, 0.0]
        connectProgress = Array(repeating: Array(repeating: 0.0, count: 3), count: 2)
        
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { timer in
            if rowIndex == row {
                timer.invalidate()
                res.weight = resWeight
                animationEnable = true
            } else {
                let currentRowIndex = rowIndex
                let currentColIndex = colIndex
                
                if currentColIndex == col {
                    res.weight[currentRowIndex] *= 2
                    matrix.vectorListWeight[currentRowIndex] = firstMatrixWeight[currentRowIndex]
                    vec.weight = vecWeight
                    colIndex = 0
                    rowIndex += 1
                } else {
                    matrix.vectorListWeight[currentRowIndex][currentColIndex] *= 2
                    withAnimation(.easeInOut(duration: 0.5)) {
                        connectProgress[currentRowIndex][currentColIndex] = 1.0
                        // Update current output value by adding the contribution from this connection
                        currentOutputValues[currentRowIndex] += vecWeight[currentColIndex] * firstMatrixWeight[currentRowIndex][currentColIndex]
                    }
                    vec.weight[colIndex] *= 2
                    colIndex += 1
                }
            }
        }
    }

    // Add this function for ReLU animation
    private func animateRelu() {
        if isShowingRelu {
            // Reset
            withAnimation(.easeInOut(duration: 0.5)) {
                postReluValues = preReluValues
                isShowingRelu = false
            }
        } else {
            // Apply ReLU
            withAnimation(.easeInOut(duration: 0.5)) {
                postReluValues = preReluValues.map { max(0, $0) }
                isShowingRelu = true
            }
        }
    }

    // Add this function for sigmoid animation
    private func animateSigmoid() {
        if isShowingSigmoid {
            // Reset
            withAnimation(.easeInOut(duration: 0.5)) {
                postSigmoidValues = preSigmoidValues
                isShowingSigmoid = false
            }
        } else {
            // Apply Sigmoid
            withAnimation(.easeInOut(duration: 0.5)) {
                postSigmoidValues = preSigmoidValues.map { 1.0 / (1.0 + exp(-$0))}
                postSigmoidValues = postSigmoidValues.map {Double(round(100 * $0) / 100)}
                isShowingSigmoid = true
            }
        }
    }
}

// MARK: - Supporting Views
struct NetworkNode: View {
    let value: Double
    let color: Color
    @Binding var position: [CGPoint]
    let index: Int
    
    var body: some View {
        Circle()
            .stroke(Color.black, lineWidth: 2)
            .frame(width: 50, height: 50)
            .overlay {
                Text(String(format: "%.2f", value))
            }
            .background {
                GeometryReader { geo in
                    ZStack {
                        Circle().fill(Color.white)
                        Circle().fill(color.opacity(value))
                    }
                    .onAppear {
                        let point = CGPoint(
                            x: geo.frame(in: .named("ffnRootView")).midX,
                            y: geo.frame(in: .named("ffnRootView")).midY
                        )
                        DispatchQueue.main.async {
                            position.append(point)
                        }
                    }
                }
            }
    }
}

struct ConnectionLinesView: View {
    let inputPositions: [CGPoint]
    let outputPositions: [CGPoint]
    let weights: [[Double]]
    let progress: [[Double]]
    
    var body: some View {
        ZStack {
            if outputPositions.count == 2 {
                ForEach(0..<3, id: \.self) { inIdx in
                    ForEach(0..<2, id: \.self) { outIdx in
                        Path { path in
                            path.move(to: inputPositions[inIdx])
                            path.addLine(to: outputPositions[outIdx])
                        }
                        .trim(from: 0, to: progress[1-outIdx][2-inIdx])
                        .stroke(Color.green.opacity(weights[1-outIdx][2-inIdx]), lineWidth: 2)
                    }
                }
            }
        }
    }
}

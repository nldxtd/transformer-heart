//
//  OverviewView.swift
//  Transformer Heart
//
//  Created by nldxtd on 2025/2/10.
//


import SwiftUI

struct EmbeddingSubView: View {

    @State private var embeddingMatrix: VectorListViewModel = VectorListViewModel(matrixWeight: embeddingMatrixWeight)

    var body: some View {
        HStack(spacing: 30) {
            // Input Tokens to embedding process
            VStack(alignment: .trailing, spacing: 20) {
                Text("Tokens")
                    .font(.headline)
                    .foregroundColor(.gray)
                
                VStack(alignment: .trailing, spacing: 8) {
                    ForEach(tokens, id: \.self) { token in
                        Text(token)
                            .font(.system(size: 10, weight: .medium, design: .monospaced))
                            .padding(.horizontal, 8)
                            .frame(height: 15)
                            .background(
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(Color.blue.opacity(0.1))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 4)
                                            .stroke(Color.blue.opacity(0.3), lineWidth: 1)
                                    )
                            )
                    }
                }
            }
            .frame(width: 120)
            
            // Embedding Output
            VStack(alignment: .leading, spacing: 20) {
                Text("Embeddings")
                    .font(.headline)
                    .foregroundColor(.gray)
                
                VectorList(
                    dimention: 10,
                    vectors: embeddingMatrix,
                    labels: embeddingMatrixWeight,
                    color: .green,
                    defaultWidth: 5,
                    defaultHeight: 15,
                    spacing: 8,
                    title: "",
                    matrixMode: false
                )
            }
        }
        .padding(20)
    }
}

struct AttentionKQVSubView: View {

    @State private var qMatrixView: VectorListViewModel = VectorListViewModel(matrixWeight: qMatrix)
    @State private var kMatrixView: VectorListViewModel = VectorListViewModel(matrixWeight: kMatrix)
    @State private var vMatrixView: VectorListViewModel = VectorListViewModel(matrixWeight: vMatrix)
    @State private var dotHeadView: AttentionHeadViewModel = AttentionHeadViewModel(headWeight: dotHeadWeight)

    @State private var scale: CGFloat = 1.0
    @State private var kPosition: CGPoint = CGPoint(x: 0, y: 0)
    @State private var qPosition: CGPoint = CGPoint(x: 0, y: 0)
    @State private var vPosition: CGPoint = CGPoint(x: 0, y: 0)
    @State private var attentionHeadPosition: CGPoint = CGPoint(x: 0, y: 0)
    @State private var kPositions: [CGPoint] = []
    @State private var qPositions: [CGPoint] = []
    @State private var horizontalHeadPositions: [CGPoint] = []
    @State private var verticalHeadPositions: [CGPoint] = []
    @State private var attentionProgress: CGFloat = 0
    @State private var smMultipleProgress: CGFloat = 0

    var body: some View {
        // KQV section
        ZStack {
            HStack(alignment: .center, spacing: 40) {
                // KQV vectors
                VStack(spacing: 20) {
                    // Key Vector
                    VectorList(
                        dimention: 10,
                        vectors: kMatrixView,
                        labels: kMatrix,
                        color: .green,
                        defaultWidth: 3,
                        defaultHeight: 10,
                        spacing: 5,
                        title: "key",
                        matrixMode: false
                    )
                    .background {
                        GeometryReader { geo in
                            Color.clear
                            .onAppear {
                                kPosition = CGPoint(
                                    x: geo.frame(in: .named("attentionBlock")).maxX+5,
                                    y: geo.frame(in: .named("attentionBlock")).maxY-5
                                )
                            }
                        }
                    }

                    // Query Vector
                    VectorList(
                        dimention: 10,
                        vectors: qMatrixView,
                        labels: qMatrix,
                        color: .orange,
                        defaultWidth: 3,
                        defaultHeight: 10,
                        spacing: 5,
                        title: "query",
                        matrixMode: false
                    )
                    .background {
                        GeometryReader { geo in
                            Color.clear
                            .onAppear {
                                qPosition = CGPoint(
                                    x: geo.frame(in: .named("attentionBlock")).maxX+5,
                                    y: geo.frame(in: .named("attentionBlock")).maxY-5
                                )
                            }
                        }
                    }
                    
                    // Value Vector
                    VectorList(
                        dimention: 10,
                        vectors: vMatrixView,
                        labels: vMatrix,
                        color: .purple,
                        defaultWidth: 3,
                        defaultHeight: 10,
                        spacing: 5,
                        title: "value",
                        matrixMode: false
                    )
                    .background {
                        GeometryReader { geo in
                            Color.clear
                            .onAppear {
                                vPosition = CGPoint(
                                    x: geo.frame(in: .named("attentionBlock")).maxX+5,
                                    y: geo.frame(in: .named("attentionBlock")).maxY-5
                                )
                            }
                        }
                    }
                }
                .padding()
                
                // Attention head with title
                VStack(alignment: .center, spacing: 8) {
                    Text("Attention Head")
                        .font(.headline)
                        .foregroundColor(.gray)
                    
                    AttentionHeadView(
                        head: tokens.count,
                        headViewModel: dotHeadView,
                        title: "",
                        circleScale: $scale
                    )
                    .background(
                        GeometryReader { geo in
                            Color.clear
                                .onAppear {
                                    attentionHeadPosition = CGPoint(
                                        x: geo.frame(in: .named("attentionBlock")).minX + 10,
                                        y: geo.frame(in: .named("attentionBlock")).minY + 10
                                    )
                                }
                        }
                    )
                }
                .offset(y: -4)
                .padding()

                VectorList(
                    dimention: 10,
                    vectors: kMatrixView,
                    labels: kMatrix,
                    color: .gray,
                    defaultWidth: 3,
                    defaultHeight: 10,
                    spacing: 5,
                    title: "out",
                    matrixMode: false
                )
                .padding(.trailing, 10)
            }
            .background {
                if verticalHeadPositions.count == tokens.count {
                    ForEach(0..<tokens.count) { i in
                        HorizontalCurveConnection(
                            start: qPositions[i],
                            end: verticalHeadPositions[tokens.count - 1 - i],
                            color: .orange,
                            progress: attentionProgress
                        )
                        VerticalCurveConnection(
                            start: kPositions[i],
                            end: horizontalHeadPositions[tokens.count - 1 - i],
                            color: .green,
                            progress: attentionProgress
                        )
                    }
                    let vTopPosition: CGPoint = CGPoint(x: vPosition.x, y: vPosition.y - 75)
                    let smHeadPosition: CGPoint = CGPoint(
                        x: attentionHeadPosition.x+130, y: attentionHeadPosition.y)
                    let smBottomPosition: CGPoint = CGPoint(
                        x: smHeadPosition.x, y: smHeadPosition.y + 110)
                    let valueTopEndPosition: CGPoint = CGPoint(
                        x: smHeadPosition.x + 40, y: smHeadPosition.y + 22)
                    let valueBottomEndPotision: CGPoint = CGPoint(
                        x: smHeadPosition.x + 40, y: smHeadPosition.y + 88)
                    AnimatedCurveShape(
                        corner1: vTopPosition,
                        corner2: valueTopEndPosition,
                        corner3: valueBottomEndPotision,
                        corner4: vPosition,
                        progress: smMultipleProgress
                    )
                    .fill(Color.purple.opacity(0.3))
                    AnimatedCurveShape(
                        corner1: smHeadPosition,
                        corner2: valueTopEndPosition,
                        corner3: valueBottomEndPotision,
                        corner4: smBottomPosition,
                        progress: smMultipleProgress
                    )
                    .fill(Color.blue.opacity(0.3))
                }
            }
        }
        .coordinateSpace(name: "attentionBlock")
        .onAppear {
            // withAnimation(.easeInOut(duration: 1.0).delay(1.0)) {
            //     scale = 1.0
            // }
            DispatchQueue.main.asyncAfter(deadline: .now()+1.5) {
                calculatePositions()
                withAnimation(.easeInOut(duration: 1.0)) {
                    attentionProgress = 1.0
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now()+2.5) {
                withAnimation(.easeInOut(duration: 1.0)) {
                    smMultipleProgress = 1.0
                }
            }
        }
    }

    private func calculatePositions() {
        for i in 0..<tokens.count {
            kPositions.append(CGPoint(x: kPosition.x, y: kPosition.y - CGFloat(i * 15)))
            qPositions.append(CGPoint(x: qPosition.x, y: qPosition.y - CGFloat(i * 15)))
            horizontalHeadPositions.append(
                CGPoint(x: attentionHeadPosition.x + CGFloat(i * 22), y: attentionHeadPosition.y))
            verticalHeadPositions.append(
                CGPoint(x: attentionHeadPosition.x, y: attentionHeadPosition.y + CGFloat(i * 22)))
        }
    }
}

struct FFNSubView: View {
    @State private var outputVectors: VectorListViewModel = VectorListViewModel(matrixWeight: feedForwardMatrixWeight)
    @State private var hiddenVectors: [VectorViewModel] = (0..<6).map { idx in 
        VectorViewModel(weight: hiddenLayerMatrixWeight[idx])
    }
    @State private var hiddenVectorPosition: CGPoint = CGPoint(x: 0, y: 0)
    @State private var outputVectorPosition: CGPoint = CGPoint(x: 0, y: 0)
    @State private var hiddenVectorPositions: [CGPoint] = []
    @State private var outputVectorPositions: [CGPoint] = []
    @State private var outputProgress: CGFloat = 0
    
    var body: some View {
        ZStack {
            HStack(alignment: .center, spacing: 20) { 
                // Hidden layer (up-dimensioned)
                VStack(spacing: 15) {
                    Text("hidden")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    VStack(spacing: 8) {
                        ForEach(0..<hiddenVectors.count, id: \.self) { i in
                            VerticalVectorView(
                                dimention: 15,
                                vector: hiddenVectors[i],
                                labels: hiddenLayerMatrixWeight[i].map{String($0)},
                                color: .orange,
                                defaultWidth: 10,
                                defaultHeight: 5,
                                spacing: 0
                            )
                        }
                    }
                    .background {
                        GeometryReader { geo in
                            Color.clear
                                .onAppear {
                                    hiddenVectorPosition = CGPoint(x: geo.frame(in: .named("ffnBlock")).maxX, y: geo.frame(in: .named("ffnBlock")).maxY)
                                }
                        }
                    }
                }
                
                // Output vectors
                VectorList(
                    dimention: 10,
                    vectors: outputVectors,
                    labels: feedForwardMatrixWeight,
                    color: .green,
                    defaultWidth: 3,
                    defaultHeight: 10,
                    spacing: 5,
                    title: "output",
                    matrixMode: false
                )
                .background {
                    GeometryReader { geo in
                        Color.clear
                            .onAppear {
                                outputVectorPosition = CGPoint(x: geo.frame(in: .named("ffnBlock")).minX, y: geo.frame(in: .named("ffnBlock")).maxY)
                            }
                    }
                }
            }
            .background {
                if hiddenVectorPositions.count == 2*hiddenVectors.count {
                    ForEach(0..<hiddenVectors.count) { i in
                        AnimatedCurveShape(
                            corner1: hiddenVectorPositions[2*i],
                            corner2: outputVectorPositions[2*i],
                            corner3: outputVectorPositions[2*i+1],
                            corner4: hiddenVectorPositions[2*i+1],
                            progress: outputProgress
                        )
                        .fill(Color.green.opacity(0.3))
                    }
                }
            }
        }
        .coordinateSpace(name: "ffnBlock")
        .padding()
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now()+1.5) {
                calculatePositions()
                withAnimation(.easeInOut(duration: 1.0)) {
                    outputProgress = 1.0
                }
            }
        }
    }
    
    private func calculatePositions() {
        for i in 0..<hiddenVectors.count {
            hiddenVectorPositions.append(CGPoint(x: hiddenVectorPosition.x+2, y: hiddenVectorPosition.y - CGFloat(i * 83)))
            hiddenVectorPositions.append(CGPoint(x: hiddenVectorPosition.x+2, y: hiddenVectorPosition.y - 75 - CGFloat(i * 83)))
            outputVectorPositions.append(CGPoint(x: outputVectorPosition.x-2, y: outputVectorPosition.y - CGFloat(i * 15)))
            outputVectorPositions.append(CGPoint(x: outputVectorPosition.x-2, y: outputVectorPosition.y - 10 - CGFloat(i * 15)))
        }
    }
}

struct PredictionSubView: View {
    // Calculate softmax probabilities from logits
    static let probabilities: [Double] = {
        let logits = [-0.5, -0.8, -1.0, -1.2, -1.5, -2.0, -2.5, -15]
        let expValues = logits.map { exp($0) }
        let sum = expValues.reduce(0, +)
        return expValues.map { $0 / sum }
    }()
    
    static let tokenLabels = ["visualize", "understand", "see", "explore", "create", "easily", "build", "⋮"]

    // Create a 25-dimension vector with probabilities distributed randomly
    static let mockLogitVector: [Double] = {
        var probVector = Array(repeating: 0.0, count: 25)
        for (idx, prob) in zip(indices, probabilities) {
            probVector[idx] = prob
        }
        return probVector
    }()

    static let mockLabelVector: [String] = {
        var labelVector = Array(repeating: "", count: 25)
        for (idx, label) in zip(indices, tokenLabels) {
            labelVector[idx] = label
        }
        return labelVector
    }()

    @State private var logitVector: VectorViewModel = VectorViewModel(weight: mockLogitVector.map { $0+0.1 })
    @State private var labelVector: [String] = mockLabelVector
    @State private var showProbabilities = false
    @Binding var indexSelected: Int
    
    var body: some View {
        HStack(spacing: 40) {
            // Logit vector
            VStack(spacing: 15) {
                Text("logits")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                VerticalVectorView(
                    dimention: 25,
                    vector: logitVector,
                    labels: labelVector,
                    color: .blue,
                    defaultWidth: 70,
                    defaultHeight: 25,
                    spacing: 1,
                    withLabel: true
                )
            }

            // Token probabilities
            HStack(alignment: .center, spacing: 16) {
                VStack(alignment: .trailing) {
                    Text("Tokens")
                        .font(.subheadline)
                    VStack(alignment: .trailing, spacing: 8) {
                        ForEach(Self.tokenLabels.indices, id: \.self) { index in
                            Text(Self.tokenLabels[index])
                                .font(.system(size: 10, weight: .medium, design: .monospaced))
                                .padding(.horizontal, 8)
                                .frame(height: 15)
                                .background(
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(index == indexSelected ? Color.purple.opacity(0.1) : Color.gray.opacity(0.1))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 4)
                                                .stroke(index == indexSelected ? Color.purple.opacity(0.3) : Color.gray.opacity(0.3), lineWidth: 1)
                                        )
                                )
                        }
                    }
                }
                VStack(alignment: .leading) {
                    Text("Probability")
                        .font(.subheadline)
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(Self.probabilities.indices, id: \.self) { index in
                            HStack(spacing: 8) {
                                Rectangle()
                                    .frame(width: CGFloat(Self.probabilities[index] * 150), height: 6)
                                    .foregroundColor(.blue)
                                Text(String(format: "%.2f%%", Self.probabilities[index]))
                                    .font(.system(size: 10, weight: .medium, design: .monospaced))
                                    .padding(.horizontal, 8)
                                    .frame(height: 15)
                            }
                            .padding(.horizontal, 8)
                            .background(
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(index == indexSelected ? Color.purple.opacity(0.1) : Color.gray.opacity(0.1))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 4)
                                            .stroke(index == indexSelected ? Color.purple.opacity(0.3) : Color.gray.opacity(0.3), lineWidth: 1)
                                    )
                            )
                        }
                    }
                }
            }
        }
        .padding(.horizontal, 30)
        .padding(.vertical, 20)
        .onAppear {
            withAnimation(.easeInOut(duration: 0.8).delay(0.3)) {
                showProbabilities = true
            }
        }
    }
}

struct StackedBackground: View {
    var body: some View {
        ZStack {
            // Bottom layer (5th)
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                )
                .offset(x: 20, y: 20)
            
            // 4th layer
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                )
                .offset(x: 15, y: 15)
            
            // 3rd layer
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.gray.opacity(0.6), lineWidth: 1)
                )
                .offset(x: 10, y: 10)
            
            // 2nd layer
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.gray.opacity(0.8), lineWidth: 1)
                )
                .offset(x: 5, y: 5)
            
            // Top layer (main)
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.gray, lineWidth: 1)
                )
                .shadow(radius: 5)
        }
    }
}

struct OverviewView: View {
    @Binding var currentView: String
    var animationNamespace: Namespace.ID
    
    @Binding var scale: CGFloat
    @Binding var offset: CGSize
    @Binding var lastOffset: CGSize
    @State private var lastScale: CGFloat = 1.0
    @Binding var indexSelected: Int

    var body: some View {
        ScrollView([.horizontal, .vertical], showsIndicators: true) {
            content
                .scaleEffect(scale)
                .offset(offset)
                .gesture(
                    SimultaneousGesture(
                        MagnificationGesture()
                            .onChanged { value in
                                let delta = value / lastScale
                                lastScale = value
                                scale = min(max(scale * delta, 0.5), 2.0)
                            }
                            .onEnded { _ in
                                lastScale = 1.0
                            },
                        DragGesture()
                            .onChanged { value in
                                offset = CGSize(
                                    width: lastOffset.width + value.translation.width,
                                    height: lastOffset.height + value.translation.height
                                )
                            }
                            .onEnded { _ in
                                lastOffset = offset
                            }
                    )
                )
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var content: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Existing pipeline views
            HStack(alignment: .top, spacing: 40) {
                // Embedding section
                
                EmbeddingSubView()
                    .background {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.white)
                            .shadow(radius: 5)
                    }
                    .onTapGesture {
                        currentView = "Embedding Pipeline"
                    }

                AttentionKQVSubView()
                    .background(StackedBackground())
                    .onTapGesture {
                        currentView = "KQV Matrix Pipeline"
                    }

                FFNSubView()
                    .background {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.white)
                            .shadow(radius: 5)
                    }
                    .onTapGesture {
                        currentView = "Feed-Forward Network Pipeline"
                    }

                PredictionSubView(indexSelected: $indexSelected)
                    .background {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.white)
                            .shadow(radius: 5)
                    }
                    .onTapGesture {
                        currentView = "Prediction Pipeline"
                    }
            }
        }
        .padding(.horizontal, 10)
        .padding(.top, 20)
    }
}

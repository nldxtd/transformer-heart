//
//  AttentionHeadPipeline.swift
//  Transformer Heart
//
//  Created by nldxtd on 2025/1/12.
//

import SwiftUI

struct SingleAttentionHeadView: View {

    let tokens: [String] = ["USC", "is", "located", "near", "the", "downtown", "of"]
    let tokensId: [Int] = [9007, 58, 256, 174, 13, 347, 41]
    @State private var embeddingMatrix: VectorListViewModel = VectorListViewModel(matrixWeight: [
        [0.67, 0.47, 0.3, 0.41, 0.67, 0.62, 0.59, 0.66, 0.49, 0.49],
        [0.34, 0.6, 0.38, 0.35, 0.59, 0.63, 0.44, 0.63, 0.42, 0.64],
        [0.37, 0.41, 0.41, 0.68, 0.51, 0.64, 0.69, 0.48, 0.41, 0.34],
        [0.66, 0.51, 0.55, 0.56, 0.44, 0.58, 0.63, 0.57, 0.65, 0.6],
        [0.47, 0.48, 0.7, 0.32, 0.56, 0.4, 0.54, 0.36, 0.39, 0.5],
        [0.31, 0.54, 0.59, 0.7, 0.37, 0.49, 0.39, 0.34, 0.53, 0.37],
        [0.35, 0.44, 0.47, 0.55, 0.54, 0.39, 0.64, 0.4, 0.32, 0.54],
    ])
    @State private var qMatrixView: VectorListViewModel = VectorListViewModel(matrixWeight: [
        [0.88, 0.54, 0.75, 0.67, 0.81, 0.49, 0.42, 0.63, 0.63, 0.83],
        [0.45, 0.46, 0.52, 0.46, 0.89, 0.44, 0.72, 0.45, 0.66, 0.44],
        [0.7, 0.77, 0.59, 0.72, 0.48, 0.51, 0.99, 0.99, 0.73, 0.7],
        [0.68, 0.83, 0.79, 0.99, 0.74, 0.65, 0.43, 0.91, 0.91, 0.71],
        [0.73, 0.47, 0.82, 0.76, 0.47, 0.59, 0.4, 0.41, 0.96, 0.41],
        [0.53, 0.58, 0.85, 0.41, 0.94, 0.94, 0.59, 0.63, 0.42, 0.95],
        [0.82, 0.46, 0.64, 0.62, 0.63, 0.78, 0.57, 0.92, 0.61, 0.75],
    ])
    @State private var kMatrixView: VectorListViewModel = VectorListViewModel(matrixWeight: [
        [0.57, 0.48, 0.98, 0.56, 0.62, 0.6, 0.63, 0.7, 0.71, 0.88],
        [0.77, 0.57, 0.99, 0.53, 0.47, 0.74, 0.55, 0.9, 0.66, 0.49],
        [0.65, 0.54, 0.52, 0.52, 0.78, 0.93, 0.81, 0.82, 0.81, 0.69],
        [0.96, 0.59, 0.85, 0.57, 0.52, 0.99, 0.53, 0.7, 0.4, 0.97],
        [0.56, 0.48, 0.63, 0.47, 0.53, 0.58, 0.48, 0.51, 0.93, 0.97],
        [0.72, 0.77, 0.62, 0.85, 0.74, 0.45, 0.56, 0.74, 0.46, 0.66],
        [0.43, 0.55, 0.76, 0.77, 0.83, 0.53, 0.77, 0.41, 0.76, 0.78],
    ])
    @State private var vMatrixView: VectorListViewModel = VectorListViewModel(matrixWeight: [
        [0.91, 0.88, 0.58, 0.42, 0.47, 0.96, 0.76, 0.49, 0.46, 0.64],
        [0.98, 0.45, 0.74, 0.5, 0.68, 0.52, 0.57, 0.68, 0.75, 0.92],
        [0.75, 0.9, 0.71, 0.99, 0.57, 0.42, 0.79, 0.57, 0.72, 0.74],
        [0.77, 0.56, 0.88, 0.41, 0.87, 0.61, 0.56, 0.93, 0.77, 0.66],
        [0.64, 0.8, 0.96, 0.69, 0.61, 0.44, 0.68, 0.67, 0.88, 0.63],
        [0.55, 0.44, 0.97, 0.58, 0.47, 0.78, 0.7, 0.75, 0.57, 0.49],
        [0.45, 0.65, 0.6, 0.74, 0.61, 0.43, 0.69, 0.55, 0.58, 0.86],
    ])
    @State private var dotHeadView: AttentionHeadViewModel = AttentionHeadViewModel(headWeight: [
        [7.32, 7.3, 1.8, 4.8, 5.04, 12.86, 6.97],
        [11.89, 10.92, 1.26, 8.38, 7.37, 16.02, 16.47],
        [17.07, 19.68, 12.7, 17.06, 18.64, 7.85, 17.26],
        [11.99, 3.79, 19.56, 5.82, 10.51, 10.73, 11.34],
        [10.41, 11.39, 11.14, 2.6, 1.8, 18.58, 17.73],
        [17.49, 17.47, 11.96, 18.56, 8.21, 8.68, 5.0],
        [16.5, 2.75, 19.09, 17.27, 1.7, 1.34, 3.44],
    ])
    @State private var maskHeadView: AttentionHeadViewModel = AttentionHeadViewModel(
        headWeight: [
            [7.32, 7.3, 1.8, 4.8, 5.04, 12.86, 6.97],
            [11.89, 10.92, 1.26, 8.38, 7.37, 16.02, 16.47],
            [17.07, 19.68, 12.7, 17.06, 18.64, 7.85, 17.26],
            [11.99, 3.79, 19.56, 5.82, 10.51, 10.73, 11.34],
            [10.41, 11.39, 11.14, 2.6, 1.8, 18.58, 17.73],
            [17.49, 17.47, 11.96, 18.56, 8.21, 8.68, 5.0],
            [16.5, 2.75, 19.09, 17.27, 1.7, 1.34, 3.44],
        ])
    @State private var softHeadView: AttentionHeadViewModel = AttentionHeadViewModel(
        headWeight: [
            [7.32, 7.3, 1.8, 4.8, 5.04, 12.86, 6.97],
            [11.89, 10.92, 1.26, 8.38, 7.37, 16.02, 16.47],
            [17.07, 19.68, 12.7, 17.06, 18.64, 7.85, 17.26],
            [11.99, 3.79, 19.56, 5.82, 10.51, 10.73, 11.34],
            [10.41, 11.39, 11.14, 2.6, 1.8, 18.58, 17.73],
            [17.49, 17.47, 11.96, 18.56, 8.21, 8.68, 5.0],
            [16.5, 2.75, 19.09, 17.27, 1.7, 1.34, 3.44],
        ])
    @State private var kPosition: CGPoint = CGPoint(x: 0, y: 0)
    @State private var qPosition: CGPoint = CGPoint(x: 0, y: 0)
    @State private var vPosition: CGPoint = CGPoint(x: 0, y: 0)
    @State private var headPosition: CGPoint = CGPoint(x: 0, y: 0)
    @State private var kPositions: [CGPoint] = []
    @State private var qPositions: [CGPoint] = []
    @State private var horizontalHeadPositions: [CGPoint] = []
    @State private var verticalHeadPositions: [CGPoint] = []
    @State private var coordinatesReady: Bool = false
    @State private var animationProgress: CGFloat = 0
    @State private var scale: CGFloat = 0
    
    @State private var MaskVisible: Bool = false
    @State private var SoftmaxVisible: Bool = false

    @Binding var currentView: String
    var animationNamespace: Namespace.ID

    var body: some View {

        let vectorListHeight: CGFloat = CGFloat(15 * tokens.count + 20)
        let vectorListWidth: CGFloat = 48

        // The z-axis view
        ZStack {
            // Over all is a horizontal view
            HStack(spacing: 80) {
                // Represent of KQV vectors
                VStack(spacing: 80) {
                    GeometryReader { geo in
                        // Perform the side-effect (append points) in onAppear
                        VectorList(
                            dimention: 10,
                            vectors: kMatrixView,
                            color: .green,
                            defaultWidth: 3,
                            defaultHeight: 10,
                            spacing: 5,
                            vectorSpacing: 0,
                            title: "key",
                            titleWidth: 43,
                            titleHeight: 20
                        )
                        .matchedGeometryEffect(id: "kMatix", in: animationNamespace)
                        .frame(width: vectorListWidth, height: vectorListHeight)
                        .onAppear {
                            // Append the initial right-top point to the positions array
                            kPosition = CGPoint(
                                x: geo.frame(in: .named("rootView")).maxX+5,
                                y: geo.frame(in: .named("rootView")).maxY-5
                            )
                        }
                    }
                    .frame(width: vectorListWidth, height: vectorListHeight)

                    GeometryReader { geo in
                        // Perform the side-effect (append points) in onAppear
                        VectorList(
                            dimention: 10,
                            vectors: qMatrixView,
                            color: .orange,
                            defaultWidth: 3,
                            defaultHeight: 10,
                            spacing: 5,
                            vectorSpacing: 0,
                            title: "query",
                            titleWidth: 48,
                            titleHeight: 20
                        )
                        .matchedGeometryEffect(id: "qMatix", in: animationNamespace)
                        .frame(width: vectorListWidth, height: vectorListHeight)
                        .onAppear {
                            // Append the initial right-top point to the positions array
                            qPosition = CGPoint(
                                x: geo.frame(in: .named("rootView")).maxX+5,
                                y: geo.frame(in: .named("rootView")).maxY-5
                            )
                        }
                    }
                    .frame(width: vectorListWidth, height: vectorListHeight)

                    GeometryReader { geo in
                        // Perform the side-effect (append points) in onAppear
                        VectorList(
                            dimention: 10,
                            vectors: vMatrixView,
                            color: .purple,
                            defaultWidth: 3,
                            defaultHeight: 10,
                            spacing: 5,
                            vectorSpacing: 0,
                            title: "value",
                            titleWidth: 43,
                            titleHeight: 20
                        )
                        .matchedGeometryEffect(id: "vMatix", in: animationNamespace)
                        .frame(width: vectorListWidth, height: vectorListHeight)
                        .onAppear {
                            // Append the initial right-top point to the positions array
                            vPosition = CGPoint(
                                x: geo.frame(in: .named("rootView")).maxX+5,
                                y: geo.frame(in: .named("rootView")).maxY-5
                            )
                        }
                    }
                    .frame(width: vectorListWidth, height: vectorListHeight)
                }

                HStack {
                    // Represent of dot-product calculation
                    AttentionHeadView(
                        head: tokens.count,
                        headViewModel: dotHeadView,
                        title: "Dot Product",
                        circleScale: $scale
                    )
                    .overlay(
                        GeometryReader { geo in
                            Color.clear
                                .onAppear {
                                    headPosition = CGPoint(
                                        x: geo.frame(in: .named("rootView")).minX+10,
                                        y: geo.frame(in: .named("rootView")).minY+10
                                    )
                                }
                        }
                        .border(Color.red)
                    )
                    
                    HStack {
                        // Right arrow
                        Image(systemName: "arrow.right")
                            .offset(y: -25)

                        // Represent of scaling and mask
                        AttentionHeadView(
                            head: tokens.count,
                            headViewModel: maskHeadView,
                            title: "Scaling · Mask",
                            circleScale: $scale
                        )
                    }
                    .opacity(MaskVisible ? 1 : 0)
                    .offset(x: MaskVisible ? 0 : -30)

                    HStack {
                        // Right arrow
                        Image(systemName: "arrow.right")
                            .offset(y: -25)

                        // Represent of Softmax and dropout
                        AttentionHeadView(
                            head: tokens.count,
                            headViewModel: softHeadView,
                            title: "Softmax · Dropout",
                            circleScale: $scale
                        )
                    }
                    .opacity(SoftmaxVisible ? 1 : 0)
                    .offset(x: SoftmaxVisible ? 0 : -30)
                }
                .offset(y: 60)

                VectorList(
                    dimention: 10,
                    vectors: embeddingMatrix,
                    color: .gray,
                    defaultWidth: 12,
                    defaultHeight: 13,
                    spacing: 2,
                    title: "Embedding Matrix",
                    matrixMode: true
                )
                .matchedGeometryEffect(id: "EmbeddingMatrix", in: animationNamespace)
            }
            .background {
                if verticalHeadPositions.count == tokens.count {
                    ForEach(0..<tokens.count) { i in
                        HorizontalCurveConnection(
                            start: qPositions[i],
                            end: verticalHeadPositions[tokens.count-1-i],
                            color: .orange,
                            progress: animationProgress
                        )
                        VerticalCurveConnection(
                            start: kPositions[i],
                            end: horizontalHeadPositions[tokens.count-1-i],
                            color: .green,
                            progress: animationProgress
                        )
                    }
                }
            }
        }
        .coordinateSpace(name: "rootView")
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                calculatePositions()
                withAnimation(.easeInOut(duration: 1.0)) {
                    animationProgress = 1.0
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation(.easeInOut(duration: 1.0)) {
                    scale = 1.0
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                withAnimation(.easeInOut(duration: 0.5)) {
                    MaskVisible = true
                    for i in 0..<tokens.count {
                        for j in i+1..<tokens.count {
                            maskHeadView.headWeight[i][j] = 0
                        }
                    }
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                withAnimation(.easeInOut(duration: 0.5)) {
                    SoftmaxVisible = true
                }
            }
        }
    }

    private func calculatePositions() {
        for i in 0..<tokens.count {
            kPositions.append(CGPoint(x: kPosition.x, y: kPosition.y - CGFloat(i * 15)))
            qPositions.append(CGPoint(x: qPosition.x, y: qPosition.y - CGFloat(i * 15)))
            horizontalHeadPositions.append(CGPoint(x: headPosition.x + CGFloat(i * 22), y: headPosition.y))
            verticalHeadPositions.append(CGPoint(x: headPosition.x, y: headPosition.y + CGFloat(i * 22)))
        }
    }
}

struct AttentionHeadPipeline_Previews: PreviewProvider {
    static var previews: some View {
        @Namespace var namespace
        return SingleAttentionHeadView(
            currentView: .constant("AttentionHeadPipiline"),
            animationNamespace: namespace
        )
    }
}

//
//  AttentionQKVPipeline.swift
//  Transformer Heart
//
//  Created by nldxtd on 2025/1/11.
//

import Foundation
import SwiftUI

struct AttentionQKVView: View {
    let tokens: [String] = ["USC", "is", "located", "near", "the", "downtown", "of"]
    let tokensId: [Int] = [9007, 58, 256, 174, 13, 347, 41]
    @State private var embeddingMatrix: VectorListViewModel = VectorListViewModel(matrixWeight: [
        [0.67, 0.47, 0.3, 0.41, 0.67, 0.62, 0.59, 0.66, 0.49, 0.49],
        [0.34, 0.6, 0.38, 0.35, 0.59, 0.63, 0.44, 0.63, 0.42, 0.64],
        [0.37, 0.41, 0.41, 0.68, 0.51, 0.64, 0.69, 0.48, 0.41, 0.34],
        [0.66, 0.51, 0.55, 0.56, 0.44, 0.58, 0.63, 0.57, 0.65, 0.6],
        [0.47, 0.48, 0.7, 0.32, 0.56, 0.4, 0.54, 0.36, 0.39, 0.5],
        [0.31, 0.54, 0.59, 0.7, 0.37, 0.49, 0.39, 0.34, 0.53, 0.37],
        [0.35, 0.44, 0.47, 0.55, 0.54, 0.39, 0.64, 0.4, 0.32, 0.54]
    ])
    @State private var QKVMatrixWeight = MatrixViewModel(matrixWeight: [
        [0.24, 0.16, 0.38, 0.2, 0.28, 0.25, 0.2, 0.28, 0.25, 0.31, 0.33, 0.31, 0.27, 0.18, 0.21, 0.17, 0.32, 0.18, 0.33, 0.2, 0.34, 0.29, 0.18, 0.2, 0.37, 0.28, 0.35, 0.39, 0.21, 0.27],
        [0.25, 0.26, 0.31, 0.23, 0.17, 0.17, 0.28, 0.33, 0.33, 0.15, 0.35, 0.33, 0.25, 0.27, 0.36, 0.4, 0.17, 0.29, 0.38, 0.3, 0.2, 0.34, 0.28, 0.39, 0.18, 0.2, 0.38, 0.29, 0.4, 0.32],
        [0.24, 0.17, 0.37, 0.23, 0.27, 0.21, 0.37, 0.4, 0.15, 0.18, 0.27, 0.17, 0.23, 0.3, 0.3, 0.38, 0.23, 0.35, 0.37, 0.37, 0.29, 0.27, 0.28, 0.32, 0.3, 0.28, 0.23, 0.37, 0.4, 0.34],
        [0.18, 0.17, 0.4, 0.37, 0.4, 0.23, 0.36, 0.29, 0.36, 0.32, 0.15, 0.23, 0.16, 0.21, 0.21, 0.36, 0.36, 0.34, 0.2, 0.2, 0.38, 0.34, 0.26, 0.23, 0.19, 0.26, 0.2, 0.25, 0.2, 0.24],
        [0.2, 0.3, 0.18, 0.18, 0.31, 0.34, 0.31, 0.28, 0.16, 0.29, 0.16, 0.23, 0.2, 0.31, 0.2, 0.18, 0.24, 0.26, 0.31, 0.33, 0.23, 0.28, 0.27, 0.38, 0.17, 0.4, 0.22, 0.34, 0.39, 0.34],
        [0.25, 0.38, 0.28, 0.4, 0.39, 0.17, 0.18, 0.39, 0.3, 0.21, 0.23, 0.36, 0.24, 0.4, 0.35, 0.29, 0.27, 0.18, 0.38, 0.3, 0.28, 0.34, 0.15, 0.32, 0.34, 0.18, 0.36, 0.28, 0.34, 0.28],
        [0.38, 0.4, 0.18, 0.33, 0.34, 0.24, 0.34, 0.39, 0.17, 0.34, 0.39, 0.19, 0.2, 0.17, 0.23, 0.3, 0.38, 0.26, 0.23, 0.31, 0.36, 0.3, 0.23, 0.26, 0.38, 0.2, 0.36, 0.18, 0.19, 0.34],
        [0.2, 0.18, 0.21, 0.16, 0.23, 0.17, 0.17, 0.35, 0.35, 0.26, 0.25, 0.33, 0.15, 0.38, 0.4, 0.16, 0.19, 0.17, 0.32, 0.28, 0.28, 0.34, 0.21, 0.21, 0.19, 0.4, 0.34, 0.23, 0.36, 0.24],
        [0.35, 0.35, 0.19, 0.23, 0.35, 0.18, 0.34, 0.35, 0.38, 0.23, 0.31, 0.32, 0.22, 0.34, 0.36, 0.2, 0.23, 0.36, 0.23, 0.26, 0.34, 0.23, 0.34, 0.15, 0.33, 0.35, 0.37, 0.28, 0.38, 0.18],
        [0.34, 0.27, 0.24, 0.24, 0.21, 0.39, 0.19, 0.28, 0.4, 0.23, 0.32, 0.2, 0.33, 0.18, 0.27, 0.34, 0.34, 0.28, 0.32, 0.25, 0.21, 0.27, 0.34, 0.3, 0.35, 0.28, 0.23, 0.3, 0.35, 0.36]
    ])
    var qMatrix: [[Double]] = [
        [0.88, 0.54, 0.75, 0.67, 0.81, 0.49, 0.42, 0.63, 0.63, 0.83],
        [0.45, 0.46, 0.52, 0.46, 0.89, 0.44, 0.72, 0.45, 0.66, 0.44],
        [0.7, 0.77, 0.59, 0.72, 0.48, 0.51, 0.99, 0.99, 0.73, 0.7],
        [0.68, 0.83, 0.79, 0.99, 0.74, 0.65, 0.43, 0.91, 0.91, 0.71],
        [0.73, 0.47, 0.82, 0.76, 0.47, 0.59, 0.4, 0.41, 0.96, 0.41],
        [0.53, 0.58, 0.85, 0.41, 0.94, 0.94, 0.59, 0.63, 0.42, 0.95],
        [0.82, 0.46, 0.64, 0.62, 0.63, 0.78, 0.57, 0.92, 0.61, 0.75]
    ]
    @State private var qMatrixView: VectorListViewModel = VectorListViewModel(matrixWeight: Array(repeating: Array(repeating: 0, count: 10), count: 7))
    var kMatrix: [[Double]] = [
        [0.57, 0.48, 0.98, 0.56, 0.62, 0.6, 0.63, 0.7, 0.71, 0.88],
        [0.77, 0.57, 0.99, 0.53, 0.47, 0.74, 0.55, 0.9, 0.66, 0.49],
        [0.65, 0.54, 0.52, 0.52, 0.78, 0.93, 0.81, 0.82, 0.81, 0.69],
        [0.96, 0.59, 0.85, 0.57, 0.52, 0.99, 0.53, 0.7, 0.4, 0.97],
        [0.56, 0.48, 0.63, 0.47, 0.53, 0.58, 0.48, 0.51, 0.93, 0.97],
        [0.72, 0.77, 0.62, 0.85, 0.74, 0.45, 0.56, 0.74, 0.46, 0.66],
        [0.43, 0.55, 0.76, 0.77, 0.83, 0.53, 0.77, 0.41, 0.76, 0.78]
    ]
    @State private var kMatrixView: VectorListViewModel = VectorListViewModel(matrixWeight: Array(repeating: Array(repeating: 0, count: 10), count: 7))
    var vMatrix: [[Double]] = [
        [0.91, 0.88, 0.58, 0.42, 0.47, 0.96, 0.76, 0.49, 0.46, 0.64],
        [0.98, 0.45, 0.74, 0.5, 0.68, 0.52, 0.57, 0.68, 0.75, 0.92],
        [0.75, 0.9, 0.71, 0.99, 0.57, 0.42, 0.79, 0.57, 0.72, 0.74],
        [0.77, 0.56, 0.88, 0.41, 0.87, 0.61, 0.56, 0.93, 0.77, 0.66],
        [0.64, 0.8, 0.96, 0.69, 0.61, 0.44, 0.68, 0.67, 0.88, 0.63],
        [0.55, 0.44, 0.97, 0.58, 0.47, 0.78, 0.7, 0.75, 0.57, 0.49],
        [0.45, 0.65, 0.6, 0.74, 0.61, 0.43, 0.69, 0.55, 0.58, 0.86]
    ]
    @State private var vMatrixView: VectorListViewModel = VectorListViewModel(matrixWeight: Array(repeating: Array(repeating: 0, count: 10), count: 7))
    @State private var biasVector: VectorViewModel = VectorViewModel(weight: [0.18, 0.17, 0.4, 0.37, 0.4, 0.23, 0.36, 0.29, 0.36, 0.32, 0.15, 0.23, 0.16, 0.21, 0.21, 0.36, 0.36, 0.34, 0.2, 0.2, 0.38, 0.34, 0.26, 0.23, 0.19, 0.26, 0.2, 0.25, 0.2, 0.24])
    let isMatrixMode = true
    
    @State private var QKVMatrixVisible = false
    @State private var biasVectorVisible = false
    @State private var qkvVectorVisible = false
    
    @Binding var currentView: String
    var animationNamespace: Namespace.ID
    
    var body: some View {
        ZStack {
            HStack {
                VectorList(
                    dimention: 10,
                    vectors: embeddingMatrix,
                    color: .gray,
                    defaultWidth: isMatrixMode ? 12 : 10,
                    defaultHeight: isMatrixMode ? 13 : 30,
                    spacing: isMatrixMode ? 2 : 16,
                    title: isMatrixMode ? "Embedding Matrix" : "Embedding Output",
                    matrixMode: isMatrixMode
                )
                .offset(y: isMatrixMode ? -32 : -28)
                .matchedGeometryEffect(id: "EmbeddingMatrix", in: animationNamespace)
                
                HStack {
                    Text("*") // Multiple sign column header
                        .font(.headline)
                        .frame(width: 30, alignment: .center)
                    
                    KQVMatrixView(
                        row: 10,
                        col: 30,
                        matrixViewModel: QKVMatrixWeight
                    )
                }
                .offset(x: QKVMatrixVisible ? 0 : -20)
                .opacity(QKVMatrixVisible ? 1 : 0)
                .animation(.easeInOut(duration: 0.5), value: QKVMatrixVisible)
                
                HStack {
                    Text("+") // Plus sign
                        .font(.headline)
                        .frame(width: 30, alignment: .center)
                    
                    // Bias vector
                    VerticalVectorView (dimention: 30, vector: biasVector, title: "Bias")
                    
                    Text("=") // Plus sign
                        .font(.headline)
                        .frame(width: 30, alignment: .center)
                }
                .offset(x: biasVectorVisible ? 0 : -20)
                .opacity(biasVectorVisible ? 1 : 0)
                .animation(.easeInOut(duration: 0.5), value: biasVectorVisible)
                
                // Output vectors for each token
                HStack(alignment: .center, spacing: 10) {
                    VectorList(
                        dimention: 10,
                        vectors: qMatrixView,
                        color: .orange,
                        defaultWidth: 3,
                        defaultHeight: 10,
                        spacing: 5,
                        title: "q",
                        titleWidth: 43
                    )
                    .matchedGeometryEffect(id: "qMatrix", in: animationNamespace)
                    VectorList(
                        dimention: 10,
                        vectors: kMatrixView,
                        color: .green,
                        defaultWidth: 3,
                        defaultHeight: 10,
                        spacing: 5,
                        title: "k",
                        titleWidth: 43
                    )
                    .matchedGeometryEffect(id: "kMatix", in: animationNamespace)
                    VectorList(
                        dimention: 10,
                        vectors: vMatrixView,
                        color: .purple,
                        defaultWidth: 3,
                        defaultHeight: 10,
                        spacing: 5,
                        title: "v",
                        titleWidth: 43
                    )
                    .matchedGeometryEffect(id: "vMatrix", in: animationNamespace)
                }
                .offset(x: qkvVectorVisible ? 0 : -20)
                .opacity(qkvVectorVisible ? 1 : 0)
                .animation(.easeInOut(duration: 0.5), value: qkvVectorVisible)
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                QKVMatrixVisible = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                biasVectorVisible = true
                qkvVectorVisible = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                performMatrixMultiplication()
            }
        }
    }
    
    private func performMatrixMultiplication(duration: Double = 0.05) {
        let row = QKVMatrixWeight.matrixWeight.count
        let col = QKVMatrixWeight.matrixWeight[0].count
        var colIndex = 0
        var rowIndex = 0
        
        func startFirstTimer(completion: @escaping () -> Void) {
            biasVector.weight[0] *= 2
            qMatrixView.vectorListWeight[0][0] = qMatrix[0][0]
            Timer.scheduledTimer(withTimeInterval: duration, repeats: true) { timer in
                if rowIndex == row {
                    timer.invalidate()
                    embeddingMatrix.vectorListWeight[0] = embeddingMatrix.vectorListWeight[0].map {
                        $0/2
                    }
                    completion() // Proceed to the next step
                } else {
                    let currentRowIndex = rowIndex
                    embeddingMatrix.vectorListWeight[0][currentRowIndex] *= 2
                    QKVMatrixWeight.matrixWeight[currentRowIndex][colIndex] *= 2
                    rowIndex += 1
                }
            }
        }
        
        func startSecondTimer(completion: @escaping () -> Void) {
            colIndex = 1
            rowIndex = 0
            Timer.scheduledTimer(withTimeInterval: duration/3, repeats: true) { timer in
                biasVector.weight[1] *= 2
                qMatrixView.vectorListWeight[0][1] = qMatrix[0][1]
                // The first vector calculation is finished, reset kqv matrix and bias vector
                if rowIndex == row && colIndex == col-1 {
                    timer.invalidate()
                    embeddingMatrix.vectorListWeight[0] = embeddingMatrix.vectorListWeight[0].map {
                        $0/2
                    }
                    QKVMatrixWeight.matrixWeight = QKVMatrixWeight.matrixWeight.map {
                        $0.map { $0/2 }
                    }
                    biasVector.weight = biasVector.weight.map {
                        $0/2
                    }
                    completion() // Proceed to the next step
                } else {
                    // finish calculation on the column, reset embedding vector and light up next bias
                    if rowIndex == row {
                        embeddingMatrix.vectorListWeight[0] = embeddingMatrix.vectorListWeight[0].map {
                            $0/2
                        }
                        rowIndex = 0
                        colIndex += 1
                        biasVector.weight[colIndex] *= 2
                        if colIndex<10 {
                            qMatrixView.vectorListWeight[0][colIndex] = qMatrix[0][colIndex]
                        } else if colIndex<20 {
                            kMatrixView.vectorListWeight[0][colIndex-10] = kMatrix[0][colIndex-10]
                        } else {
                            vMatrixView.vectorListWeight[0][colIndex-20] = vMatrix[0][colIndex-20]
                        }
                    }
                    let currentRowIndex = rowIndex
                    embeddingMatrix.vectorListWeight[0][currentRowIndex] *= 2
                    QKVMatrixWeight.matrixWeight[currentRowIndex][colIndex] *= 2
                    rowIndex += 1
                }
            }
        }
        
        func startThirdTimer() {
            let repeatTime = tokens.count-1
            var repeatCount = 0
            colIndex = 0
            
            Timer.scheduledTimer(withTimeInterval: duration/10, repeats: true) { timer in
                // all calculation finished, reset the embedding matrix
                if repeatCount==repeatTime-1 && colIndex==col {
                    embeddingMatrix.vectorListWeight[repeatCount+1] = embeddingMatrix.vectorListWeight[repeatCount+1].map {
                        $0/2
                    }
                    timer.invalidate()
                } else {
                    // start of a new calculation, light the embedding vector
                    if colIndex == 0 {
                        embeddingMatrix.vectorListWeight[repeatCount+1] = embeddingMatrix.vectorListWeight[repeatCount+1].map {
                            $0*2
                        }
                    }
                    // end of a vector calculation, reset qkv matrix and bias vector
                    if colIndex == col {
                        colIndex = 0
                        repeatCount += 1
                        embeddingMatrix.vectorListWeight[repeatCount] = embeddingMatrix.vectorListWeight[repeatCount].map {
                            $0/2
                        }
                        embeddingMatrix.vectorListWeight[repeatCount+1] = embeddingMatrix.vectorListWeight[repeatCount+1].map {
                            $0*2
                        }
                        QKVMatrixWeight.matrixWeight = QKVMatrixWeight.matrixWeight.map {
                            $0.map { $0/2 }
                        }
                        biasVector.weight = biasVector.weight.map {
                            $0/2
                        }
                    }
                    let currentColIndex = colIndex
                    biasVector.weight[currentColIndex] *= 2
                    if colIndex<10 {
                        qMatrixView.vectorListWeight[repeatCount+1][currentColIndex] = qMatrix[repeatCount+1][currentColIndex]
                    } else if colIndex<20 {
                        kMatrixView.vectorListWeight[repeatCount+1][currentColIndex-10] = kMatrix[repeatCount+1][currentColIndex-10]
                    } else {
                        vMatrixView.vectorListWeight[repeatCount+1][currentColIndex-20] = vMatrix[repeatCount+1][currentColIndex-20]
                    }
                    for rowIndex in 0..<row {
                        QKVMatrixWeight.matrixWeight[rowIndex][currentColIndex] *= 2
                    }
                    colIndex += 1
                }
            }
        }
        
        // Chain the timers
        startFirstTimer {
            Thread.sleep(forTimeInterval: 0.5)
            startSecondTimer {
                Thread.sleep(forTimeInterval: 0.5)
                startThirdTimer()
            }
        }
    }
}

struct AttentionQKVView_Previews: PreviewProvider {
    static var previews: some View {
        @Namespace var namespace
        return AttentionQKVView(
            currentView: .constant("AttentionQKV"),
            animationNamespace: namespace
        )
    }
}

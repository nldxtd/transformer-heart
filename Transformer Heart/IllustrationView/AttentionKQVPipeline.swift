//
//  AttentionQKVPipeline.swift
//  Transformer Heart
//
//  Created by nldxtd on 2025/1/11.
//

import Foundation
import SwiftUI

struct AttentionQKVView: View {
    @State private var embeddingMatrix: VectorListViewModel = VectorListViewModel(
        matrixWeight: embeddingMatrixWeight)
    @State private var QKVMatrix = MatrixViewModel(matrixWeight: QKVMatrixWeight)
    @State private var qMatrixView: VectorListViewModel = VectorListViewModel(
        matrixWeight: Array(repeating: Array(repeating: 0, count: 10), count: 7))
    @State private var kMatrixView: VectorListViewModel = VectorListViewModel(
        matrixWeight: Array(repeating: Array(repeating: 0, count: 10), count: 7))
    @State private var vMatrixView: VectorListViewModel = VectorListViewModel(
        matrixWeight: Array(repeating: Array(repeating: 0, count: 10), count: 7))
    @State private var biasVector: VectorViewModel = VectorViewModel(weight: biasVectorWeight)
    let isMatrixMode = true

    @State private var QKVMatrixVisible = false
    @State private var biasVectorVisible = false
    @State private var qkvVectorVisible = false

    @Binding var currentView: String
    var animationNamespace: Namespace.ID

    var body: some View {
        ZStack {
            HStack {
                // Embedding Matrix
                VectorList(
                    dimention: 10,
                    vectors: embeddingMatrix,
                    color: .gray,
                    defaultWidth: 12,
                    defaultHeight: 13,
                    spacing: 2,
                    title: "Embedding Matrix",
                    matrixMode: isMatrixMode
                )
                .offset(y: -34)
                .matchedGeometryEffect(id: "EmbeddingMatrix", in: animationNamespace)

                Text("\u{00D7}")  // Multiple sign column header
                    .font(.headline)
                    .frame(width: 30, alignment: .center)
                    .opacity(QKVMatrixVisible ? 1 : 0)
                    .animation(.easeInOut(duration: 0.5), value: QKVMatrixVisible)

                KQVMatrixView(
                    row: 10,
                    col: 30,
                    matrixViewModel: QKVMatrix
                )
                .offset(x: QKVMatrixVisible ? 0 : -20, y: -45)
                .opacity(QKVMatrixVisible ? 1 : 0)
                .animation(.easeInOut(duration: 0.5), value: QKVMatrixVisible)

                HStack {
                    Text("+")  // Plus sign
                        .font(.headline)
                        .frame(width: 30, alignment: .center)

                    // Bias vector
                    VerticalVectorView(dimention: 30, vector: biasVector, title: "Bias")
                        .offset(y: -13)

                    Text("=")  // Plus sign
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
                .padding(.leading, 20)
                .offset(x: qkvVectorVisible ? 0 : -20, y: -20)
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
        let row = QKVMatrix.matrixWeight.count
        let col = QKVMatrix.matrixWeight[0].count
        var colIndex = 0
        var rowIndex = 0

        func startFirstTimer(completion: @escaping () -> Void) {
            biasVector.weight[0] *= 2
            qMatrixView.vectorListWeight[0][0] = qMatrix[0][0]
            Timer.scheduledTimer(withTimeInterval: duration, repeats: true) { timer in
                if rowIndex == row {
                    timer.invalidate()
                    embeddingMatrix.vectorListWeight[0] = embeddingMatrix.vectorListWeight[0].map {
                        $0 / 2
                    }
                    completion()  // Proceed to the next step
                } else {
                    let currentRowIndex = rowIndex
                    embeddingMatrix.vectorListWeight[0][currentRowIndex] *= 2
                    QKVMatrix.matrixWeight[currentRowIndex][colIndex] *= 2
                    rowIndex += 1
                }
            }
        }

        func startSecondTimer(completion: @escaping () -> Void) {
            colIndex = 1
            rowIndex = 0
            Timer.scheduledTimer(withTimeInterval: duration / 3, repeats: true) { timer in
                biasVector.weight[1] *= 2
                qMatrixView.vectorListWeight[0][1] = qMatrix[0][1]
                // The first vector calculation is finished, reset kqv matrix and bias vector
                if rowIndex == row && colIndex == col - 1 {
                    timer.invalidate()
                    embeddingMatrix.vectorListWeight[0] = embeddingMatrix.vectorListWeight[0].map {
                        $0 / 2
                    }
                    QKVMatrix.matrixWeight = QKVMatrix.matrixWeight.map {
                        $0.map { $0 / 2 }
                    }
                    biasVector.weight = biasVector.weight.map {
                        $0 / 2
                    }
                    completion()  // Proceed to the next step
                } else {
                    // finish calculation on the column, reset embedding vector and light up next bias
                    if rowIndex == row {
                        embeddingMatrix.vectorListWeight[0] = embeddingMatrix.vectorListWeight[0]
                            .map {
                                $0 / 2
                            }
                        rowIndex = 0
                        colIndex += 1
                        biasVector.weight[colIndex] *= 2
                        if colIndex < 10 {
                            qMatrixView.vectorListWeight[0][colIndex] = qMatrix[0][colIndex]
                        } else if colIndex < 20 {
                            kMatrixView.vectorListWeight[0][colIndex - 10] =
                                kMatrix[0][colIndex - 10]
                        } else {
                            vMatrixView.vectorListWeight[0][colIndex - 20] =
                                vMatrix[0][colIndex - 20]
                        }
                    }
                    let currentRowIndex = rowIndex
                    embeddingMatrix.vectorListWeight[0][currentRowIndex] *= 2
                    QKVMatrix.matrixWeight[currentRowIndex][colIndex] *= 2
                    rowIndex += 1
                }
            }
        }

        func startThirdTimer() {
            let repeatTime = tokens.count - 1
            var repeatCount = 0
            colIndex = 0

            Timer.scheduledTimer(withTimeInterval: duration / 10, repeats: true) { timer in
                // all calculation finished, reset the embedding matrix
                if repeatCount == repeatTime - 1 && colIndex == col {
                    embeddingMatrix.vectorListWeight[repeatCount + 1] =
                        embeddingMatrix.vectorListWeight[repeatCount + 1].map {
                            $0 / 2
                        }
                    timer.invalidate()
                } else {
                    // start of a new calculation, light the embedding vector
                    if colIndex == 0 {
                        embeddingMatrix.vectorListWeight[repeatCount + 1] =
                            embeddingMatrix.vectorListWeight[repeatCount + 1].map {
                                $0 * 2
                            }
                    }
                    // end of a vector calculation, reset qkv matrix and bias vector
                    if colIndex == col {
                        colIndex = 0
                        repeatCount += 1
                        embeddingMatrix.vectorListWeight[repeatCount] =
                            embeddingMatrix.vectorListWeight[repeatCount].map {
                                $0 / 2
                            }
                        embeddingMatrix.vectorListWeight[repeatCount + 1] =
                            embeddingMatrix.vectorListWeight[repeatCount + 1].map {
                                $0 * 2
                            }
                        QKVMatrix.matrixWeight = QKVMatrix.matrixWeight.map {
                            $0.map { $0 / 2 }
                        }
                        biasVector.weight = biasVector.weight.map {
                            $0 / 2
                        }
                    }
                    let currentColIndex = colIndex
                    biasVector.weight[currentColIndex] *= 2
                    if colIndex < 10 {
                        qMatrixView.vectorListWeight[repeatCount + 1][currentColIndex] =
                            qMatrix[repeatCount + 1][currentColIndex]
                    } else if colIndex < 20 {
                        kMatrixView.vectorListWeight[repeatCount + 1][currentColIndex - 10] =
                            kMatrix[repeatCount + 1][currentColIndex - 10]
                    } else {
                        vMatrixView.vectorListWeight[repeatCount + 1][currentColIndex - 20] =
                            vMatrix[repeatCount + 1][currentColIndex - 20]
                    }
                    for rowIndex in 0..<row {
                        QKVMatrix.matrixWeight[rowIndex][currentColIndex] *= 2
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

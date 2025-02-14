//
//  MathPage.swift
//  Transformer Heart
//
//  Created by nldxtd on 2025/2/10.
//

import SwiftUI

struct MathPageView: View {
    @State private var selectedPage: Page? = Page.allCases.first

    var body: some View {
        NavigationView {
            List(Page.allCases, selection: $selectedPage) { page in
                Text(page.title)
                    .tag(page)
            }
            .listStyle(SidebarListStyle())
            .frame(minWidth: 200)
            .navigationTitle("Select Chapters")

            if let selectedPage = selectedPage {
                switch selectedPage {
                case .vecMat:
                    VectorMatrixView()
                case .innProSim:
                    InnerProductSimilarityView()
                case .matMul:
                    MatrixMultiplicationView()
                case .ffnAct:
                    FeedforwardNetworkActivationView()
                case .sofCls:
                    SoftmaxClassificationView()
                case .drpNorm:
                    DropoutNormalizationView()
                }
            } else {
                Text("Select a page")
            }
        }
    }
}

enum Page: String, CaseIterable, Identifiable {
    case vecMat, innProSim, matMul, ffnAct, sofCls, drpNorm

    var id: String { rawValue }

    var title: String {
        switch self {
        case .vecMat: return "I. Vector & Matrix"
        case .innProSim: return "II. Inner Product & Similarity"
        case .matMul: return "III. Matrix Multiplication"
        case .ffnAct: return "IV. Feedforward Network & Activation"
        case .sofCls: return "V. Softmax & Classification"
        case .drpNorm: return "VI. Dropout & Normalization"
        }
    }
}

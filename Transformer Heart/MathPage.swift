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
            
            // if let page = selectedPage {
            //     PageDetailView(page: page)
            // } else {
            //     Text("Select a page").frame(maxWidth: .infinity, maxHeight: .infinity)
            // }
            VectorMatrixIntroduction()
        }
    }
}

enum Page: String, CaseIterable, Identifiable {
    case vecMat, innProSim, matMul, ffnAct, sofCls, drpNorm
    
    var id: String { rawValue }
    
    var title: String {
        switch self {
        case .vecMat: return "Vector & Matrix"
        case .innProSim: return "Inner Product & Similarity"
        case .matMul: return "Matrix Multiplication"
        case .ffnAct: return "Feedforward Network & Activation"
        case .sofCls: return "Softmax & Classification"
        case .drpNorm: return "Dropout & Normalization"
        }
    }
}


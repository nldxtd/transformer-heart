//
//  OverviewView.swift
//  Transformer Heart
//
//  Created by nldxtd on 2025/2/10.
//


import SwiftUI

struct OverviewView: View {

    @Binding var currentView: String
    var animationNamespace: Namespace.ID
    
    var body: some View {
        Text("Overview")
        .onTapGesture {
            currentView = "Embedding Pipeline"
        }
    }
}

//
//  FFNExplanation.swift
//  Transformer Heart
//
//  Created by nldxtd on 2025/2/19.
//

import SwiftUI

struct MLPExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Title
            Text("Feed-Forward Network (FFN)")
                .font(.title3)
                .foregroundColor(.indigo)
                .padding(.bottom, 4)
            
            // Main explanation
            Text("After the multiple heads of self-attention capture the diverse relationships between the input tokens, the concatenated outputs are passed through the Multilayer Perceptron (FFN) layer to enhance the model's representational capacity. This network applies the same transformation to each position separately and in parallel.")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            VStack(alignment: .leading, spacing: 16) {
                // Architecture
                Text("Architecture")
                    .font(.headline)
                    .foregroundColor(.indigo)
                
                Text("1. First Layer: Expands the input dimension from 768 to 3072 (4x) using a linear transformation followed by a GELU activation function.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text("2. Second Layer: Projects back to the model's dimension (768) using another linear transformation, ensuring consistent dimensions for subsequent layers.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                // Processing
                Text("Processing")
                    .font(.headline)
                    .foregroundColor(.indigo)
                    .padding(.top, 8)
                
                Text("Unlike the self-attention mechanism, the FFN processes tokens independently and simply maps them from one representation to another. This independent processing complements the inter-token relationships captured by the attention mechanism.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(Color.gray.opacity(0.05))
            .cornerRadius(8)
        }
    }
}
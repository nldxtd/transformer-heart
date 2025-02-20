//
//  AttentionKQVExplanation.swift
//  Transformer Heart
//
//  Created by nldxtd on 2025/2/19.
//

import SwiftUI

struct KQVMatricesExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Introduction
            Text("Query, Key, Value Matrices")
                .font(.title3)
                .foregroundColor(.indigo)
                .padding(.bottom, 4)
            
            // Main explanation
            Text("Each token's embedding vector is transformed into three vectors: Query, Key, and Value. These vectors are derived by multiplying the input embedding matrix with learned weight matrices for Q, K, and V. Here's a web search analogy to help us build some intuition behind these matrices:")
                .font(.subheadline)
                .foregroundColor(.secondary)              
            
            // Web search analogy
            VStack(alignment: .leading, spacing: 16) {
                Text("Web Search Analogy")
                    .font(.headline)
                    .foregroundColor(.indigo)
                
                // Search components visualization
                VStack(alignment: .leading, spacing: 20) {
                    
                    Text("Query is the search text you type in the search engine bar. This is the token you want to \"find more information about\".")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    // Query component
                    SearchComponentView(
                        title: "Query (Q)",
                        color: .orange,
                        description: "Like typing in a search bar",
                        example: "\"How to make pasta\"",
                        icon: "magnifyingglass"
                    )
                    
                    Text("Key is the title of each web page in the search result window. It represents the possible tokens the query can attend to.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    // Key component
                    SearchComponentView(
                        title: "Key (K)",
                        color: .green,
                        description: "Like webpage titles in search results",
                        example: "\"Easy Pasta Recipes\"",
                        icon: "link"
                    )
                    
                    Text("Value is the actual content of web pages shown. Once we matched the appropriate search term (Query) with the relevant results (Key), we want to get the content (Value) of the most relevant pages.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    // Value component
                    SearchComponentView(
                        title: "Value (V)",
                        color: .purple,
                        description: "Like webpage content",
                        example: "\"Boil water, add salt...\"",
                        icon: "doc.text"
                    )
                }
                .padding()
                .background(Color.gray.opacity(0.05))
                .cornerRadius(12)
            }
            
            // Technical note
            HStack {
                Image(systemName: "info.circle.fill")
                    .foregroundColor(.blue)
                Text("By using these QKV values, the model can calculate attention scores, which determine how much focus each token should receive when generating predictions.")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.top, 12)
        }
    }
}

struct SearchComponentView: View {
    let title: String
    let color: Color
    let description: String
    let example: String
    let icon: String
    
    var body: some View {
        HStack(spacing: 16) {
            // Icon
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
                .frame(width: 40)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(color)
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text(example)
                    .font(.system(.caption, design: .monospaced))
                    .padding(4)
                    .background(color.opacity(0.1))
                    .cornerRadius(4)
            }
        }
    }
}
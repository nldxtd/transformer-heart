//
//  AttentionHeadExplanation.swift
//  Transformer Heart
//
//  Created by nldxtd on 2025/2/19.
//

import SwiftUI

struct MultiheadSplittingExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Introduction
            Text("Multi-Head Attention")
                .font(.title3)
                .foregroundColor(.indigo)
                .padding(.bottom, 4)
            
            // Main explanation
            Text("Query, Key, and Value vectors are split into multiple heads—in GPT-2 (small)'s case, into 12 heads. Each head processes a segment of the embeddings independently, capturing different syntactic and semantic relationships. This design facilitates parallel learning of diverse linguistic features, enhancing the model's representational power.")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            // Visualization
            VStack(spacing: 24) {
                // Splitting visualization
                VStack(spacing: 16) {
                    Text("Splitting into 12 attention heads")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    HStack(spacing: 30) {
                        // Original vectors
                        VStack(alignment: .center, spacing: 8) {
                            Text("Original QKV")
                                .font(.caption)
                                .foregroundColor(.gray)
                            
                            VStack(spacing: 4) {
                                ForEach(0..<3) { i in
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill([Color.orange, Color.green, Color.purple][i].opacity(0.3))
                                        .frame(width: 60, height: 20)
                                }
                            }
                        }
                        
                        Image(systemName: "arrow.right")
                            .foregroundColor(.gray)
                        
                        // Split heads
                        VStack(alignment: .center, spacing: 8) {
                            Text("12 Attention Heads")
                                .font(.caption)
                                .foregroundColor(.gray)
                            
                            HStack(spacing: 2) {
                                ForEach(0..<12) { _ in
                                    VStack(spacing: 2) {
                                        ForEach(0..<3) { i in
                                            RoundedRectangle(cornerRadius: 2)
                                                .fill([Color.orange, Color.green, Color.purple][i].opacity(0.3))
                                                .frame(width: 15, height: 20)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.05))
                .cornerRadius(8)
            }
            
            // Technical note
            HStack {
                Image(systemName: "info.circle.fill")
                    .foregroundColor(.blue)
                Text("Multiple attention heads allow the model to focus on different aspects of the input simultaneously, improving its ability to understand complex language patterns.")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.top, 12)
        }
    }
}

struct MaskedSelfAttentionExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Masked Self-Attention")
                .font(.title3)
                .foregroundColor(.indigo)
                .padding(.bottom, 4)
            
            Text("In each head, we perform masked self-attention calculations. This mechanism allows the model to generate sequences by focusing on relevant parts of the input while preventing access to future tokens.")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
}

struct AttentionScoreExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Title
            Text("Attention Score")
                .font(.title3)
                .foregroundColor(.indigo)
                .padding(.bottom, 4)
            
            // Main explanation
            Text("The dot product of Query and Key matrices determines the alignment of each query with each key, producing a square matrix that reflects the relationship between all input tokens.")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            // Mathematical detail
            VStack(alignment: .leading, spacing: 16) {
                Text("Mathematical Operation")
                    .font(.headline)
                    .foregroundColor(.indigo)
                
                // Formula visualization
                VStack(alignment: .leading, spacing: 8) {
                    Text("Score = Q × K^T / √d")
                        .font(.system(.body, design: .monospaced))
                        .padding(8)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(4)
                    
                    Text("where d is the dimension of the key vectors")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                // Example calculation
                VStack(alignment: .leading, spacing: 12) {
                    Text("Example:")
                        .font(.subheadline)
                        .foregroundColor(.indigo)
                    
                    HStack(spacing: 30) {
                        // Query vector
                        VStack(alignment: .center, spacing: 4) {
                            Text("Query")
                                .font(.caption)
                                .foregroundColor(.gray)
                            Text("[0.2, 0.5]")
                                .font(.system(.caption, design: .monospaced))
                                .padding(4)
                                .background(Color.orange.opacity(0.2))
                                .cornerRadius(4)
                        }
                        
                        Text("×")
                            .foregroundColor(.gray)
                        
                        // Key vector
                        VStack(alignment: .center, spacing: 4) {
                            Text("Key")
                                .font(.caption)
                                .foregroundColor(.gray)
                            Text("[0.3, 0.4]")
                                .font(.system(.caption, design: .monospaced))
                                .padding(4)
                                .background(Color.green.opacity(0.2))
                                .cornerRadius(4)
                        }
                        
                        Text("=")
                            .foregroundColor(.gray)
                        
                        // Result
                        VStack(alignment: .center, spacing: 4) {
                            Text("Score")
                                .font(.caption)
                                .foregroundColor(.gray)
                            Text("0.26")
                                .font(.system(.caption, design: .monospaced))
                                .padding(4)
                                .background(Color.blue.opacity(0.2))
                                .cornerRadius(4)
                        }
                    }
                    .padding(.vertical, 8)
                }
            }
            .padding()
            .background(Color.gray.opacity(0.05))
            .cornerRadius(8)
        }
    }
}

struct MaskingExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Masking")
                .font(.title3)
                .foregroundColor(.indigo)
                .padding(.bottom, 4)
            
            Text("A mask is applied to the upper triangle of the attention matrix to prevent the model from accessing future tokens, setting these values to negative infinity. The model needs to learn how to predict the next token without \"peeking\" into the future.")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            // Simple masking visualization
            HStack(spacing: 2) {
                ForEach(0..<6) { row in
                    VStack(spacing: 2) {
                        ForEach(0..<6) { col in
                            Rectangle()
                                .fill(col <= row ? Color.gray.opacity(0.2) : Color.blue.opacity(0.3))
                                .frame(width: 30, height: 30)
                                .overlay(
                                    Text(col <= row ? "−∞" : "")
                                        .font(.caption2)
                                        .foregroundColor(.gray)
                                )
                        }
                    }
                }
            }
            .padding()
        }
    }
}

struct SoftmaxExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Title
            Text("Softmax")
                .font(.title3)
                .foregroundColor(.indigo)
                .padding(.bottom, 4)
            
            // Main explanation
            Text("After masking, the attention score is converted into probability by the softmax operation which takes the exponent of each attention score. Each row of the matrix sums up to one and indicates the relevance of every other token to the left of it.")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            // Mathematical detail
            VStack(alignment: .leading, spacing: 16) {
                Text("Mathematical Operation")
                    .font(.headline)
                    .foregroundColor(.indigo)
                
                // Formula visualization
                VStack(alignment: .leading, spacing: 8) {
                    Text("softmax(x_i) = exp(x_i) / Σ exp(x_j)")
                        .font(.system(.body, design: .monospaced))
                        .padding(8)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(4)
                    
                    Text("where x_i is the attention score for position i")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                // Example calculation
                VStack(alignment: .leading, spacing: 12) {
                    Text("Example:")
                        .font(.subheadline)
                        .foregroundColor(.indigo)
                    
                    VStack(spacing: 16) {
                        // Original scores
                        HStack(spacing: 4) {
                            Text("Scores:")
                                .font(.caption)
                                .foregroundColor(.gray)
                            Text("[2.3, 1.5, 0.8]")
                                .font(.system(.caption, design: .monospaced))
                                .padding(4)
                                .background(Color.blue.opacity(0.2))
                                .cornerRadius(4)
                        }
                        
                        // Exponents
                        HStack(spacing: 4) {
                            Text("Exp:")
                                .font(.caption)
                                .foregroundColor(.gray)
                            Text("[9.97, 4.48, 2.23]")
                                .font(.system(.caption, design: .monospaced))
                                .padding(4)
                                .background(Color.orange.opacity(0.2))
                                .cornerRadius(4)
                        }
                        
                        // Sum
                        HStack(spacing: 4) {
                            Text("Sum:")
                                .font(.caption)
                                .foregroundColor(.gray)
                            Text("16.68")
                                .font(.system(.caption, design: .monospaced))
                                .padding(4)
                                .background(Color.purple.opacity(0.2))
                                .cornerRadius(4)
                        }
                        
                        // Final probabilities
                        HStack(spacing: 4) {
                            Text("Probabilities:")
                                .font(.caption)
                                .foregroundColor(.gray)
                            Text("[0.60, 0.27, 0.13]")
                                .font(.system(.caption, design: .monospaced))
                                .padding(4)
                                .background(Color.green.opacity(0.2))
                                .cornerRadius(4)
                        }
                    }
                    .padding(.vertical, 8)
                }
            }
            .padding()
            .background(Color.gray.opacity(0.05))
            .cornerRadius(8)
        }
    }
}

struct OutputConcatenationExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Title
            Text("Output Generation & Concatenation")
                .font(.title3)
                .foregroundColor(.indigo)
                .padding(.bottom, 4)
            
            // Main explanation
            Text("After computing attention scores and applying softmax, each head generates its output by combining value vectors weighted by attention probabilities. These outputs are then concatenated and processed through a linear transformation.")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            // Process visualization
            VStack(alignment: .leading, spacing: 24) {
                // Step 1: Single Head Output
                VStack(alignment: .leading, spacing: 12) {
                    Text("1. Single Head Output")
                        .font(.headline)
                        .foregroundColor(.indigo)
                    
                    HStack(spacing: 30) {
                        // Attention weights
                        VStack(alignment: .center, spacing: 4) {
                            Text("Attention")
                                .font(.caption)
                                .foregroundColor(.gray)
                            Text("[0.6, 0.3, 0.1]")
                                .font(.system(.caption, design: .monospaced))
                                .padding(4)
                                .background(Color.blue.opacity(0.2))
                                .cornerRadius(4)
                        }
                        
                        Text("×")
                            .foregroundColor(.gray)
                        
                        // Value vectors
                        VStack(alignment: .center, spacing: 4) {
                            Text("Values")
                                .font(.caption)
                                .foregroundColor(.gray)
                            VStack(spacing: 2) {
                                Text("[0.2, 0.5]")
                                Text("[0.3, 0.1]")
                                Text("[0.4, 0.2]")
                            }
                            .font(.system(.caption, design: .monospaced))
                            .padding(4)
                            .background(Color.purple.opacity(0.2))
                            .cornerRadius(4)
                        }
                        
                        Text("=")
                            .foregroundColor(.gray)
                        
                        // Head output
                        VStack(alignment: .center, spacing: 4) {
                            Text("Head Output")
                                .font(.caption)
                                .foregroundColor(.gray)
                            Text("[0.28, 0.31]")
                                .font(.system(.caption, design: .monospaced))
                                .padding(4)
                                .background(Color.green.opacity(0.2))
                                .cornerRadius(4)
                        }
                    }
                }
                
                // Step 2: Concatenation
                VStack(alignment: .leading, spacing: 12) {
                    Text("2. Multi-Head Concatenation")
                        .font(.headline)
                        .foregroundColor(.indigo)
                    
                    HStack(spacing: 2) {
                        ForEach(0..<12) { _ in
                            RoundedRectangle(cornerRadius: 2)
                                .fill(Color.green.opacity(0.2))
                                .frame(width: 15, height: 40)
                        }
                    }
                    .overlay(
                        Text("12 head outputs concatenated")
                            .font(.caption)
                            .foregroundColor(.gray)
                            .offset(y: -30)
                    )
                }
                
                // Step 3: Linear Projection
                VStack(alignment: .leading, spacing: 12) {
                    Text("3. Linear Projection")
                        .font(.headline)
                        .foregroundColor(.indigo)
                    
                    HStack(spacing: 30) {
                        // Concatenated output
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.green.opacity(0.2))
                            .frame(width: 120, height: 20)
                        
                        Image(systemName: "arrow.right")
                            .foregroundColor(.gray)
                        
                        // Final output
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.orange.opacity(0.2))
                            .frame(width: 60, height: 20)
                    }
                    .overlay(
                        Text("Project back to model dimension")
                            .font(.caption)
                            .foregroundColor(.gray)
                            .offset(y: -30)
                    )
                }
                
                // Step 4: Residual Connection
                VStack(alignment: .leading, spacing: 12) {
                    Text("4. Residual Connection")
                        .font(.headline)
                        .foregroundColor(.indigo)
                    
                    HStack(spacing: 20) {
                        // Original input
                        VStack(alignment: .center, spacing: 4) {
                            Text("Input")
                                .font(.caption)
                                .foregroundColor(.gray)
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color.blue.opacity(0.2))
                                .frame(width: 60, height: 20)
                        }
                        
                        Text("+")
                            .foregroundColor(.gray)
                        
                        // Attention output
                        VStack(alignment: .center, spacing: 4) {
                            Text("Attention")
                                .font(.caption)
                                .foregroundColor(.gray)
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color.orange.opacity(0.2))
                                .frame(width: 60, height: 20)
                        }
                        
                        Text("=")
                            .foregroundColor(.gray)
                        
                        // Final output
                        VStack(alignment: .center, spacing: 4) {
                            Text("Output")
                                .font(.caption)
                                .foregroundColor(.gray)
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color.purple.opacity(0.2))
                                .frame(width: 60, height: 20)
                        }
                    }
                }
            }
            .padding()
            .background(Color.gray.opacity(0.05))
            .cornerRadius(8)
        }
    }
}

struct ResidualConnectionExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Title
            Text("Residual Connection")
                .font(.title3)
                .foregroundColor(.indigo)
                .padding(.bottom, 4)
            
            // Main explanation
            Text("Residual connections, also known as skip connections, add the input directly to the output of a layer. In transformers, they are used after both attention and FFN layers.")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            VStack(alignment: .leading, spacing: 16) {
                // Benefits
                Text("Key Benefits")
                    .font(.headline)
                    .foregroundColor(.indigo)
                
                Text("1. Gradient Flow: Helps prevent vanishing gradients by providing a direct path for gradients to flow backward through the network during training.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text("2. Information Preservation: Allows the model to retain important low-level features that might otherwise be lost through deep transformations.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text("3. Easier Optimization: Makes it easier for the model to learn identity mappings when needed, improving training stability.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(Color.gray.opacity(0.05))
            .cornerRadius(8)
        }
    }
}
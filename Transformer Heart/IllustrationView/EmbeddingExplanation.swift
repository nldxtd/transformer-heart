//
//  EmbeddingExplanation.swift
//  Transformer Heart
//
//  Created by nldxtd on 2025/2/19.
//
import SwiftUI

struct EmbeddingExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Introduction
            Text("Understanding Embedding")
                .font(.title3)
                .foregroundColor(.indigo)
                .padding(.bottom, 4)
            
            Text("Let's say you want to generate text using a Transformer model. You add the prompt like this one:")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            // Example prompt
            Text("\"Transformer visualization empowers users to\"")
                .font(.system(.body, design: .monospaced))
                .padding(12)
                .frame(maxWidth: .infinity)
                .background(Color.blue.opacity(0.1))
                .cornerRadius(8)
            
            Text("This input needs to be converted into a format that the model can understand and process. That is where embedding comes in: it transforms the text into a numerical representation that the model can work with.")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            // Steps
            Text("The Embedding Process")
                .font(.headline)
                .foregroundColor(.indigo)
                .padding(.top, 8)
            
            VStack(alignment: .leading, spacing: 12) {
                StepView(number: 1, 
                        title: "Tokenization", 
                        description: "Break down the input text into tokens")
                
                StepView(number: 2, 
                        title: "Token Embeddings", 
                        description: "Convert tokens into numerical vectors")
                
                StepView(number: 3, 
                        title: "Positional Information", 
                        description: "Add position encoding to each token")
                
                StepView(number: 4, 
                        title: "Final Embedding", 
                        description: "Combine token and position encodings")
            }
            .padding(.leading, 8)
            
            // Navigation hint
            HStack {
                Image(systemName: "info.circle.fill")
                    .foregroundColor(.blue)
                Text("Click on each component in the visualization to see how these steps work in detail.")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.top, 12)
        }
    }
}

struct StepView: View {
    let number: Int
    let title: String
    let description: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            // Step number
            Text("\(number)")
                .font(.system(.caption, design: .rounded))
                .fontWeight(.bold)
                .foregroundColor(.white)
                .frame(width: 20, height: 20)
                .background(Circle().fill(Color.indigo))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(.subheadline, design: .rounded))
                    .fontWeight(.semibold)
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
}

struct TokenizationExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Introduction
            Text("Understanding Tokenization")
                .font(.title3)
                .foregroundColor(.indigo)
                .padding(.bottom, 4)
            
            // Main explanation
            Text("Tokenization is the process of breaking down the input text into smaller, more manageable pieces called tokens. These tokens can be a word or a subword.")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            // Example visualization
            VStack(spacing: 16) {
                // Original text
                Text("Original text:")
                    .font(.caption)
                    .foregroundColor(.gray)
                Text("\"Transformer visualization empowers users to\"")
                    .font(.system(.body, design: .monospaced))
                    .padding(12)
                    .frame(maxWidth: .infinity)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(8)
                
                // Arrow
                Image(systemName: "arrow.down")
                    .foregroundColor(.gray)
                
                // Tokenized result
                Text("Tokenized into:")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                HStack(spacing: 12) {
                    TokenBox(text: "Transformer", id: "#1842")
                    TokenBox(text: "visualization", id: "#4728")
                    TokenBox(text: "em", id: "#2341")
                    TokenBox(text: "powers", id: "#8392")
                    TokenBox(text: "users", id: "#2849")
                    TokenBox(text: "to", id: "#374")
                }
            }
            .padding(.vertical, 8)
            
            // Additional information
            Text("The words \"Transformer\" and \"visualization\" correspond to unique tokens, while the word \"empowers\" is split into two tokens. The full vocabulary of tokens is decided before training the model: GPT-2's vocabulary has 50,257 unique tokens.")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            // Next step hint
            HStack {
                Image(systemName: "arrow.right.circle.fill")
                    .foregroundColor(.green)
                Text("Now that we split our input text into tokens with distinct IDs, we can obtain their vector representation from embeddings.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding(.top, 8)
            
            // Technical note
            HStack {
                Image(systemName: "info.circle.fill")
                    .foregroundColor(.blue)
                Text("GPT-2 uses Byte-Pair Encoding (BPE) for tokenization, which finds common subword patterns in the training data.")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.top, 12)
        }
    }
}

struct TokenBox: View {
    let text: String
    let id: String
    
    var body: some View {
        VStack(spacing: 4) {
            Text(text)
                .font(.system(.subheadline, design: .monospaced))
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color.indigo.opacity(0.1))
                .cornerRadius(4)
            
            Text(id)
                .font(.system(size: 10, design: .monospaced))
                .foregroundColor(.gray)
        }
    }
}

struct TokenEmbeddingExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Introduction
            Text("Token Embedding")
                .font(.title3)
                .foregroundColor(.indigo)
                .padding(.bottom, 4)

            // Main explanation
            Text("GPT-2 (small) represents each token in the vocabulary as a 768-dimensional vector; the dimension of the vector depends on the model. These embedding vectors are stored in a matrix of shape (50,257, 768), containing approximately 39 million parameters!")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Text("This extensive matrix allows the model to assign semantic meaning to each token.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .padding(.top, 4)
            
            // Matrix visualization
            HStack(alignment: .center, spacing: 16) {
                // Matrix shape visualization
                HStack(alignment: .center, spacing: 0) {
                    Text("50,257")
                        .font(.system(.caption, design: .monospaced))
                        .rotationEffect(.degrees(-90))
                        .padding(.trailing, 8)
                    
                    VStack(spacing: 4) {
                        Text("768")
                            .font(.system(.caption, design: .monospaced))
                        
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.indigo.opacity(0.1))
                            .frame(width: 200, height: 160)
                            .overlay(
                                VStack(spacing: 8) {
                                    Text("Embedding Matrix")
                                        .font(.subheadline)
                                        .foregroundColor(.indigo)
                                    Text("~39M parameters")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                            )
                    }
                }
                
                // Example token embedding
                VStack(spacing: 8) {
                    Text("Example token embedding:")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    VStack(spacing: 16) {
                        TokenBox(text: "visualization", id: "#4728")
                        
                        Image(systemName: "arrow.down")
                            .foregroundColor(.gray)
                        
                        // Vector representation
                        VStack(alignment: .leading, spacing: 4) {
                            HStack(spacing: 2) {
                                ForEach(0..<12) { _ in
                                    RoundedRectangle(cornerRadius: 2)
                                        .fill(Color.green.opacity(0.3))
                                        .frame(width: 8, height: 20)
                                }
                                Text("...")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            Text("768-d vector")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
            .padding(.vertical, 12)
            
        }
    }
}

struct PositionalEncodingExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Introduction
            Text("Position Encoding")
                .font(.title3)
                .foregroundColor(.indigo)
                .padding(.bottom, 4)
            
            // Main explanation
            Text("The Embedding layer also encodes information about each token's position in the input prompt. Different models use various methods for positional encoding. GPT-2 trains its own positional encoding matrix from scratch, integrating it directly into the training process.")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            // Position visualization
            VStack(spacing: 16) {
                Text("Position encoding example:")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                // Token sequence with positions
                VStack(spacing: 12) {
                    ForEach(0..<6) { index in
                        HStack(spacing: 16) {
                            // Position number
                            Text("pos \(index)")
                                .font(.system(.caption, design: .monospaced))
                                .foregroundColor(.gray)
                                .frame(width: 50, alignment: .trailing)
                            
                            // Token
                            TokenBox(
                                text: ["Data", "visualization", "em", "powers", "users", "to"][index],
                                id: ["#1842", "#4728", "#2341", "#8392", "#2849", "#374"][index]
                            )
                            
                            // Position encoding vector
                            HStack(spacing: 2) {
                                ForEach(0..<8) { _ in
                                    RoundedRectangle(cornerRadius: 2)
                                        .fill(Color.orange.opacity(0.3))
                                        .frame(width: 8, height: 20)
                                }
                                Text("...")
                                    .font(.caption)
                                    .foregroundColor(.gray)
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
                Text("Position encodings help the model understand word order and maintain sequence information during processing.")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.top, 12)
        }
    }
}

struct FinalEmbeddingExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Introduction
            Text("Final Embedding")
                .font(.title3)
                .foregroundColor(.indigo)
                .padding(.bottom, 4)
            
            // Main explanation
            Text("Finally, we sum the token and positional encodings to get the final embedding representation. This combined representation captures both the semantic meaning of the tokens and their position in the input sequence.")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            // Visualization
            VStack(spacing: 24) {
                // Example for one token
                VStack(spacing: 16) {
                    Text("Adding embeddings for 'visualization'")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    HStack(spacing: 20) {
                        // Token embedding
                        VStack(alignment: .center, spacing: 4) {
                            Text("Token embedding")
                                .font(.caption)
                                .foregroundColor(.gray)
                            
                            HStack(spacing: 2) {
                                ForEach(0..<8) { _ in
                                    RoundedRectangle(cornerRadius: 2)
                                        .fill(Color.orange.opacity(0.3))
                                        .frame(width: 8, height: 20)
                                }
                                Text("...")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
                        
                        Text("+")
                            .font(.title3)
                            .foregroundColor(.gray)
                        
                        // Position embedding
                        VStack(alignment: .center, spacing: 4) {
                            Text("Position encoding")
                                .font(.caption)
                                .foregroundColor(.gray)
                            
                            HStack(spacing: 2) {
                                ForEach(0..<8) { _ in
                                    RoundedRectangle(cornerRadius: 2)
                                        .fill(Color.green.opacity(0.3))
                                        .frame(width: 8, height: 20)
                                }
                                Text("...")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
                        
                        Text("=")
                            .font(.title3)
                            .foregroundColor(.gray)
                        
                        // Final embedding
                        VStack(alignment: .center, spacing: 4) {
                            Text("Final embedding")
                                .font(.caption)
                                .foregroundColor(.gray)
                            
                            HStack(spacing: 2) {
                                ForEach(0..<8) { _ in
                                    RoundedRectangle(cornerRadius: 2)
                                        .fill(Color.blue.opacity(0.3))
                                        .frame(width: 8, height: 20)
                                }
                                Text("...")
                                    .font(.caption)
                                    .foregroundColor(.gray)
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
                Text("The final embedding combines semantic meaning (from token embeddings) with sequential information (from position encodings) into a single vector.")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.top, 12)
        }
    }
}
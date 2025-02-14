//
//  LaunchPage.swift
//  Transformer Heart
//
//  Created by nldxtd on 2025/2/12.
//

import SwiftUI

struct LaunchPage: View {
    @State private var showMathPage = false
    @State private var animateBackground = false
    
    var body: some View {
        ZStack {
            // Animated Background
            BackgroundView()
            
            // Main Content
            VStack(spacing: 40) {
                // Title Section
                VStack(spacing: 15) {
                    Text("Transformer")
                        .font(.system(size: 48, weight: .bold, design: .rounded))
                        .foregroundColor(.blue)
                    
                    Text("Heart")
                        .font(.system(size: 48, weight: .bold, design: .rounded))
                        .foregroundColor(.red)
                        .overlay(
                            Image(systemName: "heart.fill")
                                .foregroundColor(.red)
                                .offset(x: 5, y: -5)
                        )
                }
                
                // Description
                Text("Understanding what's happening inside of Large Language Models(LLMs)")
                    .font(.title2)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.gray)
                    .padding(.horizontal, 40)
                
                // Main Buttons
                VStack(spacing: 20) {
                    NavigationLink {
                        GPTIllustrationView()
                    } label: {
                        HStack {
                            Text("To begin with: GPT-2")
                            Image(systemName: "arrow.right.circle.fill")
                        }
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(width: 300, height: 50)
                        .background(Color.blue)
                        .cornerRadius(10)
                    }
                    
                    NavigationLink {
                        DeepseekView()
                    } label: {
                        HStack {
                            Text("Most recent: DeepSeek")
                            Image(systemName: "arrow.right.circle.fill")
                        }
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(width: 300, height: 50)
                        .background(Color.green)
                        .cornerRadius(10)
                    }
                }
                
                // Math Basic Button
                Button(action: {
                    withAnimation(.spring()) {
                        showMathPage = true
                    }
                }) {
                    HStack {
                        Image(systemName: "function")
                        Text("If needed: Learn the math basics")
                        Image(systemName: "arrow.right.circle")
                    }
                    .font(.subheadline)
                    .foregroundColor(.blue)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.blue, lineWidth: 1)
                    )
                }
            }
            .padding()
            
            // Math Page Sheet
            if showMathPage {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation(.spring()) {
                            showMathPage = false
                        }
                    }
                
                MathPageView()
                    .frame(width: UIScreen.main.bounds.width * 0.8,
                           height: UIScreen.main.bounds.height * 0.8)
                    .background(Color.white)
                    .cornerRadius(20)
                    .shadow(radius: 20)
                    .transition(.scale)
            }
        }
    }
}

// Background Animation View
struct BackgroundView: View {
    @State private var animate = false
    
    var body: some View {
        ZStack {
            // Base gradient
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.blue.opacity(0.1),
                    Color.purple.opacity(0.1)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            // Floating circles
            GeometryReader { geometry in
                ForEach(0..<20) { index in
                    Circle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    index % 2 == 0 ? Color.blue.opacity(0.2) : Color.purple.opacity(0.2),
                                    index % 2 == 0 ? Color.purple.opacity(0.2) : Color.blue.opacity(0.2)
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: CGFloat.random(in: 20...50))
                        .offset(
                            x: CGFloat.random(in: 0...geometry.size.width),
                            y: CGFloat.random(in: 0...geometry.size.height)
                        )
                        .animation(
                            Animation
                                .easeInOut(duration: Double.random(in: 4...6))
                                .repeatForever()
                                .delay(Double.random(in: 0...2)),
                            value: animate
                        )
                }
            }
            
            // Grid overlay
            GridPattern()
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
        }
        .onAppear {
            animate.toggle()
        }
        .ignoresSafeArea()
    }
}

// Grid Pattern
struct GridPattern: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let stepSize: CGFloat = 40
        
        // Vertical lines
        stride(from: 0, to: rect.width, by: stepSize).forEach { x in
            path.move(to: CGPoint(x: x, y: 0))
            path.addLine(to: CGPoint(x: x, y: rect.height))
        }
        
        // Horizontal lines
        stride(from: 0, to: rect.height, by: stepSize).forEach { y in
            path.move(to: CGPoint(x: 0, y: y))
            path.addLine(to: CGPoint(x: rect.width, y: y))
        }
        
        return path
    }
}

struct DeepseekView: View {
    var body: some View {
        Text("Deepseek View")
    }
}


import SwiftUI

struct InnerProductPlayground: View {
    @State private var xValue = 1.3
    @State private var yValue = 0.7

    var innerProduct: Double {
        xValue + yValue
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 30) {

                // Main content
                VStack(alignment: .leading, spacing: 20) {
                    Text("Interactive Visualization")
                        .font(.title2)
                        .fontWeight(.semibold)

                    Text("Explore how inner product changes as you adjust the vector components. The reference vector [1.0, 1.0] is shown in blue, and your adjustable vector is shown in green when the inner product is positive, red when negative.")
                        .font(.body)
                        .lineSpacing(8)

                    HStack {
                        // Coordinate system
                        CoordinateSystemView(xValue: xValue, yValue: yValue)
                            .padding(20)
                            .background(
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(Color.white)
                                    .shadow(
                                        color: Color.black.opacity(0.1),
                                        radius: 10,
                                        x: 0,
                                        y: 5
                                    )
                            )

                        // Controls
                        ControlsView(xValue: $xValue, yValue: $yValue, innerProduct: innerProduct)
                            .padding(20)
                            .background(
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(Color.white)
                                    .shadow(
                                        color: Color.black.opacity(0.1),
                                        radius: 10,
                                        x: 0,
                                        y: 5
                                    )
                            )
                    }
                    .padding()
                }
                .padding()
            }
            .background(Color.white)
        }
        .background(Color.gray.opacity(0.1))
    }
}

struct CoordinateSystemView: View {
    let xValue: Double
    let yValue: Double

    var body: some View {
        VStack {
            GeometryReader { geometry in
                let width = geometry.size.width
                let height = geometry.size.height
                let centerX = width / 2
                let pointX = centerX + CGFloat(xValue) * (width / 4)
                let pointY = height - CGFloat(yValue) * (height / 2)

                ZStack {
                    // Draw Axes
                    Path { path in
                        path.move(to: CGPoint(x: 0, y: height))
                        path.addLine(to: CGPoint(x: width, y: height))
                        path.move(to: CGPoint(x: centerX, y: 0))
                        path.addLine(to: CGPoint(x: centerX, y: height))
                    }
                    .stroke(Color.black, lineWidth: 2)

                    // Axis Labels
                    Text("x").position(x: width - 15, y: height - 15)
                    Text("y").position(x: centerX - 15, y: 5)
                    Text("O").position(x: centerX - 10, y: height + 10)

                    // Points
                    Circle().fill(getInnerProductColor(xValue, yValue)).frame(width: 10, height: 10)
                        .position(x: pointX, y: pointY)
                    Circle().fill(Color.blue).frame(width: 10, height: 10)
                        .position(x: width * 3 / 4, y: height / 2)

                    // Point Labels
                    Text("[\(xValue, specifier: "%.1f"), \(yValue, specifier: "%.1f")]")
                        .font(.caption)
                        .position(x: pointX + 30, y: pointY - 10)
                    Text("[1.0, 1.0]")
                        .font(.caption)
                        .position(x: width * 3 / 4 + 10, y: height / 2 + 10)

                    // Vectors
                    drawArrow(
                        from: CGPoint(x: centerX, y: height),
                        to: CGPoint(x: width * 3 / 4, y: height / 2), color: .blue)
                    drawArrow(
                        from: CGPoint(x: centerX, y: height), to: CGPoint(x: pointX, y: pointY),
                        color: getInnerProductColor(xValue, yValue))
                }
            }
            .frame(width: 300, height: 150)
            .padding()
        }
        .background(Color.gray.opacity(0.1))
        .cornerRadius(15)
        .padding()
    }

    func drawArrow(from start: CGPoint, to end: CGPoint, color: Color) -> some View {
        Path { path in
            path.move(to: start)
            path.addLine(to: end)
        }
        .stroke(color, lineWidth: 2)
    }

    func getInnerProductColor(_ x: Double, _ y: Double) -> Color {
        let product = x + y
        return product >= 0 ? .green : .red
    }
}

struct ControlsView: View {
    @Binding var xValue: Double
    @Binding var yValue: Double
    let innerProduct: Double

    var body: some View {
        VStack(spacing: 15) {
            SliderView(title: "x coordinate:", value: $xValue, range: -2...2)
            SliderView(title: "y coordinate:", value: $yValue, range: 0...2)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Inner Product:")
                    .font(.headline)
                Text("1 * \(xValue, specifier: "%.1f") + 1 * \(yValue, specifier: "%.1f") = \(innerProduct, specifier: "%.1f")")
                    .foregroundColor(innerProduct >= 0 ? .green : .red)
                    .font(.system(.body, design: .monospaced))
            }
            .padding(.top, 8)
        }
    }
}

struct SliderView: View {
    let title: String
    @Binding var value: Double
    let range: ClosedRange<Double>

    var body: some View {
        HStack {
            Text(title).frame(width: 100, alignment: .leading)
            Text("\(value, specifier: "%.1f")").frame(width: 50)
            Slider(value: $value, in: range, step: 0.1)
        }
    }
}

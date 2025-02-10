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

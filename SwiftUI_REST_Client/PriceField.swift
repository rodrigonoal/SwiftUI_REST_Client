import SwiftUI
import Combine

struct PriceField: View {
    var title: String
    @Binding var value : Double
    @State private var enteredValue = ""
    
    var body: some View {
        TextField(title, text: $enteredValue)
            .onReceive(Just(enteredValue)) { typedValue in
                if let newValue = Double(typedValue){
                    self.value = newValue
                }
            }
            .onAppear() {
                self.enteredValue = String(format: "%.02f", self.value)
            }
            .keyboardType(.decimalPad)
    }
}

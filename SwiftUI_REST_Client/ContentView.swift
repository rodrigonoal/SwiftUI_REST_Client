import SwiftUI

struct ContentView: View {
    // observed: make redraw the view which is observed once the data changes
    @ObservedObject private var productListViewModel = ProductListViewModel()
    
    var body: some View {
        List {
            ForEach(self.productListViewModel.products, id: \.id) { product in
                // TODO 1 - add navigation link
                HStack {
                Text(product.name)
                Spacer()
                Text(product.code)
                Spacer()
                Text(String(format: "$ %.2f", product.price))
                }
            }
            //TODO 3 - add the delete action function
        }
        //TODO 2 - navigation view configuration
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

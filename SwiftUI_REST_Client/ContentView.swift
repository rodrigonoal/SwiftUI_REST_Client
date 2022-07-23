import SwiftUI

struct ContentView: View {
    // observed: make redraw the view which is observed once the data changes
    @ObservedObject private var productListViewModel = ProductListViewModel()
    @State private var showModal = false
    
    private func reloadProducts() {
        productListViewModel.fetchProducts()
    }
    
    private func showNewProductView() {
        self.showModal = true
    }

    private func newProductCompletion(product: Product) {
    self.productListViewModel.products
    .append(ProductModel(product: product))
    }
    var body: some View {
        List {
            ForEach(self.productListViewModel.products, id: \.id) { product in
                NavigationLink(destination: Text("Product" + product.name)){
                    HStack {
                        Text(product.name)
                        Spacer()
                        Text(product.code)
                        Spacer()
                        Text(String(format: "$ %.2f", product.price))
                    }
                }
            }
            //TODO 3 - add the delete action function
        }
        .navigationBarTitle("Products", displayMode: .inline)
        .navigationBarItems(leading: Button(action: reloadProducts) {
            Image(systemName: "arrow.clockwise")
                .foregroundColor(Color.blue)
        }, trailing: Button(action: showNewProductView) {
            Image(systemName: "plus")
                .foregroundColor(Color.blue)
        })
        .sheet(isPresented: $showModal) {
        AddNewProductView(isPresented: self.$showModal,
        completion: newProductCompletion)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

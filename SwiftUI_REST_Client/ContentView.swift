import SwiftUI

struct ContentView: View {
    // observed: make redraw the view which is observed once the data changes
    @ObservedObject private var productListViewModel = ProductListViewModel()
    @State private var showModal = false
    @State private var showAlert = false
    
    private func deleteProduct(indexSet: IndexSet) {
    showAlert = false
    let productToBeDeleted = self.productListViewModel
    .products[indexSet.first!]
    productListViewModel
    .deleteProduct(product: productToBeDeleted) { product in
    if let _ = product {
    self.productListViewModel.products.remove(at: indexSet.first!)
    } else {
    showAlert = true
    }
    }
    }
    
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
            .onDelete(perform: self.deleteProduct)
        }
        .navigationBarTitle("Products", displayMode: .inline)
        .navigationBarItems(leading: Button(action: reloadProducts) {
            Image(systemName: "arrow.clockwise")
                .foregroundColor(Color.blue)
        }, trailing: Button(action: showNewProductView) {
            Image(systemName: "plus")
                .foregroundColor(Color.blue)
        })
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Error"),
                  message: Text("The product couldn't be deleted"), dismissButton: .default(Text("Dismiss")))
        }        .sheet(isPresented: $showModal) {
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

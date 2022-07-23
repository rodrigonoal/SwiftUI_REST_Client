import SwiftUI

struct EditProductView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var product: Product
    var completion: (Product) -> Void
    @State private var showAlert = false
    @State private var editProductViewModel = EditProductViewModel()
    
    init(product: Product, completion: @escaping (Product) -> Void) {
        self.product = product
        self.completion = completion
        self.editProductViewModel.setProduct(product: product)
    }
    
    var body: some View {
        Form {
            Section() {
                TextField("Enter the name",
                          text:self.$editProductViewModel.name)
                TextField("Enter the description",
                          text:self.$editProductViewModel.description)
                TextField("Enter the code",
                          text:self.$editProductViewModel.code)
                PriceField(title: "Enter the price:",
                           value: $editProductViewModel.price)
            }
            .navigationBarTitle("Edit product", displayMode: .inline)
            .navigationBarItems(trailing: Button(action: updateProduct) {
                Text("Save").foregroundColor(.blue)
            })
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Error"),
                      message: Text("The product couldn't be updated"),
                      dismissButton: .default(Text("Dismiss")))
            }
        }
    }
    
    private func updateProduct() {
        showAlert = false
        editProductViewModel.updateProduct { product in
            if let product = product {
                completion(product)
                self.presentationMode.wrappedValue.dismiss()
            } else {
                showAlert = true
            }
        }
    }
}
struct EditProductView_Previews: PreviewProvider {
    static var previews: some View {
        EditProductView(product: Product(id: 0, name: "product",
                                         description: "desc", code: "cod", price: 0.0)) { product in
        }
    }
}

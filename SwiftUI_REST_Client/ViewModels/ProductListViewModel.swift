import Foundation

class ProductListViewModel: ObservableObject {
    @Published var products = [ProductModel]() // published makes the view aware of the changes in the list
    
    init() {
        fetchProducts()
    }
    
    func fetchProducts() {
        SalesProviderClient.sharedInstance.getProducts { products in
            if let products = products {
                self.products = products.map(ProductModel.init)
            }
        }
    }
    
    func deleteProduct(product: ProductModel,
                       completion: @escaping (Product?) -> Void) {
        SalesProviderClient.sharedInstance
            .deleteProduct(productCode: product.code) { product in
                completion(product)
            }
    }
}

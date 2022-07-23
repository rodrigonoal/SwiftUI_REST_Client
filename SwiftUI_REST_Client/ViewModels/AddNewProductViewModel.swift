import Foundation

class AddNewProductViewModel  {
    var name = ""
    var description = ""
    var code = ""
    var price = 0.0
    
    func saveNewProduct(completion: @escaping (Product?) -> Void) {
        let product = Product(id: 0, name: self.name, description: self.description, code: self.code, price: self.price)
        
        SalesProviderClient.sharedInstance.createProduct(product: product) { product in
            completion(product)
        }
    }
    
}

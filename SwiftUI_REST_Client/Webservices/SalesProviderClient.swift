import Foundation
import Alamofire

// singleton:
// 1- an static attribute that represents the single instance
// 2- a private init method
class SalesProviderClient {
    static let sharedInstance = SalesProviderClient()
    private let baseUrl = "https://sales-provider.appspot.com/"
    
    private var accessTokenStorage: AccessTokenStorage?
    private let session: Session
    
    private init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 10
        configuration.timeoutIntervalForResource = 10
        
        let userCredential = UserCredential(username: "rodrigo@noal.com", password: "noal")
        
        session = Session(configuration: configuration,
                          interceptor: AuthenticationInterceptor(
                            accessTokenStorage: accessTokenStorage,
                            userCredential: userCredential,
                            baseUrl: baseUrl))
    }
}

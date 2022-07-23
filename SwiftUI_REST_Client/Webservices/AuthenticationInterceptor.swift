import Foundation
import Alamofire

final class AuthenticationInterceptor: Alamofire.RequestInterceptor {
    private var accessTokenStorage: AccessTokenStorage?
    private let userCredential: UserCredential
    private let baseUrl: String
    
    init (accessTokenStorage: AccessTokenStorage?, userCredential: UserCredential, baseUrl: String) {
        self.accessTokenStorage = accessTokenStorage
        self.userCredential = userCredential
        self.baseUrl = baseUrl
    }
    
    private func isValidTOken() -> Bool{
        if let accessToken = self.accessTokenStorage {
            return accessToken.isValidToken()
        } else {
            return false
        }
    }
}

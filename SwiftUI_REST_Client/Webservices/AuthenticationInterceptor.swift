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
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var urlRequest = urlRequest
        
        if isValidToken() {
            urlRequest.setValue("Bearer " + accessTokenStorage!.accessToken, forHTTPHeaderField: "Authorization")
        }
        completion(.success(urlRequest))
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        // guard is an inverted if
        // this is a fail fast code - stop it quickly
        guard let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401 else {
            return completion(.doNotRetryWithError(error))
        }
                getAccessToken(completion: completion)
    }
    
    // @escaping async context
    private func getAccessToken(completion: @escaping (RetryResult) -> Void) {
        let tokenEndpoint = baseUrl + "oauth/token"
        
        let param: Parameters = [
            "grant_type": "password",
            "username": userCredential.username,
            "password": userCredential.password
        ]
        let tokenHeaders: HTTPHeaders = [
            "Content-Type": "application/x-www-form-urlencoded",
            "Authorization": "Basic c2llY29sYTptYXRpbGRl"
        ]
        
        print("Requesting access token...")
        AF.request(tokenEndpoint, method: .post, parameters: param, encoding: URLEncoding.httpBody, headers: tokenHeaders)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseDecodable(of: AccessTokenResponse.self) { response in
                switch response.result {
                case.success:
                    if let accessTokenResponse = response.value {
                        print("The token is: " + accessTokenResponse.access_token)
                        
                        self.accessTokenStorage = AccessTokenStorage(access_token: accessTokenResponse.access_token, expires_in: accessTokenResponse.expires_in)
                        
                        return completion(.retry)
                    }
                case let .failure(error):
                    print(error)
                }
            }
        print("Access token has been requested...")
    }
    
    private func isValidToken() -> Bool{
        if let accessToken = self.accessTokenStorage {
            return accessToken.isValidToken()
        } else {
            return false
        }
    }
}

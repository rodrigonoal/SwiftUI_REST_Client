import Foundation

class AccessTokenStorage {
    var accessToken: String
    var expiresDate: NSDate // absolut date
    
    init(access_token: String, expires_in: Int) {
        self.accessToken = access_token
        self.expiresDate = NSDate().addingTimeInterval(TimeInterval(expires_in))
    }
    
    func isValidToken() -> Bool {
        if NSDate().timeIntervalSinceReferenceDate < self.expiresDate.timeIntervalSinceReferenceDate {
            return true
        } else {
            return false
        }
    }
}

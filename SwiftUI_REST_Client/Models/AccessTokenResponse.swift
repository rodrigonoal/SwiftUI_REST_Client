import Foundation

struct AccessTokenResponse: Decodable {
    let access_token: String
    let refresh_token: String
    let expires_in: Int // seconds until expiration
}

import Foundation
//прочитать docs.swift.org
let AuthorizeURLString = "https://unsplash.com/oauth/authorize"
let AccessKey = "U3B2xQUOb46Pc0YhN8OZ3fEPkIoX1RDSltEXyNxVKN0"
let SecretKey = "yd-SDHSgQcloFvxn2VGyRccYPFJKsAT9vISmr5iv4cM"
let RedirectURI = "urn:ietf:wg:oauth:2.0:oob"
let AccessScope = "public+read_user+write_likes"
let BaseApiURL = "https://api.unsplash.com"

struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let defaultBaseURL: String
    let authURLString: String
    
    static var standart: AuthConfiguration {
        return AuthConfiguration(
            accessKey: AccessKey,
            secretKey: SecretKey,
            redirectURI: RedirectURI,
            accessScope: AccessScope,
            authURLString: AuthorizeURLString,
            defaultBaseURL: BaseApiURL
        )
    }
        
    init(
        accessKey: String,
        secretKey: String,
        redirectURI: String,
        accessScope: String,
        authURLString: String,
        defaultBaseURL: String
    ) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.redirectURI = redirectURI
        self.accessScope = accessScope
        self.defaultBaseURL = defaultBaseURL
        self.authURLString = authURLString
    }
}

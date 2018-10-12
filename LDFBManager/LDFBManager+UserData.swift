//
//  LDFBManager+UserData.swift
//  iOSTemplate
//
//  Created by Lazar on 10/25/17.
//  Copyright © 2017 Lazar. All rights reserved.
//

import Foundation
import FacebookCore
import FacebookLogin
import FacebookShare


// MARK: - Users data extension for LDFBManager
extension LDFBManager
{
    // MARK: - Get User Data
    
    /// Function to get Fb UserData for logged User via GraphRequest request.
    ///
    /// - Parameters:
    ///   - requestFields: FBUserDataField array, desired fields about User.
    ///   - success: Success Handler Function.
    ///   - failed: Failed Handler Function.
    open func getFBUserData(requestFields: [FBUserDataField] = [.UserID, .Name, .FirstName, .LastName, .Email, .Gender, .Hometown, .ProfilePicture], success:@escaping (LDFBUser?) -> Void, failed:@escaping (Error) -> Void)
    {
        let params = ["fields" : self.makeFBUserDataFieldsString(requestFields)]
        let graphRequest = GraphRequest(graphPath: "me", parameters: params)
        graphRequest.start {
            (urlResponse, requestResult) in
            
            switch requestResult {
            case .failed(let error):
                failed(error)
            case .success(let graphResponse):
                if let userDict = graphResponse.dictionaryValue
                {
                    let userPicture:String = {
                        if let picture = userDict["picture"] as? [String: Any]
                        {
                            if let data = picture["data"] as? [String: Any]
                            {
                                if let pictureUrl = data["url"] as? String
                                {
                                    return pictureUrl
                                }
                            }
                        }
                        return ""
                    }()
                    let userId:String = userDict["id"] as? String ?? ""
                    let userName:String = userDict["name"] as? String ?? ""
                    let userEmail:String = userDict["email"] as? String ?? ""
                    let userHomeTown:String = {
                        if let homeTownDict = userDict["hometown"] as? [String:Any]
                        {
                            if let homeTown = homeTownDict["name"] as? String
                            {
                                return "Hometown: \(homeTown)"
                            }
                        }
                        return "Hometown:"
                    }()
                    success(LDFBUser(id: userId, name: userName, firstName: "", lastName: "", hasPicture: false, picture: userPicture, homeTown: userHomeTown, email: userEmail))
                }
                success(nil)
            }
        }
    }
}

//
//  LDFBManager+Friends.swift
//  iOSTemplate
//
//  Created by Lazar on 10/25/17.
//  Copyright © 2017 Lazar. All rights reserved.
//

import Foundation
import FacebookCore
import FacebookLogin
import FacebookShare


// MARK: - Friends extension for LDFBManager
extension LDFBManager
{
    /// Get all user friends
    ///
    /// - Parameters:
    ///   - success: Success completion block if fetching friend list was successful
    ///   - failed: Error completion block if fetching friend list was unsuccessful
    open func getAllFriends(success:@escaping ([LDFBUser]) -> Void, failed:@escaping (Error) -> Void)
    {
        let url = "/me/taggable_friends"
        var params = ["fields": "id, first_name, last_name, name, email, picture.width(200).height(200)"]
        params["limit"] = "5000"
        let graphRequest:GraphRequest = GraphRequest(graphPath: url, parameters: params)
        graphRequest.start { (urlResponse, requestResult) in
            switch requestResult {
            case .failed(let error):
                failed(error)
            case .success(let graphResponse):
                self.handleGraphResponseForFriendsList(graphResponse: graphResponse, success: { friendsList, _ in
                    success(friendsList)
                })
            }
        }
    }
    
    /// Get user friends with pagination
    ///
    /// - Parameters:
    ///   - success: Success completion block if fetching friend list was successful
    ///   - failed: Error completion block if fetching friend list was unsuccessful
    ///   - afterCursor: After cursor for fetching friend list from a specific position
    open func getFriends(success:@escaping ([LDFBUser], _ nextCursor:String?) -> Void, failed:@escaping (Error) -> Void, afterCursor:String? = nil)
    {
        let url = "/me/taggable_friends"
        var params = ["fields": "id, first_name, last_name, name, email, picture.width(200).height(200)"]
        if let afterCursor = afterCursor
        {
            params["after"] = afterCursor
        }
        let graphRequest:GraphRequest = GraphRequest(graphPath: url, parameters: params)
        graphRequest.start { (urlResponse, requestResult) in
            switch requestResult {
            case .failed(let error):
                failed(error)
            case .success(let graphResponse):
                self.handleGraphResponseForFriendsList(graphResponse: graphResponse, success: success)
            }
        }
    }
    
    /// Handle response for geting friends list
    ///
    /// - Parameters:
    ///   - graphResponse: GraphResponse instance
    ///   - success: Success completion block if fetching friend list was successful
    open func handleGraphResponseForFriendsList(graphResponse:GraphResponse, success:@escaping ([LDFBUser], _ nextCursor:String?) -> Void)
    {
        var friendsList = [LDFBUser]()
        if let friendsDict = graphResponse.dictionaryValue as [String : Any]?
        {
            if let friendsListArray = friendsDict["data"] as? [[String:Any]]
            {
                for singleFacebookUserDict in friendsListArray
                {
                    let userId = singleFacebookUserDict["id"] as? String ?? ""
                    let userName = singleFacebookUserDict["name"] as? String ?? ""
                    let userFirstName = singleFacebookUserDict["first_name"] as? String ?? ""
                    let userLastName = singleFacebookUserDict["last_name"] as? String ?? ""
                    let hasPicture:Bool = {
                        if let userPictureDict = singleFacebookUserDict["picture"] as? [String:Any]
                        {
                            if let userPictureData = userPictureDict["data"] as? [String:Any]
                            {
                                if let isSilhouette = userPictureData["is_silhouette"] as? Bool
                                {
                                    return !isSilhouette
                                }
                            }
                        }
                        return false
                    }()
                    let userPicture:String = {
                        if let userPictureDict = singleFacebookUserDict["picture"] as? [String:Any]
                        {
                            if let userPictureData = userPictureDict["data"] as? [String:Any]
                            {
                                if let userPictureUrl = userPictureData["url"] as? String
                                {
                                    return userPictureUrl
                                }
                            }
                        }
                        return ""
                    }()
                    
                    friendsList.append(LDFBUser(id: userId, name: userName, firstName: userFirstName, lastName: userLastName, hasPicture: hasPicture, picture: userPicture, homeTown: "", email: ""))
                }
            }
            let afterCursor = self.parseAfterCursor(dict: friendsDict)
            success(friendsList, afterCursor)
        }
    }
}

//
//  LDFBManager+BasicMethods.swift
//  iOSTemplate
//
//  Created by Lazar on 10/25/17.
//  Copyright © 2017 Lazar. All rights reserved.
//

import Foundation
import FacebookCore
import FacebookLogin
import FacebookShare


// MARK: - Basic methods extension for LDFBManager
extension LDFBManager
{
    
    // MARK: - Redirection
    
    open func didFinishLaunching(_ app: UIApplication, options: [UIApplicationLaunchOptionsKey : Any]? = [:]) -> Bool
    {
        return SDKApplicationDelegate.shared.application(app, didFinishLaunchingWithOptions: options)
    }
    
    /// Function to handle the log in redirect back to your app needed in AppDelegate
    ///
    /// - Parameters:
    ///   - app: The application as passed to UIApplicationDelegate.
    ///   - url: The URL as passed to UIApplicationDelegate.
    ///   - options: The options as passed to UIApplicationDelegate.
    /// - Returns: true if the url was intended for the Facebook SDK, otherwise - false.
    open func redirect(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool
    {
        return SDKApplicationDelegate.shared.application(app, open: url, options: options)
    }
    
    // MARK: - Login/Logout
    
    /// FB Login Function with specified read permissions, success, failed and cancelled closure.
    ///
    /// - Parameters:
    ///   - permissions: FBReadPermission array, App read permissions
    ///   - success: Success Login function. Default success function is not set.
    ///   - failed: Failed Login function. Default failed function is not set.
    ///   - cancelled: Cancelled Login function. Default cancelled function is not set.
    open func login(with permissions: [FBReadPermission], success:(() -> Swift.Void)? = nil, failed:(() -> Swift.Void)? = nil, cancelled:(() -> Swift.Void)? = nil)
    {
        let loginManager = LoginManager()
        loginManager.logIn(readPermissions: makeReadPermissionArray(permissions), viewController: nil) { loginResult in
            switch loginResult {
            case .failed(let error):
                print("FB: LOGIN ERROR -> \(error)")
                if failed != nil
                {
                    failed!()
                }
            case .cancelled:
                print("FB: CANCELLED LOGIN")
                if cancelled != nil
                {
                    cancelled!()
                }
            case .success( _, _, _):
                print("FB: LOGGED IN")
                if success != nil
                {
                    success!()
                }
            }
        }
    }
    
    
    /// Determines if userd is logged in application
    ///
    /// - Returns: true if user is logged in. Otherwise, it will return false
    open func isLoggedIn() -> Bool
    {
        return AccessToken.current != nil
    }
    
    /// FB Logout Function
    open func logout()
    {
        let loginManager = LoginManager()
        loginManager.logOut()
        
        print("FB: LOGGED OUT")
    }
    
    
    /// Get FB Autentication Token
    ///
    /// - Returns: FB Autentication Token
    open func getAuthenticationToken() -> String?
    {
        return AccessToken.current?.authenticationToken
    }
    
    // MARK: - Share
    
    /// Function to share link content on Facebook.
    ///
    /// - Parameters:
    ///   - vc: Presenting ViewController, which controller will pop up a dialog.
    ///   - urlString: Content URL String
    ///   - title: title
    ///   - success: Success Handler Function. Default Success Function is not set.
    ///   - failed: Failed Handler Function. Default Failed Function is not set.
    ///   - cancelled: Cancelled Handler Function. Default Cancelled Function is not set.
    open func shareLinkContent(inVC vc: UIViewController, contentURL urlString: String, shareTitle title: String, success:(() -> Swift.Void)? = nil, failed:(() -> Swift.Void)? = nil, cancelled:(() -> Swift.Void)? = nil)
    {
        do {
            var content = LinkShareContent(url: URL(string: urlString)!)
            content.quote = title
            
            let dialog = ShareDialog(content: content)
            dialog.presentingViewController = vc
            dialog.mode = .automatic
            
            // Biblioteka ima problem, prilikom iskljucivanja share dijaloga na bilo koji nacin ne vraca CANCELLED,
            // vec  uvek vraca SUCCESS, pritom i ne zatara uvek dijalog za share
            dialog.completion = { result in
                switch result {
                case .success:
                    print("FB: SHARE SUCCESS")
                    if success != nil
                    {
                        success!()
                    }
                case .failed:
                    print("FB: SHARE ERROR")
                    if failed != nil
                    {
                        failed!()
                    }
                case .cancelled:
                    print("FB: SHARE CANCELLED")
                    if cancelled != nil
                    {
                        cancelled!()
                    }
                }
            }
            
            try
                dialog.show()
        }
        catch {
            print("FB SHARE ERROR: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Helper Functions
    
    /// Parse After Cusror from getFBEvents Function Response Dictionary
    ///
    /// - Parameter dict: Response Dictionary
    /// - Returns: After Cursor for next Events page
    func parseAfterCursor(dict: [String : Any]?) -> String?
    {
        var after:String?
        if let dict = dict
        {
            if let paging = dict["paging"] as? [String: Any]
            {
                if let cursors = paging["cursors"] as? [String: Any]
                {
                    if let afterCursor = cursors["after"] as? String
                    {
                        after = afterCursor
                    }
                }
            }
        }
        return after
    }
    
    /// Convert FBReadPermission enumeration values array to ReadPermission array.
    ///
    /// - Parameter permissions: FBReadPermission enumeration values array.
    /// - Returns: Converted ReadPermission array.
    func makeReadPermissionArray(_ permissions: [FBReadPermission]) -> [ReadPermission]
    {
        if permissions == []
        {
            return []
        }
        var readPermissions: [ReadPermission] = []
        for permission in permissions
        {
            switch permission {
            case .PublicProfile:
                readPermissions.append(ReadPermission.publicProfile)
            case .Email:
                readPermissions.append(ReadPermission.email)
            case .UserFriends:
                readPermissions.append(ReadPermission.userFriends)
            case .UserPhotos:
                readPermissions.append(ReadPermission.userPhotos)
            case .UserHometown:
                readPermissions.append(ReadPermission.userHometown)
            }
        }
        
        return readPermissions
    }
    
    
    /// Convert FBUserDataField enumeration values array to String.
    ///
    /// - Parameter fields: FBUserDataField enumeration values array.
    /// - Returns: Converted Result String.
    func makeFBUserDataFieldsString(_ fields: [FBUserDataField]) -> String
    {
        if fields == []
        {
            return ""
        }
        var fieldsString = ""
        for (index, field) in fields.enumerated()
        {
            switch field
            {
            case .UserID:
                fieldsString.append("id")
            case .Name:
                fieldsString.append("name")
            case .FirstName:
                fieldsString.append("first_name")
            case .LastName:
                fieldsString.append("last_name")
            case .About:
                fieldsString.append("about")
            case .Birthday:
                fieldsString.append("birthday")
            case .ProfilePicture:
                fieldsString.append("picture.width(200).height(200)")
            case .Email:
                fieldsString.append("email")
            case .Gender:
                fieldsString.append("gender")
            case .Hometown:
                fieldsString.append("hometown")
            case .RelationshipStatus:
                fieldsString.append("relationship_status")
            case .Timezone:
                fieldsString.append("timezone")
            case .UserFriends:
                fieldsString.append("user_friends")
            }
            
            if index != fields.count - 1
            {
                fieldsString.append(", ")
            }
        }
        
        return fieldsString
    }
}

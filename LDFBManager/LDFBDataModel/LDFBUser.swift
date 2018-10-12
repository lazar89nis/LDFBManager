//
//  LDFBUser.swift
//  iOSTemplate
//
//  Created by Lazar on 10/25/17.
//  Copyright © 2017 Lazar. All rights reserved.
//

import UIKit


/// LDFBUser class used for representing Facebook user
open class LDFBUser
{
    /// Facebook user id
    open var id:String
    
    /// Facebook user name
    open var name:String
    
    /// Facebook user first name
    open var firstName:String
    
    /// Facebook user last name
    open var lastName:String
    
    /// Defines if user has profile picture
    open var hasPicture:Bool
    
    /// Facebook user profile picture
    open var picture:String
    
    /// Facebook user hometown
    open var homeTown:String
    
    /// Facebook user email
    open var email:String
    
    /// Constructor / initializer
    ///
    /// - Parameters:
    ///   - id: acebook user id
    ///   - name: Facebook user name
    ///   - firstName: Facebook user first name
    ///   - lastName: Facebook user last name
    ///   - hasPicture: Boolean value which indicates if user has profile picture, or his picture is a silhouette
    ///   - picture: Facebook user profile picture
    public init(id:String, name:String, firstName:String, lastName:String, hasPicture:Bool, picture:String, homeTown:String, email:String)
    {
        self.id = id
        self.name = name
        self.firstName = firstName
        self.lastName = lastName
        self.hasPicture = hasPicture
        self.picture = picture
        self.homeTown = homeTown
        self.email = email
    }
}

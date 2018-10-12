//
//  HCEnums.swift
//  iOSTemplate
//
//  Created by Lazar on 10/25/17.
//  Copyright © 2017 Lazar. All rights reserved.
//

import Foundation

/// Facebook read permissions for FB login
///
/// - PublicProfile: Read permissions for user profile
/// - Email: Read permissions for user email
/// - UserHometown: Read permissions for user hometown
/// - UserFriends: Read permissions for user friends
/// - UserPhotos: Read permissions for user photos
public enum FBReadPermission
{
    /// Read permissions for user profile
    case PublicProfile
    
    /// Read permissions for user email
    case Email
    
    /// Read permissions for user hometown
    case UserHometown
    
    /// Read permissions for user friends
    case UserFriends
    
    /// Read permissions for user photos
    case UserPhotos
}

/// Facebook fields to get User Data from User FB profile
///
/// - UserID: User id
/// - Name: User name
/// - FirstName: User first name
/// - LastName: User last name
/// - About: About user
/// - Birthday: User birthday
/// - ProfilePicture: User profile picture
/// - Email: User email
/// - Gender: User gender
/// - Hometown: User hometown
/// - RelationshipStatus: User relationship status
/// - Timezone: User timezone
/// - UserFriends: User friends
public enum FBUserDataField
{
    // Comment after each item is key for graphRequest Result Dict
    
    /// User id
    case UserID //id
    
    /// User name
    case Name //name
    
    /// User first name
    case FirstName //first_name
    
    /// User last name
    case LastName //last_name
    
    /// About user
    case About //about
    
    /// User birthday
    case Birthday //birthday
    
    /// User profile picture
    case ProfilePicture // picture
    
    /// User email
    case Email //email
    
    /// User gender
    case Gender //gender
    
    /// User hometown
    case Hometown //hometown
    
    /// User relationship status
    case RelationshipStatus //relationship_status
    
    /// User timezone
    case Timezone //timezone
    
    /// User friends
    case UserFriends //user_friends
}

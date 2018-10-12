//
//  LDFBAlbum.swift
//  iOSTemplate
//
//  Created by Lazar on 10/25/17.
//  Copyright © 2017 Lazar. All rights reserved.
//

import UIKit


/// LDFBAlbum class used for representing Facebook album
open class LDFBAlbum
{
    /// Album id
    open var albumId:String
    
    /// Album name
    open var albumName:String
    
    /// Number of images in album
    open var albumCount:Int
    
    /// Album cover photo id
    open var albumCoverPhotoId:String
    
    /// Initializer / constructor
    ///
    /// - Parameters:
    ///   - albumId: Album id
    ///   - albumName: Album name
    ///   - albumCount: Number of images in album
    ///   - albumCoverPhotoId: Album cover photo id
    public init(albumId:String, albumName:String, albumCount:Int, albumCoverPhotoId:String)
    {
        self.albumId = albumId
        self.albumName = albumName
        self.albumCount = albumCount
        self.albumCoverPhotoId = albumCoverPhotoId
    }
}

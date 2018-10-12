//
//  LDFBImage.swift
//  iOSTemplate
//
//  Created by Lazar on 10/25/17.
//  Copyright © 2017 Lazar. All rights reserved.
//

import UIKit


/// LDFBImage class used for representing Facebook image
open class LDFBImage
{
    /// Image id
    open var imageId:String
    
    /// Image url
    open var imageUrl:String
    
    /// Initializer / constructor
    ///
    /// - Parameters:
    ///   - imageId: Image id
    ///   - imageUrl: Image url
    public init(imageId:String, imageUrl:String)
    {
        self.imageId = imageId
        self.imageUrl = imageUrl
    }
}

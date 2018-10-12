//
//  LDFBEvent.swift
//  iOSTemplate
//
//  Created by Lazar on 10/25/17.
//  Copyright © 2017 Lazar. All rights reserved.
//

import UIKit
import CoreLocation

/// /// LDFBEvent class used for representing Facebook event
open class LDFBEvent
{
    /// Event id
    open var eventId:String
    
    /// Event name
    open var eventName:String
    
    /// Start time
    open var startTime:Date
    
    /// End time
    open var endTime:Date
    
    /// Is canceled
    open var isCanceled:Bool
    
    /// Event description
    open var eventDescription:String
    
    /// Place name
    open var placeName:String
    
    /// Event location
    open var eventLocation:CLLocationCoordinate2D
    
    /// Street
    open var street:String
    
    /// Contry
    open var country:String
    
    /// City
    open var city:String
    
    /// Event picture
    open var eventPicture:String
    
    /// Event picture id
    open var eventPictureId:String
    
    /// Initielizer / constructor
    ///
    /// - Parameters:
    ///   - eventId: Event id
    ///   - eventName: Event name
    ///   - startTime: Start time
    ///   - endTime: End time
    ///   - isCanceled: Is canceled
    ///   - eventDescription: Event description
    ///   - placeName: Place name
    ///   - eventLocation: Event location
    ///   - street: Street
    ///   - country: Contry
    ///   - city: City
    ///   - eventPicture: Event picture
    ///   - eventPictureId: Event picture id
    public init(eventId:String, eventName:String, startTime:Date, endTime:Date, isCanceled:Bool, eventDescription:String, placeName:String, eventLocation:CLLocationCoordinate2D, street:String, country:String, city:String, eventPicture:String, eventPictureId:String)
    {
        self.eventId = eventId
        self.eventName = eventName
        self.startTime = startTime
        self.endTime = endTime
        self.isCanceled = isCanceled
        self.eventDescription = eventDescription
        self.placeName = placeName
        self.eventLocation = eventLocation
        self.street = street
        self.country = country
        self.city = city
        self.eventPicture = eventPicture
        self.eventPictureId = eventPictureId
    }
}

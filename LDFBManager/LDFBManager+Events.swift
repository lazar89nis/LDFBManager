//
//  LDFBManager+Events.swift
//  iOSTemplate
//
//  Created by Lazar on 10/25/17.
//  Copyright © 2017 Lazar. All rights reserved.
//

import Foundation
import FacebookCore
import FacebookLogin
import FacebookShare
import CoreLocation

// MARK: - Events extension for LDFBManager
extension LDFBManager
{
    
    /// Get all Facebook Events for specified Facebook Page
    ///
    /// - Parameters:
    ///   - accessToken: Access Token, default value is empty String in this case function user current Access Token of Logged User. In case you don't have users in App, you can set generated Access Token for the corresponding FB page.
    ///   - facebookPageID: ID of page to which events belong
    ///   - success: Success function.
    ///   - failed: Failed function.
    open func getAllEvents(accessToken: String = "", facebookPageID: String, success:@escaping ([LDFBEvent]) -> Void, failed:@escaping (Error) -> Void)
    {
        var accToken = accessToken
        if accessToken == ""
        {
            if let accT = AccessToken.current
            {
                accToken = "\(accT)"
            }
        }
        
        let params = [
            "access_token" : accToken,
            "limit": "10000",
            "fields": "cover, id, description, start_time, end_time, name, place, is_canceled"
        ]
        
        let graphRequest = GraphRequest(graphPath: "/\(facebookPageID)/events", parameters: params)
        graphRequest.start {
            (urlResponse, requestResult) in
            
            switch requestResult {
            case .failed(let error):
                failed(error)
                print(error)
            case .success(let graphResponse):
                self.handleGraphResponseForEventsList(graphResponse: graphResponse, success: { events, _ in
                    success(events)
                })
            }
        }
    }
    
    /// Get Facebook Events for specified Facebook Page
    ///
    /// - Parameters:
    ///   - accessToken: Access Token, default value is empty String in this case function user current Access Token of Logged User. In case you don't have users in App, you can set generated Access Token for the corresponding FB page.
    ///   - pageLimit: Items per page, default value is 5
    ///   - afterCursor: cursor for pagination to get next page, by default afterCursor is not set and if you need next page use getNextFBEventsPage Function.
    ///   - facebookPageID: ID of page to which events belong
    ///   - success: Success function.
    ///   - failed: Failed function.
    open func getEvents(accessToken: String = "", pageLimit: Int = 5, afterCursor: String = "", facebookPageID: String, success:@escaping ([LDFBEvent], _ nextCursor:String?) -> Void, failed:@escaping (Error) -> Void)
    {
        var accToken = accessToken
        if accessToken == ""
        {
            if let accT = AccessToken.current
            {
                accToken = "\(accT)"
            }
        }
        
        let params = [
                "access_token" : accToken,
                "limit": "\(pageLimit)",
                "after": afterCursor,
                "fields": "cover, id, description, start_time, end_time, name, place, is_canceled"
        ]
        
        let graphRequest = GraphRequest(graphPath: "/\(facebookPageID)/events", parameters: params)
        graphRequest.start {
            (urlResponse, requestResult) in
            
            switch requestResult {
            case .failed(let error):
                failed(error)
                print(error)
            case .success(let graphResponse):
                self.handleGraphResponseForEventsList(graphResponse: graphResponse, success: success)
            }
        }
    }
    
    /// Handle response for geting events
    ///
    /// - Parameters:
    ///   - graphResponse: GraphResponse instance
    ///   - success: Success completion block if fetching events was successful
    open func handleGraphResponseForEventsList(graphResponse:GraphResponse, success:@escaping ([LDFBEvent], _ nextCursor:String?) -> Void)
    {
        var events = [LDFBEvent]()
        if let eventsDict = graphResponse.dictionaryValue
        {
            if let eventsDicts = eventsDict["data"] as? [[String: Any]]
            {
                for eventDict in eventsDicts
                {
                    let eventId = eventDict["id"] as? String ?? ""
                    let eventName = eventDict["name"] as? String ?? ""
                    let startTime:Date = {
                        if let startTimeString = eventDict["start_time"] as? String
                        {
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss+SSSS"
                            let returnDate = dateFormatter.date(from: startTimeString)
                            
                            if let startTime = returnDate
                            {
                                return startTime
                            }
                        }
                        return Date()
                    }()
                    let endTime:Date = {
                        if let endTimeString = eventDict["end_time"] as? String
                        {
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss+SSSS"
                            let returnDate = dateFormatter.date(from: endTimeString)
                            
                            if let endTime = returnDate
                            {
                                return endTime
                            }
                        }
                        return Date()
                    }()
                    let isCanceled = eventDict["name"] as? Bool ?? false
                    let eventDescription = eventDict["description"] as? String ?? ""
                    let placeName:String = {
                        if let place = eventDict["place"] as? [String:Any]
                        {
                            if let placeName = place["name"] as? String
                            {
                                return placeName
                            }
                        }
                        return ""
                    }()
                    let eventLocation:CLLocationCoordinate2D = {
                        if let place = eventDict["place"] as? [String:Any]
                        {
                            if let placeLocation = place["location"] as? [String:Any]
                            {
                                if let lat = placeLocation["latitude"] as? Double, let lng = placeLocation["longitude"] as? Double
                                {
                                    return CLLocationCoordinate2D(latitude: lat, longitude: lng)
                                }
                            }
                        }
                        return CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
                    }()
                    let street:String = {
                        if let place = eventDict["place"] as? [String:Any]
                        {
                            if let placeLocation = place["location"] as? [String:Any]
                            {
                                if let street = placeLocation["street"] as? String
                                {
                                    return street
                                }
                            }
                            
                        }
                        return ""
                    }()
                    let country:String = {
                        if let place = eventDict["place"] as? [String:Any]
                        {
                            if let placeLocation = place["location"] as? [String:Any]
                            {
                                if let country = placeLocation["country"] as? String
                                {
                                    return country
                                }
                            }
                            
                        }
                        return ""
                    }()
                    let city:String = {
                        if let place = eventDict["place"] as? [String:Any]
                        {
                            if let placeLocation = place["location"] as? [String:Any]
                            {
                                if let city = placeLocation["city"] as? String
                                {
                                    return city
                                }
                            }
                        }
                        return ""
                    }()
                    let eventPicture:String = {
                        if let cover = eventDict["cover"] as? [String:Any]
                        {
                            if let pictureUrl = cover["source"] as? String
                            {
                                return pictureUrl
                            }
                        }
                        return ""
                    }()
                    let eventPictureId:String = {
                        if let cover = eventDict["cover"] as? [String:Any]
                        {
                            if let coverId = cover["id"] as? String
                            {
                                return coverId
                            }
                        }
                        return ""
                    }()
                    events.append(LDFBEvent(eventId: eventId, eventName: eventName, startTime: startTime, endTime: endTime, isCanceled: isCanceled, eventDescription: eventDescription, placeName: placeName, eventLocation: eventLocation, street: street, country: country, city: city, eventPicture: eventPicture, eventPictureId: eventPictureId))
                }
            }
            let afterCursor = self.parseAfterCursor(dict: eventsDict)
            success(events, afterCursor)
        }
    }
    
    
    /// Get Next Facebook Events Page for secified Facebook Page
    ///
    /// - Parameters:
    ///   - accessToken: Access Token, default value is empty String in this case function user current Access Token of Logged User. In case you don't have users in App, you can set generated Access Token for the corresponding FB page.
    ///   - pageLimit: Items per page, default value is 5
    ///   - facebookPageID: ID of page to which events belong
    ///   - success: Success function.
    ///   - failed: Failed function.
    open func getNextEventsPage(accessToken: String = "", pageLimit: Int = 5, facebookPageID: String, nextCursor:String, success:@escaping ([LDFBEvent], _ nextCursor:String?) -> Void, failed:@escaping (Error) -> Void)
    {
        self.getEvents(accessToken: accessToken, pageLimit: pageLimit, afterCursor: nextCursor, facebookPageID: facebookPageID, success: success, failed: failed)
    }
}

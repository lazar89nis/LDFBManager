//
//  LDFBManager+Images.swift
//  iOSTemplate
//
//  Created by Lazar on 10/25/17.
//  Copyright © 2017 Lazar. All rights reserved.
//

import UIKit
import FacebookCore
import FacebookLogin
import FacebookShare


// MARK: - Albums and images extension for LDFBManager
extension LDFBManager
{
    // MARK: - Get albums
    
    /// Get all albums
    ///
    /// - Parameters:
    ///   - success: Success completion block if fetching albums was successful
    ///   - failed:  Error completion block if fetching albums was unsuccessful
    open func getAllAlbums(success:@escaping (_ albums:[LDFBAlbum]) -> Void, failed:@escaping (Error) -> Void)
    {
        let url = "/me/albums"
        let params = ["fields": "id, name, count, cover_photo", "limit":"10000"]
        let graphRequest:GraphRequest = GraphRequest(graphPath: url, parameters: params)
        graphRequest.start { (urlResponse, requestResult) in
            switch requestResult {
            case .failed(let error):
                failed(error)
            case .success(let graphResponse):
                self.handleGraphResponseForAlbumsList(graphResponse: graphResponse, success: { albums, afterCursor in
                    success(albums)
                })
            }
        }
    }
    
    /// Get albums with pagination
    ///
    /// - Parameters:
    ///   - success: Success completion block if fetching albums was successful
    ///   - failed: Error completion block if fetching albums was unsuccessful
    ///   - afterCursor: After cursor for fetching albums from a specific position
	open func getAlbums(success:@escaping (_ albums:[LDFBAlbum],_ nextCursor:String?) -> Void, failed:@escaping (Error) -> Void, afterCursor:String? = nil)
    {
        let url = "/me/albums"
        var params = ["fields": "id, name, count, cover_photo"]
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
                self.handleGraphResponseForAlbumsList(graphResponse: graphResponse, success: success)
            }
        }
    }
    
	
    /// Handle response for geting albums
    ///
    /// - Parameters:
    ///   - graphResponse: GraphResponse instance
    ///   - success: Success completion block if fetching albums was successful
    open func handleGraphResponseForAlbumsList(graphResponse:GraphResponse, success:@escaping ([LDFBAlbum],_ nextCursor:String?) -> Void)
    {
        var albums = [LDFBAlbum]()
        if let albumsDict = graphResponse.dictionaryValue
        {
            if let albumsArray = albumsDict["data"] as? [[String:Any]]
            {
                for singleAlbumDict in albumsArray
                {
                    let albumId = singleAlbumDict["id"] as? String ?? ""
                    let albumName = singleAlbumDict["name"] as? String ?? ""
                    let albumCount = singleAlbumDict["count"] as? Int ?? 0
                    let albumCoverPhotoId:String = {
                        if let coverPhotoDict = singleAlbumDict["cover_photo"] as? [String:Any]
                        {
                            if let coverPhotoId = coverPhotoDict["id"] as? String
                            {
                                return coverPhotoId
                            }
                        }
                        return ""
                    }()
                    albums.append(LDFBAlbum(albumId: albumId, albumName: albumName, albumCount:albumCount, albumCoverPhotoId: albumCoverPhotoId))
                }
            }
            let afterCursor = self.parseAfterCursor(dict: albumsDict)
            success(albums, afterCursor)
        }
    }
    
    // MARK: - Get album images
    
    /// Get all album images
    ///
    /// - Parameters:
    ///   - albumId: Album id
    ///   - success: Success completion block if fetching album pictures was successful
    ///   - failed: Error completion block if fetching album pictures was unsuccessful
    open func getAllAlbumImages(albumId:String, success:@escaping (_ pictures:[LDFBImage]) -> Void, failed:@escaping (Error) -> Void)
    {
        let url = "/\(albumId)/photos"
        let params = ["fields": "id, name, count, images, pictures", "limit":"10000"]
        let graphRequest:GraphRequest = GraphRequest(graphPath: url, parameters: params)
        graphRequest.start { (urlResponse, requestResult) in
            switch requestResult {
            case .failed(let error):
                failed(error)
            case .success(let graphResponse):
                self.handleGraphResponseForPicturesList(graphResponse: graphResponse, success: { pictures, afterCursor in
                    success(pictures)
                })
            }
        }
    }
    
    /// Get album images with pagination
    ///
    /// - Parameters:
    ///   - albumId: Album id
    ///   - success: Success completion block if fetching album pictures was successful
    ///   - failed: Error completion block if fetching album pictures was unsuccessful
    open func getAlbumImages(albumId:String, success:@escaping (_ pictures:[LDFBImage], _ nextCursor:String?) -> Void, failed:@escaping (Error) -> Void)
    {
        let url = "/\(albumId)/photos"
        let params = ["fields": "id, name, count, images, pictures"]
        let graphRequest:GraphRequest = GraphRequest(graphPath: url, parameters: params)
        graphRequest.start { (urlResponse, requestResult) in
            switch requestResult {
            case .failed(let error):
                failed(error)
            case .success(let graphResponse):
                self.handleGraphResponseForPicturesList(graphResponse: graphResponse, success: success)
            }
        }
    }
    
    /// Handle response for geting album images
    ///
    /// - Parameters:
    ///   - graphResponse: GraphResponse instance
    ///   - success: Success completion block if fetching album images was successful
    open func handleGraphResponseForPicturesList(graphResponse:GraphResponse, success:@escaping ([LDFBImage], _ nextCursor:String?) -> Void)
    {
        var pictures = [LDFBImage]()
        if let picturesDict = graphResponse.dictionaryValue
        {
            if let picturesArray = picturesDict["data"] as? [[String:Any]]
            {
                for singlePictureDict in picturesArray
                {
                    let pictureId = singlePictureDict["id"] as? String ?? ""
                    let pictureUrl:String = {
                        if let imagesArray = singlePictureDict["images"] as? [[String:Any]]
                        {
                            var maxWidth = 0
                            var pictureLink:String = ""
                            for singleImageDict in imagesArray
                            {
                                if let imageWidth = singleImageDict["width"] as? Int
                                {
                                    if imageWidth > maxWidth
                                    {
                                        pictureLink = singleImageDict["source"] as? String ?? ""
                                        maxWidth = imageWidth
                                    }
                                }
                            }
                            return pictureLink
                        }
                        return ""
                    }()
                    pictures.append(LDFBImage(imageId: pictureId, imageUrl: pictureUrl))
                }
            }
            let afterCursor = self.parseAfterCursor(dict: picturesDict)
            success(pictures, afterCursor)
        }
    }
    
    // MARK: - Get single picture info (url)
    
    /// Get picture
    ///
    /// - Parameters:
    ///   - pictureId: Picture id
    ///   - maxImageWidth: Maximal image width
    ///   - success: Success completion block if getting picture info (url) was successful
    ///   - failed: Error completion block if fetching picture info (url) was unsuccessful
    open func getPicture(pictureId:String, maxImageWidth:Int = Int.max, success:@escaping (_ pictureURL:String) -> Void, failed:@escaping (Error) -> Void)
    {
        let url = pictureId
        let params = ["fields":"images, name, album, place"]
        let graphRequest:GraphRequest = GraphRequest(graphPath: url, parameters: params)
        graphRequest.start { (urlResponse, requestResult) in
            switch requestResult {
            case .failed(let error):
                failed(error)
            case .success(let graphResponse):
                if let pictureDict = graphResponse.dictionaryValue
                {
                    if let imagesArray = pictureDict["images"] as? [[String:Any]]
                    {
                        var maxWidth = 0
                        var pictureUrl:String = ""
                        for singleImageDict in imagesArray
                        {
                            if let imageWidth = singleImageDict["width"] as? Int
                            {
                                if imageWidth > maxWidth && imageWidth < maxImageWidth
                                {
                                    pictureUrl = singleImageDict["source"] as? String ?? ""
                                    maxWidth = imageWidth
                                }
                            }
                        }
                        success(pictureUrl)
                    }
                    return
                }
                success("")
            }
        }
    }
}

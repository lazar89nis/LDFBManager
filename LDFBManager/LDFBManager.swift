//
//  LDFBManager.swift
//
//  Created by Lazar on 9/28/17.
//  Copyright © 2017 Lazar. All rights reserved.
//

import UIKit


/// LDFBManager class used to facilitate using Facebook SDK
open class LDFBManager {

    /// HCFacebookManager shared instance
    open static let sharedManager: LDFBManager = {
        
        let instance = LDFBManager()
        
        return instance
    }()
}

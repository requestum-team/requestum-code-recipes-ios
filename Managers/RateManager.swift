//
//  RateManager.swift
//  Requestum
//
//  Created by Alex Kovalov on 5/1/18.
//  Copyright © 2018 Requestum. All rights reserved.
//

import Foundation
import UIKit

import iRate

/**
 Configure for auto tracking:
 
 func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
 
 RateManager.configureRate()
 }
 
 Call directly with button:
 
 RateManager.rateAppInAppStore()
 */
class RateManager: NSObject, iRateDelegate {
    
    static let shared = RateManager()
    
    // MARK: Properties
    
    // MARK: Lifecycle
    
    // MARK: Actions
    
    class func configureRate() {
        
        iRate.sharedInstance().daysUntilPrompt = 10
        iRate.sharedInstance().usesUntilPrompt = 10
        iRate.sharedInstance().remindPeriod = 10
        iRate.sharedInstance().promptForNewVersionIfUserRated = true
        iRate.sharedInstance().useSKStoreReviewControllerIfAvailable = true
        iRate.sharedInstance().delegate = RateManager.shared
        
        //        iRate.sharedInstance().previewMode = true // for testing
    }
    
    class func rateAppInAppStore() {
        
        iRate.sharedInstance().openRatingsPageInAppStore()
    }
    
    
    // MARK: iRateDelegate
    
    func iRateDidPromptForRating() {
        
        // do something if needed
    }
    
    func iRateUserDidAttemptToRateApp() {
        
        // do something if needed
    }
    
    func iRateUserDidDeclineToRateApp() {
        
        // do something if needed
    }
    
    func iRateUserDidRequestReminderToRateApp() {
        
        // do something if needed
    }
    
}

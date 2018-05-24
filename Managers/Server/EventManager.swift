//
//  EventManager.swift
//  Requestum
//
//  Created by Alex Kovalov on 3/27/18.
//  Copyright © 2018 Requestum. All rights reserved.
//

import Foundation

import Alamofire


// MARK: - API

class EventManager: ObjectManager {
    
    static var shared = EventManager()
    
    func getEvents(completion: @escaping (_ error: NSError?, _ events: [Event]) -> Void) {
        
        request(.get, serverAPI: .events, parameters: nil).responseJSON { response in
            
            let events: [Event] = response.resultArray(by: "results") ?? []
            
            completion(response.resultError(), events)
        }
    }
    
    func getEventDeatils(by eventId: String, completion: @escaping (_ error: NSError?, _ events: Event?) -> Void) {
        
        request(.get, serverAPI: .eventsDetails(eventId: eventId), parameters: nil).responseJSON { response in
            
            let event: Event? = response.resultObject()
            
            completion(response.resultError(), event)
        }
    }
    
    func getEventTweets(by eventId: String, completion: @escaping (_ error: NSError?, _ eventTweets: [EventTweet]) -> Void) {
        
        request(.get, serverAPI: .eventsTweets(eventId: eventId), parameters: nil).responseJSON { response in
            
             let eventTweets: [EventTweet] = response.resultArray(by: "results") ?? []
            
            completion(response.resultError(), eventTweets)
        }
    }
}

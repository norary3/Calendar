//
//  Events.swift
//  DewDate
//
//  Created by 박종훈 on 2016. 12. 6..
//  Copyright © 2016년 Koreauniv. All rights reserved.
//

import Foundation
import EventKit

var myEvents:[Event] = []

let eventStore = EKEventStore()

let dateFormatter = DateFormatter()

func readEvents() {
    let eventStore = EKEventStore()
    let calendars = eventStore.calendars(for: .event)
    for calendar in calendars {
        let oneMonthAgo = Date(timeIntervalSinceNow: -90*24*3600)
        let oneMonthAfter = Date(timeIntervalSinceNow: +90*24*3600)
        
        let predicate = eventStore.predicateForEvents(withStart: oneMonthAgo, end: oneMonthAfter, calendars: [calendar])
        
        let events = eventStore.events(matching: predicate)
        
        for event in events{
            if let url = event.url, let memo = event.notes {
                
                let newEvent = Event(title: event.title,location:event.location!, isAllDay: event.isAllDay, startDate: event.startDate, endDate: event.endDate,eventIdentifier: event.eventIdentifier, url: url, memo: memo)
                myEvents += [newEvent]
            } else {
                let newEvent = Event(title: event.title,location:event.location!, isAllDay: event.isAllDay, startDate: event.startDate, endDate: event.endDate,eventIdentifier: event.eventIdentifier, url: NSURLComponents().url!, memo:"")
                myEvents += [newEvent]
            }
            
        }
    }
    myEvents.sort( by: { (older, recent) -> Bool in
        if older.startDate.compare(recent.startDate as Date) == ComparisonResult.orderedAscending {
            return true
        } else {
            return false
        }
    })
    //print("myEvents.count: \(myEvents.count)")
}


func readEvents(startDate: Date, endDate: Date) -> [EKEvent]? {
    var events: [EKEvent]?
    //dateFormatter.dateFormat = "yyyy-MM-dd"
    
    // Use an event store instance to create and properly configure an NSPredicate
    let eventsPredicate = eventStore.predicateForEvents(withStart: startDate, end: endDate, calendars: eventStore.calendars(for: .event))
    
    // Use the configured NSPredicate to find and return events in the store that match
    events = eventStore.events(matching: eventsPredicate).sorted(){
        (e1: EKEvent, e2: EKEvent) -> Bool in
        return e1.startDate.compare(e2.startDate) == ComparisonResult.orderedAscending
    }
    
    return events
}

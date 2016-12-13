////
////  Classes.swift
////  DewDate
////
////  Created by cscoi027 on 2016. 8. 10..
////  Copyright © 2016년 Koreauniv. All rights reserved.
////
//
//import Foundation
//
//typealias Time = (year:Int, mon:Int, day:Int, h:Int, m:Int)
//typealias ID = String
//
//enum repeat_intervals {
//    case none, evr_day,evr_week, evr_2week, evr_mon,evr_year
//}
//
//enum move_times {
//    case none, min5, min15, min30, min60, min90, min120
//}
//
//enum alarm_times {
//    case none, oclock, min5, min10, min15, min30, min60, min120, day1, day2
//}
//
//enum invitation_status {
//    case accepted, declined, postponed
//}
//// 이제 우리는 자체 캘린더 아니고, 애플 캘린더 가져다 쓸꺼니까 이하는 필요가 없음.
//class Event{
//    var location:String?
//    var isAllDay:Bool = false
//    /*var start:Time
//    var end:Time
//    var repeat_interval:repeat_intervals = repeat_intervals.none    //= ["안함":false,"매일":false,"매주":false,"2주마다":false,"매월":false,"매년":false]
//    var move_time:move_times = move_times.none    // = ["5분":false,"15분":false,"30분":false,"1시간":false,"1시간,30분":false,"2시간":false]
//    var alarm:alarm_times = alarm_times.none   //= ["이동 시간 시작 시":false, "이동 시간 5분 전":false]*/
//    
//    init(name:String, isAllDay:Bool) {
//        self.name = name
//        self.isAllDay = true
//        //self.start = start
//        //self.end = end
//    }
//    
//    /*init(name:String, location:String, start:Time, end:Time) {
//        self.name = name
//        self.location = location
//        self.start = start
//        self.end = end
//    }
//    
//    init(name:String, location:String, isAllDay:Bool, start:Time, end:Time, repeat_interval:repeat_intervals, move_time:move_times, alarm:alarm_times) {
//        self.name = name
//        self.location = location
//        self.isAllDay = isAllDay
//        self.start = start
//        self.end = end
//        self.repeat_interval = repeat_interval
//        self.move_time = move_time
//        self.alarm = alarm
//    }
//    
//    func modify(new_name:String, new_location:String, new_isAllDay:Bool, new_start:Time, new_end:Time, new_repeat_interval:repeat_intervals, new_move_time:move_times, new_alarm:alarm_times) -> () {
//        self.name = new_name
//        self.location = new_location
//        self.isAllDay = new_isAllDay
//        self.start = new_start
//        self.end = new_end
//        self.repeat_interval = new_repeat_interval
//        self.move_time = new_move_time
//        self.alarm = new_alarm
//    }*/
//    
//    
//     func mod_name(new_name:String) -> () {
//         self.name = new_name
//     }
//     
//     func mod_location(new_locaiton:String) -> () {
//         self.location = new_locaiton
//     }
//     
//     func mod_isAllDay() -> () {
//        if self.isAllDay == true {
//             self.isAllDay = false
//        } else {
//            self.isAllDay = true
//        }
//     }
// 
//}
//
//class Invitation {
//    let invitor:ID
//    let event:Event
//    var status:invitation_status = invitation_status.postponed
//
//    init (invitor:ID, event:Event) {
//        self.invitor = invitor
//        self.event = event
//    }
//}


import EventKit

class Event{
    
    var title:String
    var location:String
    var isAllDay:Bool
    var startDate:Date
    var endDate:Date
    var eventIdentifier:String
    var url:URL
    var memo:String
    
    init(title:String,location:String, isAllDay:Bool, startDate:Date,endDate:Date, eventIdentifier:String, url:URL, memo:String){
        self.eventIdentifier = eventIdentifier
        self.title = title
        self.isAllDay = isAllDay
        self.location = location
        self.startDate = startDate
        self.endDate = endDate
        self.url = url
        self.memo = memo
        
    }
    
    init(){
        self.eventIdentifier = ""
        self.title = ""
        self.isAllDay = false
        self.location = ""
        self.startDate = Date()
        self.endDate = Date()
        self.url = NSURLComponents().url!
        self.memo = ""
        
    }
    
    func arrOfAddInfo()->Array<(String, String)> {
        var arr:Array<(String, String)> = []
        if self.url != NSURLComponents().url!  { arr.append( ("url", "\(self.url)") ) }
        if self.memo != "" { arr.append( ("memo", "\(self.memo)") ) }
        return arr
    }
    
}


// let temp:Event
// temp.location = "aaaaaa"


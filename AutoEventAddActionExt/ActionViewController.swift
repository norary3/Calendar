//
//  DewDate
//
//  Created by cscoi027 on 2016. 8. 23..
//  Copyright © 2016년 Koreauniv. All rights reserved.
//

import UIKit
import MobileCoreServices
import EventKit

extension String {
    public func indexOfCharacter(_ char: Character) -> Int? {
        if let idx = self.characters.index(of: char) {
            return self.characters.distance(from: self.startIndex, to: idx)
        }
        return nil
    }
    
    func toDateTime(_ dateFormatter:DateFormatter) -> Date
    {
        //Parse into NSDate
        let dateFromString : Date = dateFormatter.date(from: self)!
        
        //Return Parsed Date
        return dateFromString
    }
}

extension Date
{
    func year() -> Int
    {
        let calendar = Calendar.current
        let components = (calendar as NSCalendar).components(.year, from: self)
        let year = components.year
        
        return year!
    }
    
    func month() -> Int
    {
        let calendar = Calendar.current
        let components = (calendar as NSCalendar).components(.month, from: self)
        let month = components.month
        
        return month!
    }
    
    func day() -> Int
    {
        let calendar = Calendar.current
        let components = (calendar as NSCalendar).components(.day, from: self)
        let day = components.day
        
        return day!
    }
    
    func hour() -> Int
    {
        //Get Hour
        let calendar = Calendar.current
        let components = (calendar as NSCalendar).components(.hour, from: self)
        let hour = components.hour
        
        //Return Hour
        return hour!
    }
    
    
    func minute() -> Int
    {
        //Get Minute
        let calendar = Calendar.current
        let components = (calendar as NSCalendar).components(.minute, from: self)
        let minute = components.minute
        
        //Return Minute
        return minute!
    }
    
    func toTimeString(_ formatter:DateFormatter) -> String
    {
        //Get Time String
        
        let timeString = formatter.string(from: self)
        
        //Return Time String
        return timeString
    }
    
}

let spaceSet = CharacterSet.whitespacesAndNewlines

class ActionTableViewController: UITableViewController {
    var convertingString: String?
    let cal = Calendar.current
    
    var eventTitle:String = ""
    var eventLocation = ""
    var eventIsAllDay = false
    var eventStart:Date = Date()
    var eventEnd:Date = Date()
    //var eventRepeat:EKRecurrenceRule? = nil
    //var eventAlarm:EKAlarm? = nil
    var eventURL:URL = NSURLComponents().url!
    var eventMemo = ""
    
    //Create Date Formatter
    var dateFormatter = DateFormatter()
    
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var endLabel: UILabel!
    //@IBOutlet weak var repeatLabel: UILabel!
    //@IBOutlet weak var alarmLabel: UILabel!
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var memoTextField: UITextView!
    
    @IBAction func addButton(_ sender: AnyObject) {
        let eventStore = EKEventStore()
        if let newEventTitle = self.titleTextField.text { self.eventTitle =  newEventTitle }
        if let newEventLocation = self.locationTextField.text { self.eventLocation = newEventLocation }
        if let newEventStart = self.startLabel.text?.toDateTime(self.dateFormatter) { self.eventStart = newEventStart }
        if let newEventEnd = self.endLabel.text?.toDateTime(self.dateFormatter) { self.eventEnd = newEventEnd }
        if let newEventURL = URL(string: self.urlTextField.text!) { self.eventURL = newEventURL }
        if let newEventMemo = self.memoTextField.text { self.eventMemo = newEventMemo }
        
        if (EKEventStore.authorizationStatus(for: .event) != EKAuthorizationStatus.authorized) {
            eventStore.requestAccess(to: .event, completion: {
                granted, error in
                if granted {
                    self.createEvent(eventStore)
                    self.doneAlert()
                } else {
                    self.failAlert()
                }
            })
        } else {
            self.createEvent(eventStore)
            self.doneAlert()
        }
    }
    
    @IBAction func cancelButton(_ sender: AnyObject) {
        // 이 함수는 입력 아이템을 unpacking하는 과정을 반대로 한다. 첫번째로 수정된 컨텐츠(convertedString)와 컨텐츠 타입 식별자(여기서는 kUTTypeText)로 구성한 새로운 NSItemProvider인스턴스를 생성한다.
        //let returnProvider = NSItemProvider(item:convertingString, typeIdentifier: kUTTypeText as NSString as String)
        // 새로운 NSExtensionItem인스턴스를 생성하고 NSItemProvider 객체를 attachments에 할당한다.(호스트 앱으로 다시 전달하기 위하여 갱신된 정보를 저장)
        //let returnItem = NSExtensionItem()
        //returnItem.attachments = [returnProvider]
        
        // 익스텐션 콘텍스트의 completeRequestReturningItems 메서드에 NSExtensionItem 인스턴스를 인자로 전달하며 호출
        //extensionContext!.completeRequestReturningItems([returnItem], completionHandler: nil)
        self.extensionContext!.completeRequest(returningItems: self.extensionContext!.inputItems, completionHandler: nil)
    }
    
    @IBAction func isAllDaySwitch(_ sender: AnyObject) {
        let allDaySwitch = sender as! UISwitch
        let allDayBool:Bool = allDaySwitch.isOn
        self.eventIsAllDay = allDayBool
        if eventIsAllDay {
            //Specify Format of String to Parsez
            self.dateFormatter.dateFormat = "yyyy-MM-dd"
            self.startDatePickerValue.datePickerMode = UIDatePickerMode.date
            self.endDatePickerValue.datePickerMode = UIDatePickerMode.date
            self.startLabel.text = self.eventStart.toTimeString(self.dateFormatter)
            self.endLabel.text = self.eventEnd.toTimeString(self.dateFormatter)
        } else {
            //Specify Format of String to Parsez
            self.dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
            self.startDatePickerValue.datePickerMode = UIDatePickerMode.dateAndTime
            self.endDatePickerValue.datePickerMode = UIDatePickerMode.dateAndTime
            self.startLabel.text = self.eventStart.toTimeString(self.dateFormatter)
            self.endLabel.text = self.eventEnd.toTimeString(self.dateFormatter)
        }
    }
    
    @IBOutlet weak var startDatePickerValue: UIDatePicker!
    @IBAction func startDatePicker(_ sender: AnyObject) {
        //self.endCheck()
        self.eventStart = startDatePickerValue.date
        self.startLabel.text = eventStart.toTimeString(self.dateFormatter)
    }
    
    @IBOutlet weak var endDatePickerValue: UIDatePicker!
    @IBAction func endDatePicker(_ sender: AnyObject) {
        //self.endCheck()
        self.eventEnd = endDatePickerValue.date
        self.endLabel.text = eventEnd.toTimeString(self.dateFormatter)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Specify Format of String to Parse
        self.dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        /*
         모든 익스텐션 뷰 컨트롤러는 NSExtensionContext 클래스의 인스턴스 형태로 연결된 익스텐션 콘텍스트(extension context)를 갖는다. 익스텐션 콘텍스트의 참조체는 뷰 컨트롤러의 extensionContext 속성을 통해 접근할 수 있다. 익스텐션 콘텍스트는 객체들을 포함하고 있는 배열의 형태인 inputi
         */
        // 각각의 NSExtensionItem객체는 attachment객체들의 배열을 갖는다. attachment객체는 NSItemProvider 타입이며, 호스트앱의 데이터에 접근할 수 있다. attachment객체의 참조체를 얻었으면 익스텐션이 지원하는 타입의 데이터를 호스트 애플리케이션이 가지고 있는지 검증하기 위하여 attachment 객체의 hasItemConformingToTypeIdentifier 메서드를 호출할 수 있다.
        let textItem: NSExtensionItem = extensionContext?.inputItems[0] as! NSExtensionItem
        let textItemProvider = textItem.attachments![0] as! NSItemProvider
        // 핸들러 지정(string이라는 이름의 NSSecureCoding 변수와 error라는 이름의 NSError변수를 전달받아 처리하는 익명함수 선언)
        let handlerCompletion: (NSSecureCoding?, NSError)->Void = { string, error in
            // 핸들러 매개변수로 전달받은 변수를 String형태로 형변환하여 저장
            self.convertingString = string as? String
            if let parsingString = self.convertingString {
                // 전달받은 텍스트 데이터를 Parsing
                /* 전달 받는 텍스트 예시
                 제목:놀이공원 데이트
                 위치:롯데월드
                 시작:2016년 8월 20일 10:00
                 종료:2016년 8월 20일 17:00
                 */
                
                var titleFlag = false
                var startFlag = false
                var endFlag = false
                
                let lines = parsingString.components(separatedBy: "\n")
                for line in lines {
                    if line != "" {
                        let front = line.substring(to: line.characters.index(line.startIndex, offsetBy: 2))
                        let back = line.substring(from: line.characters.index(line.startIndex, offsetBy: 3))
                        switch front {
                        case "제목" :
                            titleFlag = true
                            self.eventTitle = back
                        case "위치",
                             "장소" :
                            self.eventLocation = back
                        case "시작" :
                            startFlag = true
                            let startString = self.parsDate(back)
                            self.eventStart = startString.toDateTime(self.dateFormatter)
                        case "종료" :
                            endFlag = true
                            let endString = self.parsDate(back)
                            self.eventEnd = endString.toDateTime(self.dateFormatter)
                        //self.endCheck()
                        default:
                            continue
                        }
                    }
                    self.eventMemo += line + "\n"
                }
                
                if titleFlag == false {
                    self.title = "DewDate 일정"
                }
                
                if startFlag == false {
                    if endFlag == false {
                        self.eventStart = Date.init()
                    } else {
                        self.eventStart = self.cal.date(byAdding: .hour, value: -2, to: self.eventEnd)!
                    }
                }
                
                if endFlag == false {
                    self.eventEnd = self.cal.date(byAdding: .hour, value: 2, to: self.eventStart)!
                }
                
                // 메인스레드를 통하여 화면의 TextView에 갱신처리
                DispatchQueue.main.async{
                    self.titleTextField.text = self.eventTitle
                    self.locationTextField.text = self.eventLocation
                    self.startLabel.text = self.eventStart.toTimeString(self.dateFormatter)
                    self.endLabel.text = self.eventEnd.toTimeString(self.dateFormatter)
                    self.memoTextField.text = self.eventMemo
                }
            }
        }
        // 호스트 앱이 원하고자 하는 타입의 데이터를 가지고 있다면 익스텐션이 지원하는 UTI 컨텐츠 타입인자로 다시 전달되는 loadItemForTypeIdentifier 메서드 호출을 통하여 그 데이터가 익스텐션에 로드될수 있다. 호스트앱의 데이터를 로딩하는 것은 비동기적으로 수행하므로 데이터 로딩 과정이 완료될때 호출되는 완료 핸들러를 지정해야 한다.
        if textItemProvider.hasItemConformingToTypeIdentifier(kUTTypeText as NSString as String) {
            textItemProvider.loadItem(
                forTypeIdentifier: kUTTypeText as String,      // 텍스트 타입의 데이터를 수신할 것으로 지정
                options: nil,
                // viewDidLoad에 선언한 handlerCompletion 변수를 통하여 핸들러를 지정하여 처리하도록 전달한다.
                // Swift 2.0에서는 unsafeBitCast함수를 이용하도록 변경되었다.
                completionHandler: unsafeBitCast(handlerCompletion, to: NSItemProvider.CompletionHandler.self)
            )
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch section {
        case 0:
            return 2
        case 1:
            return 5
        case 2:
            return 2
        default:
            return 0
            
        }
    }
    
    /*
     override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)
     
     // Configure the cell...
     
     return cell
     }
     */
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
     if editingStyle == .Delete {
     // Delete the row from the data source
     tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
     } else if editingStyle == .Insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    var StartPickerRowHeight:CGFloat = 0.0
    var EndPickerRowHeight:CGFloat = 0.0
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath {
        case IndexPath(row: 1, section: 1):
            startDatePickerValue.setDate(self.eventStart, animated: false)
            if StartPickerRowHeight < 100 { StartPickerRowHeight = 210.0 }
            else { StartPickerRowHeight = 0.0 }
            self.tableView.reloadData()
        case IndexPath(row: 3, section: 1):
            endDatePickerValue.setDate(self.eventEnd, animated: false)
            if EndPickerRowHeight < 100 { EndPickerRowHeight = 210.0 }
            else { EndPickerRowHeight = 0.0 }
            self.tableView.reloadData()
        default:
            if indexPath != IndexPath(row: 2, section: 1) && indexPath != IndexPath(row: 4, section: 1) {
                StartPickerRowHeight = 0.0
                EndPickerRowHeight = 0.0
                self.tableView.reloadData()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        switch indexPath {
        case IndexPath(row: 2, section: 1):
            return StartPickerRowHeight
        case IndexPath(row: 4, section: 1):
            return EndPickerRowHeight
        case IndexPath(row: 1, section: 2):
            return 150.0
        default:
            return 44.0
        }
    }
    
    
    // Creates an event in the EKEventStore. The method assumes the eventStore is created and
    // accessible
    func createEvent(_ eventStore: EKEventStore) {
        let event = EKEvent(eventStore: eventStore)
        event.title = self.eventTitle
        event.isAllDay = self.eventIsAllDay
        event.startDate = self.eventStart
        event.endDate = self.eventEnd
        event.location = self.eventLocation
        event.notes = self.eventMemo
        event.url = self.eventURL
        /*
         if let alarm = self.eventAlarm {
         event.alarms = [alarm]
         }
         */
        event.calendar = eventStore.defaultCalendarForNewEvents
        
        do {
            try eventStore.save(event, span: .thisEvent)
        } catch {
            print("Bad things happened creating evnet")
        }
    }
    
    func doneAlert() {
        // show adding has done as actionSheet
        let addAlert = UIAlertController(title: "\(self.eventTitle) 일정이 캘린더에 추가되었습니다.", message: nil, preferredStyle: .actionSheet)
        /*  // only today wiget open its containing app
         let moveToCalAction = UIAlertAction(title: "DewDate로 이동", style: .Default, handler: { (action:UIAlertAction) -> Void in
         print ("캘린더로 이동 선택")
         // TODO : move to Event Table
         self.goToDewDateCal()
         
         })
         */
        let exitAction = UIAlertAction(title: "종료", style: .cancel, handler: { (action:UIAlertAction) -> Void in
            print ("종료 선택")
            self.extensionContext!.completeRequest(returningItems: self.extensionContext!.inputItems, completionHandler: nil)})
        //addAlert.addAction(moveToCalAction)
        addAlert.addAction(exitAction)
        self.present(addAlert, animated: true, completion: nil)
    }
    
    func failAlert() {
        let addAlert = UIAlertController(title: "\(self.eventTitle) 일정을 저장할 수 없습니다. DewDate가 캘린더에 접근할 수 있도록 허가해 주세요", message: nil, preferredStyle: .actionSheet)
        let exitAction = UIAlertAction(title: "종료", style: .cancel, handler: { (action:UIAlertAction) -> Void in
            print ("종료 선택")
            self.extensionContext!.completeRequest(returningItems: self.extensionContext!.inputItems, completionHandler: nil)})
        addAlert.addAction(exitAction)
        self.present(addAlert, animated: true, completion: nil)
    }
    
    func parsDate(_ back:String)->String {
        var rest = back
        let year:Int
        let month:Int
        let day:Int
        let hour:Int
        let minute:Int
        
        // parsiing year
        if let intIndex = rest.indexOfCharacter("년"), let yearFromStirng = Int(rest.substring(to: rest.characters.index(rest.startIndex, offsetBy: intIndex))) {
            year = yearFromStirng
            rest = rest.substring(from: rest.characters.index(rest.startIndex, offsetBy: intIndex+1)).trimmingCharacters( in: spaceSet )
        } else {
            year = Date().year()
        }
        // parsing month
        if let intIndex = rest.indexOfCharacter("월"), let monthFromStirng = Int(rest.substring(to: rest.characters.index(rest.startIndex, offsetBy: intIndex))) {
            month = monthFromStirng
            rest = rest.substring(from: rest.characters.index(rest.startIndex, offsetBy: intIndex+1)).trimmingCharacters( in: spaceSet )
        } else {
            month = Date().month()
        }
        // parsing day
        if let intIndex = rest.indexOfCharacter("일"), let dayFromStirng = Int(rest.substring(to: rest.characters.index(rest.startIndex, offsetBy: intIndex))) {
            day = dayFromStirng
            rest = rest.substring(from: rest.characters.index(rest.startIndex, offsetBy: intIndex+1)).trimmingCharacters( in: spaceSet )
        } else {
            day = Date().day()
        }
        // parsing hour
        if let intIndex = rest.indexOfCharacter(":"), let hourFromStirng = Int(rest.substring(to: rest.characters.index(rest.startIndex, offsetBy: intIndex))) {
            hour = hourFromStirng
            rest = rest.substring(from: rest.characters.index(rest.startIndex, offsetBy: intIndex+1)).trimmingCharacters( in: spaceSet )
        } else {
            hour = Date().hour()
        }
        // parsing minute
        if let minuteFromString = Int(rest) {
            minute = minuteFromString
        } else { minute = 0}
        /*
         if let intIndex = rest.indexOfCharacter("분") {
         minute = rest.substringToIndex(rest.startIndex.advancedBy(intIndex))
         } else {
         minute = "\(NSDate().minute())"
         }
         */
        
        // "yyyy-MM-dd hh:mm"
        let returnString = String(format: "%04d", year) + "-" + String(format: "%02d", month) + "-" + String(format: "%02d", day) + " " + String(format: "%02d", hour) + ":" + String(format: "%02d", minute)
        return returnString
    }
    /*
     func endCheck() {
     if self.eventEnd.compare(self.eventStart) == NSComparisonResult.OrderedAscending {
     if self.eventEnd.year() < self.eventStart.year() {
     let dateString = String(format: "%04d", self.eventStart.year()) + "-" + String(format: "%02d", self.eventEnd.month()) + "-" + String(format: "%02d", self.eventEnd.day()) + " " + String(format: "%02d", self.eventEnd.hour()) + ":" + String(format: "%02d", self.eventEnd.minute())
     self.eventEnd = dateString.toDateTime(self.dateFormatter)
     endCheck()
     } else if self.eventEnd.month() < self.eventStart.month() {
     let dateString = String(format: "%04d", self.eventEnd.year()) + "-" + String(format: "%02d", self.eventStart.month()) + "-" + String(format: "%02d", self.eventEnd.day()) + " " + String(format: "%02d", self.eventEnd.hour()) + ":" + String(format: "%02d", self.eventEnd.minute())
     self.eventEnd = dateString.toDateTime(self.dateFormatter)
     endCheck()
     } else if self.eventEnd.day() < self.eventStart.day() {
     let dateString = String(format: "%04d", self.eventEnd.year()) + "-" + String(format: "%02d", self.eventEnd.month()) + "-" + String(format: "%02d", self.eventStart.day()) + " " + String(format: "%02d", self.eventEnd.hour()) + ":" + String(format: "%02d", self.eventEnd.minute())
     self.eventEnd = dateString.toDateTime(self.dateFormatter)
     endCheck()
     } else if self.eventEnd.hour() < self.eventStart.hour() {
     let dateString = String(format: "%04d", self.eventEnd.year()) + "-" + String(format: "%02d", self.eventEnd.month()) + "-" + String(format: "%02d", self.eventEnd.day()) + " " + String(format: "%02d", self.eventStart.hour()) + ":" + String(format: "%02d", self.eventEnd.minute())
     self.eventEnd = dateString.toDateTime(self.dateFormatter)
     endCheck()
     } else if self.eventEnd.minute() < self.eventStart.minute() {
     let dateString = String(format: "%04d", self.eventEnd.year()) + "-" + String(format: "%02d", self.eventEnd.month()) + "-" + String(format: "%02d", self.eventEnd.day()) + " " + String(format: "%02d", self.eventEnd.hour()) + ":" + String(format: "%02d", self.eventStart.minute())
     self.eventEnd = dateString.toDateTime(self.dateFormatter)
     endCheck()
     }
     }
     }
     */
    
}

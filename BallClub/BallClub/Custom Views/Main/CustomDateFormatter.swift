//
//  CustomDateFormatter.swift
//  BallClub
//
//  Created by Geraldine Forto on 07/09/2016.
//  Copyright © 2016 Geraldine Forto. All rights reserved.
//

import UIKit

class CustomDateFormatter: NSObject {
  
  var dateFormatter = DateFormatter()
  
  func feedsDateFormat(feedDate : NSDate) -> String {
    dateFormatter.dateFormat = "E\nM/d"
    return dateFromFormat(feedDate: feedDate).uppercased()
  }
  
  func createGameDateFormat(feedDate : NSDate) -> String {
    dateFormatter.dateFormat = "MMMM dd,yyyy hh:mm a"
    return dateFromFormat(feedDate: feedDate)
  }
  
  func gameDetailsDateFormat(startTime : NSDate, endTime : NSDate) -> String {
    dateFormatter.dateFormat = "EEEE,hh:mm a - "
    let startTimeString = dateFromFormat(feedDate: startTime)
    dateFormatter.dateFormat = "hh:mm a"
    return startTimeString + dateFromFormat(feedDate: endTime)
  }
  
  func friendGameDateFormat(feedDate : NSDate) -> String {
    dateFormatter.dateFormat = "d\nMMM"
    return dateFromFormat(feedDate: feedDate).uppercased()
  }
  
  
  func dateFromFormat(feedDate : NSDate) -> String {
    dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
    let timeStamp = dateFormatter.string(from: feedDate as Date)
    return timeStamp
  }
}

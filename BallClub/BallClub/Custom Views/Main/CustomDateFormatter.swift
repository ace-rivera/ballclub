//
//  CustomDateFormatter.swift
//  BallClub
//
//  Created by Geraldine Forto on 07/09/2016.
//  Copyright © 2016 Geraldine Forto. All rights reserved.
//

import UIKit

class CustomDateFormatter: NSObject {
  
  var dateFormatter = NSDateFormatter()
  
  func feedsDateFormat(feedDate : NSDate) -> String {
    dateFormatter.dateFormat = "E M/d"
    return dateFromFormat(feedDate).uppercaseString
  }
  
  func createGameDateFormat(feedDate : NSDate) -> String {
    dateFormatter.dateFormat = "MMMM dd,yyyy hh:mm a"
    return dateFromFormat(feedDate)
  }
  
  func gameDetailsDateFormat(startTime : NSDate, endTime : NSDate) -> String {
    dateFormatter.dateFormat = "EEEE,hh:mm a - "
    let startTimeString = dateFromFormat(startTime)
    dateFormatter.dateFormat = "hh:mm a"
    return startTimeString + dateFromFormat(endTime)
  }
  
  func friendGameDateFormat(feedDate : NSDate) -> String {
    dateFormatter.dateFormat = "d MMM"
    return dateFromFormat(feedDate).uppercaseString
  }
  
  
  func dateFromFormat(feedDate : NSDate) -> String {
    dateFormatter.timeZone = NSTimeZone(name: "UTC")
    let timeStamp = dateFormatter.stringFromDate(feedDate)
    return timeStamp
  }
}

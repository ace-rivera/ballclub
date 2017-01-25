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
  
  func feedsDateFormat(feedDate : Date) -> String {
    dateFormatter.dateFormat = "E\nM/d"
    return dateFromFormat(feedDate: feedDate).uppercased()
  }
  
  func createGameDateFormat(feedDate : Date) -> String {
    dateFormatter.dateFormat = "MMMM dd,yyyy hh:mm a"
    return dateFromFormat(feedDate: feedDate)
  }
  
  func gameDetailsDateFormat(startTime : Date, endTime : Date) -> String {
    dateFormatter.dateFormat = "E,hh:mm a - "
    let startTimeString = dateFromFormat(feedDate: startTime)
    dateFormatter.dateFormat = "hh:mm a"
    return startTimeString + dateFromFormat(feedDate: endTime)
  }
  
  func friendGameDateFormat(feedDate : Date) -> String {
    dateFormatter.dateFormat = "d\nMMM"
    return dateFromFormat(feedDate: feedDate).uppercased()
  }
  
  
  func dateFromFormat(feedDate : Date) -> String {
    dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
    let timeStamp = dateFormatter.string(from: feedDate as Date)
    return timeStamp
  }
  
  func gameDetailsTimeFormat(startTime : Date) -> String {
    dateFormatter.dateFormat = "hh:mm a"
    let startTimeString = dateFromFormat(feedDate: startTime)

    return startTimeString
  }
}

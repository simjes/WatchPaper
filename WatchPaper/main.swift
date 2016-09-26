//
//  main.swift
//  WatchPaper
//
//  Created by Simon on 16/09/16.
//  Copyright (c) 2016 Simjes. All rights reserved.
//

import Foundation
import AppKit

let imgDir = NSHomeDirectory() + "/Pictures/WatchPaper/"
let hour = NSCalendar.currentCalendar().component(.Hour, fromDate: NSDate())

func getPicture(currentTime: Int) -> String {
    if (currentTime >= 6 && currentTime < 10) {
        return "sunrise.jpg"
    } else if (currentTime >= 10 && currentTime < 13) {
        return "morning.jpg"
    } else if (currentTime >= 13 && currentTime < 18) {
        return "day.png"
    } else if (currentTime >= 118 && currentTime < 21) {
        return "sunset.jpg"
    } else if (currentTime >= 21 && currentTime < 24) {
        return "dark.jpg"
    } else {
        return "night.png"
    }
}

var wallpaper = imgDir + getPicture(hour)

func changeAllWallpapers(image: String) {
    let paths: [String] = NSSearchPathForDirectoriesInDomains(.ApplicationSupportDirectory,
                                                              .UserDomainMask, true)
    let appSup: String = paths.first!
    let dbPath: String = (appSup as NSString).stringByAppendingPathComponent("Dock/desktoppicture.db")
 
    let dbase = try? Connection("\(dbPath)")
    let value = Expression<String?>("value")
    let table = Table("data")
    try! dbase!.run(table.update(value <- image))
    system("/usr/bin/killall Dock")
}

let workspace = NSWorkspace.sharedWorkspace()
let screen = AppKit.NSScreen.mainScreen()

var currentWallpaper = NSWorkspace.sharedWorkspace().desktopImageURLForScreen(screen!)!.path!
if (currentWallpaper != wallpaper) {
    print(NSDate().description + ": Updated wallpaper")
    changeAllWallpapers(wallpaper)
}


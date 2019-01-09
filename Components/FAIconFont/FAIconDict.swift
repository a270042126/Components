//
//  FAIconDict.swift
//  DrivingExam
//
//  Created by dd on 2019/1/8.
//  Copyright © 2019年 dd. All rights reserved.
//

import UIKit

public enum FAFontType: String{
    case icofont = "icofont"
    case themify = "themify"
    case fontawesome = "fontawesome"
}

public let FAIconDict: [String:[String: String]] = [
   
    "icofont": [
        "child-rencare": "\u{eeda}",
        "check-circled": "\u{eed7}",
        "close-circled": "\u{eedd}"
    ],
    
    "themify": [
        "ti-view-grid": "\u{e669}"
    ],
    
    "fontawesome": [
        "fa-star": "\u{f005}",
        "fa-star-o": "\u{f006}"
    ]

]

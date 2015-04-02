//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Kevin Murray on 3/21/15.
//  Copyright (c) 2015 Murray. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject {
    
    // create class variables
    var filePathUrl: NSURL!
    var title: String!
    
    // initialize class
    init(filePathUrl: NSURL!, title:  String) {
        self.filePathUrl=filePathUrl
        self.title=title
    }
}
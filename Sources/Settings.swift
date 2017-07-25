//
//  Settings.swift
//  ChickGen
//
//  Created by Christoph on 19.05.17.
//
//

import Foundation

public class Settings {
    
    public var general: General
    public var classes: [Class]
    public var enums: [Enum]
    
    public init() {
        self.general = General()
        self.classes = []
        self.enums = []
    }
    
}

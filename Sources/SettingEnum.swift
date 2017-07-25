//
//  SettingEnum.swift
//  ChickGen
//
//  Created by Christoph Pageler on 25.07.17.
//

import Foundation

public extension Settings {
    
    public class Enum {
        
        public var name: String
        public var cases: [String]
        
        public init(name: String, cases: [String]) {
            self.name = name
            self.cases = cases
        }
        
        public func filename() -> String {
            return "\(name)Enum.swift"
        }
        
    }
    
}

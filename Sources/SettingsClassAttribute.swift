//
//  SettingsClassAttribute.swift
//  ChickGen
//
//  Created by Christoph Pageler on 25.07.17.
//

import Foundation

public extension Settings.Class {
    
    public class Attribute {
        
        public var ref: Settings.ClassRef
        public var name: String
        public var type: String
        public var optional: Bool
        
        public init(ref: Settings.ClassRef = .let,
                    name: String,
                    type: String,
                    optional: Bool = false) {
            self.ref = ref
            self.name = name
            self.type = type
            self.optional = optional
        }
        
        public func swiftType() -> String {
            return type + (optional ? "?" : "")
        }
    }
    
}

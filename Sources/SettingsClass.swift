//
//  SettingsClass.swift
//  ChickGen
//
//  Created by Christoph Pageler on 25.07.17.
//

import Foundation

public extension Settings {
    
    public class Class {
        
        public var name: String
        public var superclass: String?
        public var imports: [String]?
        public var attributes: [Attribute]?
        public var functions: [Function]?
        public var enums: [Enum]?
        
        public init(name: String, attributes: [Attribute], functions: [Function]) {
            self.name = name
            self.attributes = attributes
            self.functions = functions
        }
        
        public func filename() -> String {
            return name + ".swift"
        }
        
        public func swiftClass() -> String {
            return name + (self.superclass != nil ? (": " + self.superclass!) : "")
        }
    }
    
}

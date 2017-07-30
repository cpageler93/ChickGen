//
//  SettingsExtension.swift
//  ChickGen
//
//  Created by Christoph Pageler on 30.07.17.
//

import Foundation

public extension Settings {
    public class Extension {
        
        public var name: String
        public var filename: String?
        public var inheritance: String?
        public var imports: [String]?
        public var functions: [Settings.Class.Function]?
        public var accessControl: String = "public"
        
        public init(name: String) {
            self.name = name
        }
        
        public func swiftFileName() -> String {
            let actualFilename = filename ?? name
            return "\(actualFilename).swift"
        }
        
        public func swiftExtensionName() -> String {
            return name + (self.inheritance != nil ? (": " + self.inheritance!) : "")
        }
        
    }
}

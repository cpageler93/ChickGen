//
//  Settings.swift
//  ChickGen
//
//  Created by Christoph on 19.05.17.
//
//

import Foundation

open class Settings {
    
    // MARK: - General
    
    open class General {
        var author: String?
    }
    var general: General?
    
    // MARK: - Class
    
    public enum ClassRef: String {
        case `let`
        case `var`
    }
    
    open class Class {
        var name: String
        var superclass: String?
        var imports: [String]?
        
        open class Attribute {
            var ref: ClassRef
            var name: String
            var type: String
            var optional: Bool
            
            init(ref: ClassRef = .let,
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
        var attributes: [Attribute] = []
        
        init(name: String, attributes: [Attribute]) {
            self.name = name
            self.attributes = attributes
        }
        
        public func filename() -> String {
            return name + ".swift"
        }
        
        public func swiftClass() -> String {
            return name + (self.superclass != nil ? (": " + self.superclass!) : "")
        }
    }
    var classes: [Class] = []
    
}

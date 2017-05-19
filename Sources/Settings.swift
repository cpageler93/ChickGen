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
        var projectName: String?
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
        
        open class Function {
            var name: String
            
            open class Parameter {
                var label: String?
                var name: String
                var type: String
                var optional: Bool = false
                
                init(name: String, type: String) {
                    self.name = name
                    self.type = type
                }
            }
            var parameters: [Parameter]
            
            var returnType: String?
            var bodyLines: [String]
            
            init(name: String, parameters: [Parameter]? = nil, bodyLines: [String]) {
                self.name = name
                if let parameters = parameters {
                    self.parameters = parameters
                } else {
                    self.parameters = []
                }
                self.bodyLines = bodyLines
            }
            
            public func formattedParameters() -> String {
                guard parameters.count > 0 else {
                    return ""
                }
                
                var formattedParameterArray: [String] = []
                for parameter in parameters {
                    let labelString = parameter.label != nil ? parameter.label! + " " : ""
                    let optionalString = parameter.optional ? "?" : ""
                    let formattedParmeter = "\(labelString)\(parameter.name): \(parameter.type)\(optionalString)"
                    formattedParameterArray.append(formattedParmeter)
                }
                
                return formattedParameterArray.joined(separator: ", ")
            }
            
            public func formattedReturn() -> String {
                if let returnType = returnType {
                    return "-> \(returnType)"
                } else {
                    return ""
                }
            }
        }
        var functions: [Function]
        
        init(name: String, attributes: [Attribute], functions: [Function]) {
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
    var classes: [Class] = []
    
}

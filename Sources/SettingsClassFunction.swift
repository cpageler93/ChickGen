//
//  SettingsClassFunction.swift
//  ChickGen
//
//  Created by Christoph Pageler on 25.07.17.
//

import Foundation

public extension Settings.Class {
    
    public class Function {
        
        public var name: String
        public var parameters: [Settings.Class.FunctionParameter]?
        public var returnType: String?
        public var bodyLines: [String]
        public var accessControl: String = "public"
        
        public init(name: String,
                    parameters: [Settings.Class.FunctionParameter]? = nil,
                    bodyLines: [String]) {
            self.name = name
            self.parameters = parameters
            self.bodyLines = bodyLines
        }
        
        public func formattedParameters() -> String {
            guard let parameters = parameters, parameters.count > 0 else { return "" }
            
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
    
}

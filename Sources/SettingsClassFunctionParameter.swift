//
//  SettingsClassFunctionParameter.swift
//  ChickGen
//
//  Created by Christoph Pageler on 25.07.17.
//

import Foundation

public extension Settings.Class {
    
    public class FunctionParameter {
        
        public var label: String?
        public var name: String
        public var type: String
        public var optional: Bool = false
        
        public init(name: String, type: String) {
            self.name = name
            self.type = type
        }
        
    }
    
}

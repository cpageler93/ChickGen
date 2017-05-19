//
//  JSONSettingsParser.swift
//  ChickGen
//
//  Created by Christoph on 19.05.17.
//
//

import Foundation
import SwiftyJSON

extension JSONSettingsParser: SettingsParser {
    func settingsFromFileWithContent(_ fileContent: String) throws -> Settings {
        guard let stringData = fileContent.data(using: .utf8) else {
            throw ChickGenError.parsingError
        }
        
        let json = JSON(data: stringData)
        guard !json.isEmpty else {
            throw ChickGenError.parsingError
        }
        
        let settings = Settings()
        settings.general = generalSettingsFromJSON(json["general"])
        settings.classes = try classSettingsArrayFromJSON(json["classes"])
        
        return settings
    }
}

class JSONSettingsParser {
    
    fileprivate func generalSettingsFromJSON(_ json: JSON) -> Settings.General? {
        guard !json.isEmpty else {
            return nil
        }
        
        // parse general
        let general = Settings.General()
        general.author = json["author"].string
        general.projectName = json["projectName"].string
        
        return general
    }
    
    fileprivate func classSettingsArrayFromJSON(_ json: JSON) throws -> [Settings.Class] {
        guard !json.isEmpty else {
            return []
        }
        guard let jsonArray = json.array else {
            throw ChickGenError.parsingError
        }
        
        // parse classes
        var classes: [Settings.Class] = []
        for jsonClass in jsonArray {
            let settingsClass = try classSettingsFromJSON(jsonClass)
            classes.append(settingsClass)
        }
        return classes
    }
    
    private func classSettingsFromJSON(_ json: JSON) throws -> Settings.Class {
        // parse required fields
        guard
            let name = json["name"].string
            else {
                throw ChickGenError.parsingError
        }
        
        // attributes
        let classAttributes = try classAttributeArrayFromJSON(json["attributes"].array)
        let classFunctions = try classFunctionArrayFromJSON(json["functions"].array)
        let settingsClass = Settings.Class(name: name,
                                           attributes: classAttributes,
                                           functions: classFunctions)
        
        // optional fields
        if let superclass = json["superclass"].string {
            settingsClass.superclass = superclass
        }
        
        if let jsonImports = json["imports"].array {
            var imports: [String] = []
            for jsonImport in jsonImports {
                if let importString = jsonImport.string {
                    imports.append(importString)
                }
            }
            settingsClass.imports = imports
        }
        
        return settingsClass
    }
    
    private func classAttributeArrayFromJSON(_ json: [JSON]?) throws -> [Settings.Class.Attribute] {
        var classAttributes: [Settings.Class.Attribute] = []
        guard let json = json else {
            return classAttributes
        }
        for jsonAttribute in json {
            let classAttribute = try classAttributeFromJSON(jsonAttribute)
            classAttributes.append(classAttribute)
        }
        
        return classAttributes
    }
    
    private func classAttributeFromJSON(_ json: JSON) throws -> Settings.Class.Attribute {
        guard
            let name = json["name"].string,
            let type = json["type"].string
            else {
                throw ChickGenError.parsingError
        }
        
        let classAttribute = Settings.Class.Attribute(name: name, type: type)
        
        if let refString = json["ref"].string,
            let refType = Settings.ClassRef(rawValue: refString) {
            classAttribute.ref = refType
        }
        
        if let optional = json["optional"].bool {
            classAttribute.optional = optional
        }
        
        return classAttribute
    }
    
    private func classFunctionArrayFromJSON(_ json: [JSON]?) throws -> [Settings.Class.Function] {
        var classFunctions: [Settings.Class.Function] = []
        guard let json = json else {
            return classFunctions
        }
        for jsonFunction in json {
            let classFunction = try classFunctionFromJSON(jsonFunction)
            classFunctions.append(classFunction)
        }
        
        return classFunctions
    }
    
    private func classFunctionFromJSON(_ json: JSON) throws -> Settings.Class.Function {
        guard
            let name = json["name"].string,
            let jsonBodyLines = json["bodyLines"].array
            else {
                throw ChickGenError.parsingError
        }
        
        // parse body lines
        var bodyLines: [String] = []
        for jsonBodyLine in jsonBodyLines {
            if let bodyLine = jsonBodyLine.string{
                bodyLines.append(bodyLine)
            }
        }
        
        let classFunction = Settings.Class.Function(name: name, bodyLines: bodyLines)
        
        if let jsonParameters = json["parameters"].array {
            var parameters: [Settings.Class.Function.Parameter] = []
            for jsonParameter in jsonParameters {
                let parameter = try classFunctionParameterFromJSON(jsonParameter)
                parameters.append(parameter)
            }
            classFunction.parameters = parameters
        }

        if let returnType = json["returnType"].string {
            classFunction.returnType = returnType
        }
        
        return classFunction
    }
    
    private func classFunctionParameterFromJSON(_ json: JSON) throws -> Settings.Class.Function.Parameter {
        guard
            let name = json["name"].string,
            let type = json["type"].string
        else {
                throw ChickGenError.parsingError
        }
        
        let parameter = Settings.Class.Function.Parameter(name: name, type: type)
        
        if let label = json["label"].string {
            parameter.label = label
        }
        
        if let optional = json["optional"].bool {
            parameter.optional = optional
        }
        
        return parameter
    }
    
}

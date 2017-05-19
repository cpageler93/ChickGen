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
        let settingsClass = Settings.Class(name: name, attributes: classAttributes)
        
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
            guard
                let name = jsonAttribute["name"].string,
                let type = jsonAttribute["type"].string
                else {
                    throw ChickGenError.parsingError
            }
            
            let classAttribute = Settings.Class.Attribute(name: name, type: type)
            
            if let refString = jsonAttribute["ref"].string,
                let refType = Settings.ClassRef(rawValue: refString) {
                classAttribute.ref = refType
            }
            
            if let optional = jsonAttribute["optional"].bool {
                classAttribute.optional = optional
            }
            
            classAttributes.append(classAttribute)
        }
        
        return classAttributes
    }
    
}

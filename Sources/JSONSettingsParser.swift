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
        
        return settings
    }
}

class JSONSettingsParser {
    
    func generalSettingsFromJSON(_ json: JSON) -> Settings.General? {
        guard !json.isEmpty else {
            return nil
        }
        
        // parse general
        let general = Settings.General()
        general.author = json["author"].string
        return general
    }
    
}

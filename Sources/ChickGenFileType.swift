//
//  ChickGenFileType.swift
//  ChickGen
//
//  Created by Christoph Pageler on 25.07.17.
//

public enum ChickGenFileType: String {
    case json
    
    public func settingsParser() -> SettingsParser {
        switch self {
        case .json: return JSONSettingsParser()
        }
    }

}


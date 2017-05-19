//
//  SettingsParser.swift
//  ChickGen
//
//  Created by Christoph on 19.05.17.
//
//

import Foundation

public protocol SettingsParser {
    
    func settingsFromFileWithContent(_ fileContent: String) throws -> Settings
    
}

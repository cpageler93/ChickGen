//
//  ChickGen.swift
//  ChickGen
//
//  Created by Christoph on 19.05.17.
//
//

import Foundation
import PathKit

public enum ChickGenError: Error {
    case missingFileExtension
    case unknownFileExtension
    case parsingError
}

public enum ChickGenFileType: String {
    case json
}

open class ChickGenGenerator {
    
    public private(set) var settings: Settings!
    
    public init(withContent content: String, fileType: ChickGenFileType) throws {
        let parser = settingsParserFor(fileType: fileType)
        self.settings = try parser.settingsFromFileWithContent(content)
    }
    
    public convenience init(withContentOfFile filepath: Path) throws {
        let content = try String(contentsOfFile: filepath.string, encoding: String.Encoding.utf8)
        guard let ext = filepath.extension else {
            throw ChickGenError.missingFileExtension
        }
        
        guard let fileType = ChickGenFileType(rawValue: ext) else {
            throw ChickGenError.unknownFileExtension
        }
        
        try self.init(withContent: content, fileType: fileType)
    }
    
    public func generate() throws {
        
    }
    
}

// MARK: Settings Parsing

extension ChickGenGenerator {
    
    public func settingsParserFor(fileType: ChickGenFileType) -> SettingsParser {
        switch fileType {
        case .json: return JSONSettingsParser()
        }
    }
    
}

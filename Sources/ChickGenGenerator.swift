//
//  ChickGen.swift
//  ChickGen
//
//  Created by Christoph on 19.05.17.
//
//

import Foundation
import PathKit
import Stencil

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
    
    public init(settings: Settings) {
        self.settings = settings
    }
    
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
}

// MARK: Settings Parsing

extension ChickGenGenerator {
    
    public func settingsParserFor(fileType: ChickGenFileType) -> SettingsParser {
        switch fileType {
        case .json: return JSONSettingsParser()
        }
    }
    
}

// MARK: Generation

extension ChickGenGenerator {
    public func generate(_ generateSettings: GenerateSettings) throws {
        
        // get template
        let templateString = ClassTemplate.getTemplate()
        let template = Template(templateString: templateString)
        
        // prepare output
        struct OutputFile {
            let fileName: String
            let fileContent: String
            
            init(fileName: String, fileContent: String) {
                self.fileName = fileName
                self.fileContent = fileContent
            }
        }
        var outputFiles: [OutputFile] = []
        
        // enumerate classes
        for settingClass in self.settings.classes {
            
            let classFileName = settingClass.filename()
            
            // create context
            let context: [String : Any] = [
                "projectName": "Hello this is Test",
                "fileName": classFileName,
                "date": DateFormatter.localizedString(from: Date(), dateStyle: .medium, timeStyle: .medium),
                "author": self.settings.general?.author ?? "🐣",
                "imports": settingClass.imports ?? [],
                "class": [
                    "name": settingClass.swiftClass(),
                    "attributes": settingClass.attributes.map {
                        return [
                            "ref": $0.ref,
                            "name": $0.name,
                            "type": $0.swiftType()
                        ]
                    }
                ]
            ]
            
            // render template with context
            var renderedClassString = try template.render(context)
        
            // trim whitespace (only at end of line) on each line
            var comp = renderedClassString.components(separatedBy: "\n")
            comp = comp.map { $0.replacingOccurrences(of: "\\s+$", with: "", options: .regularExpression) }
            renderedClassString = comp.joined(separator: "\n")
            
            let outputFile = OutputFile(fileName: classFileName, fileContent: renderedClassString)
            outputFiles.append(outputFile)
        }
        
        // when rendering succeded, save files
        for outputFile in outputFiles {
            let filepath = generateSettings.outputDirectory + Path(outputFile.fileName)
            
            // TODO: only when set to clean
            if filepath.exists {
                try FileManager.default.removeItem(atPath: filepath.string)
            }
            
            try outputFile.fileContent.write(to: filepath.url, atomically: true, encoding: .utf8)
        }
    }
}

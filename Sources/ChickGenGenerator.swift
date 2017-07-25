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


open class ChickGenGenerator {
    
    public private(set) var settings: Settings
    
    public init(settings: Settings) {
        self.settings = settings
    }
    
    public init(withContent content: String, fileType: ChickGenFileType) throws {
        let parser = fileType.settingsParser()
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

// MARK: Generation

extension ChickGenGenerator {
    
    struct OutputFile {
        let fileName: String
        let fileContent: String
        
        init(fileName: String, fileContent: String) {
            self.fileName = fileName
            self.fileContent = fileContent
        }
    }
    
    public func generate(_ generateSettings: GenerateSettings) throws {
        
        var outputFiles: [OutputFile] = []
        outputFiles.append(contentsOf: try generateClasses(settings.classes))
        outputFiles.append(contentsOf: try generateEnums(settings.enums))
        
        // replace ~ with absolute home directory
        let outputDirectory = Path(generateSettings.outputDirectory.string.replacingOccurrences(of: "~", with: NSHomeDirectory()))
        
        // when rendering succeded, save files
        for outputFile in outputFiles {
            
            let filepath = outputDirectory + Path(outputFile.fileName)
            
            // TODO: only when set to clean
            if filepath.exists {
                try FileManager.default.removeItem(atPath: filepath.string)
            }
            
            try outputFile.fileContent.write(to: filepath.url, atomically: true, encoding: .utf8)
        }
    }
    
    private func generateClasses(_ classes: [Settings.Class]) throws -> [OutputFile] {
        var outputFiles: [OutputFile] = []
        
        // get class template
        let templateString = ClassTemplate.getTemplate()
        let template = Template(templateString: templateString)
        
        for settingClass in classes {
            
            let classFileName = settingClass.filename()
            
            // create context
            let context: [String : Any] = [
                "projectName": settings.general.projectName ?? "<projectName>",
                "fileName": classFileName,
                "date": DateFormatter.localizedString(from: Date(), dateStyle: .medium, timeStyle: .medium),
                "author": settings.general.author ?? "<author>",
                "imports": settingClass.imports ?? [],
                "class": [
                    "name": settingClass.swiftClass(),
                    "attributes": (settingClass.attributes ?? []).map { attr in
                        return [
                            "ref": attr.ref.rawValue,
                            "name": attr.name,
                            "type": attr.swiftType()
                        ]
                    },
                    "functions": (settingClass.functions ?? []).map { function in
                        return [
                            "name": function.name,
                            "formattedParameters": function.formattedParameters(),
                            "formattedReturn": function.formattedReturn(),
                            "bodyLines": function.bodyLines
                        ]
                    }
                    ] as [String: Any]
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
        
        return outputFiles
    }
    
    private func generateEnums(_ enums: [Settings.Enum]) throws -> [OutputFile] {
        var outputFiles: [OutputFile] = []
        
        // get enum template
        let templateString = EnumTemplate.getTemplate()
        let template = Template(templateString: templateString)
        
        for settingsEnum in enums {
            
            let enumFileName = settingsEnum.filename()
            
            // create context
            let context: [String : Any] = [
                "projectName": settings.general.projectName ?? "<projectName>",
                "fileName": enumFileName,
                "date": DateFormatter.localizedString(from: Date(), dateStyle: .medium, timeStyle: .medium),
                "author": settings.general.author ?? "<author>",
                "enum": [
                    "name": settingsEnum.name,
                    "cases": settingsEnum.cases
                    ] as [String: Any]
            ]
            
            // render template with context
            var renderedClassString = try template.render(context)
            
            // trim whitespace (only at end of line) on each line
            var comp = renderedClassString.components(separatedBy: "\n")
            comp = comp.map { $0.replacingOccurrences(of: "\\s+$", with: "", options: .regularExpression) }
            renderedClassString = comp.joined(separator: "\n")
            
            let outputFile = OutputFile(fileName: enumFileName, fileContent: renderedClassString)
            outputFiles.append(outputFile)
        }
        
        return outputFiles
    }
    
}

import Foundation
import Commander
import PathKit

Group {
    $0.command("generate") { (argFilepath: String, argOutputDirectory: String) in
        var filepath = Path(argFilepath.replacingOccurrences(of: "~", with: NSHomeDirectory()))
        if filepath.isRelative {
            filepath = Path(FileManager.default.currentDirectoryPath) + filepath
        }
        guard filepath.exists else {
            print("no file at \(filepath)")
            exit(1)
        }
        
        var outputDirectory = Path(argOutputDirectory.replacingOccurrences(of: "~", with: NSHomeDirectory()))
        if outputDirectory.isRelative {
            outputDirectory = Path(FileManager.default.currentDirectoryPath) + outputDirectory
        }
        guard outputDirectory.exists else {
            print("output directory does not exist at \(outputDirectory)")
            exit(1)
        }
        
        do {
            
            // init generator
            let chickgen = try ChickGenGenerator(withContentOfFile: filepath)
            
            // init settings
            let settings = GenerateSettings(outputDirectory: outputDirectory)
            
            // generate
            try chickgen.generate(settings)
            
        } catch {
            print("error on generate")
        }
    }
}.run()

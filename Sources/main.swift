import Foundation
import Commander
import PathKit

Group {
    $0.command("generate") { (argFilepath: String) in
        var filepath = Path(argFilepath.replacingOccurrences(of: "~", with: NSHomeDirectory()))
        
        if filepath.isRelative {
            filepath = Path(FileManager.default.currentDirectoryPath) + filepath
        }
        
        guard filepath.exists else {
            print("no file at \(filepath)")
            exit(1)
        }
        
        do {
            let chickgen = try ChickGenGenerator(withContentOfFile: filepath)
            try chickgen.generate()
        } catch {
            print("error on generate")
        }
    }
}.run()

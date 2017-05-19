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
        
        guard let chickgen = ChickGen(withContentOfFile: filepath) else {
            print("could not initialize")
            exit(1)
        }
        
        do {
            try chickgen.generate()
        } catch {
            print("error on generate")
        }
    }
}.run()

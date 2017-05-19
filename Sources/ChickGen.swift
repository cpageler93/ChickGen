//
//  ChickGen.swift
//  ChickGen
//
//  Created by Christoph on 19.05.17.
//
//

import Foundation
import PathKit
import JavaScriptCore

enum ChickGenError: Error {
    case missingMainFunction
}

open class ChickGen {
    
    private let jsContext: JSContext
    
    init(withContent content: String) {
        // init context
        self.jsContext = JSContext()
        
        // add exception handler
        self.jsContext.exceptionHandler = { context, exception in
            if let exc = exception {
                print("JS Exception:", exc.toString())
            }
        }
        
        // added console log
        self.jsContext.evaluateScript("var console = { log: function(message) { _consoleLog(message) } }")
        let consoleLog: @convention(block) (String) -> Void = { message in
            print(message)
        }
        self.jsContext.setObject(unsafeBitCast(consoleLog, to: AnyObject.self), forKeyedSubscript: "_consoleLog" as (NSCopying & NSObjectProtocol)!)
        
        self.jsContext.evaluateScript(content)
    }
    
    convenience init?(withContentOfFile filepath: Path) {
        do {
            // get content of file
            let content = try String(contentsOfFile: filepath.string, encoding: String.Encoding.utf8)
            
            self.init(withContent: content)
        } catch {
            return nil
        }
    }
    
    public func generate() throws {
        guard let mainFunction = self.jsContext.objectForKeyedSubscript("main") else {
            throw ChickGenError.missingMainFunction
        }
        let value = mainFunction.call(withArguments: nil)
        
        let classes = value?.forProperty("classes")
        let clas = classes?.objectAtIndexedSubscript(0)
        let name = clas?.forProperty("name")
        
        print("value: \(String(describing: name))")
    }
    
}

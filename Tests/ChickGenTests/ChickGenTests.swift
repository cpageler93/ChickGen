//
//  ChickGenTests.swift
//  ChickGenTests
//
//  Created by Christoph Pageler on 25.06.17.
//

import XCTest
import ChickGen

class ChickGenTests: XCTestCase {
    
    func testFoo() {
        let settings = Settings()
        settings.general.author = "Christoph Pageler"
        settings.general.projectName = "ChickGen Tests"
        
        let attributes = [
            Settings.Class.Attribute(ref: .let, name: "foo", type: "String", optional: true),
            Settings.Class.Attribute(ref: .let, name: "bar", type: "Int", optional: false)
        ]
        
        let functions = [
            Settings.Class.Function(name: "makeSandwich", parameters: [
                Settings.Class.FunctionParameter(name: "size", type: "SandwichSize")
            ], bodyLines: [
                "print(foo)",
                "exit(1)"
            ])
        ]
        
        let class1 = Settings.Class(name: "Foo",
                                    attributes: attributes,
                                    functions: functions)
        class1.imports = [
            "Foundation",
            "FooBar",
            "UIKit"
        ]
        settings.classes.append(class1)
        
        let enum1 = Settings.Enum(name: "SandwichSize", cases: ["small", "medium", "large"])
        settings.enums.append(enum1)
        
        let generator = ChickGenGenerator(settings: settings)
        
        let generateSettings = GenerateSettings(outputDirectory: "~/Desktop/tests/")
        do {
            try generator.generate(generateSettings)
        } catch {
            XCTFail("failed \(error)")
        }
    }
    
}

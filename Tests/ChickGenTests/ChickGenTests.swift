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
        
        let attrWithDefault = Settings.Class.Attribute(name: "baz", type: "String")
        attrWithDefault.defaultValue = "\"Fooo\""
        
        let attributes = [
            Settings.Class.Attribute(ref: .let, name: "foo", type: "String", optional: true),
            Settings.Class.Attribute(ref: .let, name: "bar", type: "Int", optional: false),
            attrWithDefault
        ]
        
        let functions = [
            Settings.Class.Function(name: "makeSandwich", parameters: [
                Settings.Class.FunctionParameter(name: "size", type: "SandwichSize")
            ], bodyLines: [
                "print(foo)",
                "exit(1)"
            ]),
            Settings.Class.Function(name: "init", parameters: [
                Settings.Class.FunctionParameter(name: "foo", type: "String")
            ], bodyLines: [
                "self.foo = foo"
            ]),
            Settings.Class.Function(name: "init?", parameters: [
                Settings.Class.FunctionParameter(name: "foo", type: "String")
            ], bodyLines: [
                "self.foo = foo"
            ])
        ]
        
        let ext1 = Settings.Extension(name: "Foo")
        ext1.filename = "FooExtensions"
        ext1.accessControl = "internal"
        ext1.imports = [
            "Something"
        ]
//        ext1.inheritance = "Bar"
        let ext1Func = Settings.Class.Function(name: "some", bodyLines: [
            "print(\"foo bar\")"
        ])
        ext1Func.throws = true
        ext1.functions = [
            ext1Func
        ]
        settings.extensions = [ext1]
        
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

//
//  GenerateSettings.swift
//  ChickGen
//
//  Created by Christoph Pageler on 19.05.17.
//
//

import Foundation
import PathKit

public struct GenerateSettings {
    let outputDirectory: Path
    
    init(outputDirectory: Path) {
        self.outputDirectory = outputDirectory
    }
}

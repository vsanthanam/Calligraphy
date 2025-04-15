//
//  Copyright © Uber Technologies, Inc. All rights reserved.
//

import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct CalligraphyCompilerPlugin: CompilerPlugin {
    
    let providingMacros: [Macro.Type] = [
        FilePermissionsMacro.self
    ]
    
}

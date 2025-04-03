//
//  Copyright © Uber Technologies, Inc. All rights reserved.
//

import Foundation

public struct BinaryFile: DataFile {
    
    // MARK: - Initializers
    
    public init(
        _ name: String,
        data: Data
    ) {
        self.name = name
        self.data = data
    }
    
    public init(
        _ name: String,
        extension: String,
        data: Data
    ) {
        let name = name + "." + `extension`
        self.init(name, data: data)
    }
    
    // MARK: - DataFile
    
    public let name: String
    
    public let data: Data
    
}

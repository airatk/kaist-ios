//
//  Collection.swift
//  Kaist
//
//  Created by Airat K on 9/4/2023.
//  Copyright © 2023 Airat K. All rights reserved.
//

import Foundation


extension Collection where Indices.Iterator.Element == Index {

    subscript(safeIndex index: Index) -> Iterator.Element? {
        return (startIndex <= index && index < endIndex) ? self[index] : nil
    }

}

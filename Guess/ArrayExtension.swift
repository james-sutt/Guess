//
//  ArrayExtension.swift
//  Guess
//
//  Created by Javy on 2017-05-20.
//  Copyright © 2017 supajavy. All rights reserved.
//

import Foundation

public func random(_ n: Int) -> Int {
    return Int(arc4random_uniform(UInt32(n)))
}

extension Array {
    public mutating func shuffle() {
        for i in stride(from: count - 1, through: 1, by: -1) {
            let j = random(i + 1)
            if i != j {
                swap(&self[i], &self[j])
            }
        }
    }
}

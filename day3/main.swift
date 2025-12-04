//
//  main.swift
//  day3
//
//  Created by Johannes Loepelmann on 04.12.25.
//

import Foundation


var bankMemories: [Bank: Dictionary<[Int], [Int]?>] = [:]

struct Bank : Hashable {
    let batteries: [Int]
    
    @MainActor
    init(input: String.SubSequence) {
        self.batteries = input.map{Int(String($0))!}
        bankMemories[self] = [:]
    }
    
    @MainActor func largestCombo(numberOfDigits: Int, startingAt index: Int) -> [Int]? {
        if let result = bankMemories[self]![[numberOfDigits, index]] {
            return result
        }
        
        if index + numberOfDigits > batteries.count {
            return nil
        }
        
        if numberOfDigits == 0 {
            return []
        }
        
        var result: [Int] = Array(repeating: 0, count: numberOfDigits)
        
        var currentMaxValue: Int = 0
        
        for i in index..<batteries.count {
            var localResult : [Int] = Array(repeating: 0, count: numberOfDigits)
            localResult[0] = i
            
            if let remainder = largestCombo(numberOfDigits: numberOfDigits - 1, startingAt: i + 1) {
                localResult.replaceSubrange(1..<numberOfDigits, with:remainder)
                let localValue = localResult.map{batteries[$0]}.numberAsDigitSequence()
                if (localValue > currentMaxValue) {
                    currentMaxValue = localValue
                    result = localResult
                }
            }
        }
        
        bankMemories[self]![[numberOfDigits, index]] = result
        return result
    }
    
    func hash(into hasher: inout Hasher) {
        batteries.forEach{$0.hash(into:&hasher)}
    }
    
    @MainActor func convertIndices(indices: [Int]) -> Int {
        return indices.map{batteries[$0]}.numberAsDigitSequence()
    }
    
    
}

var memoNumberAsDigitSequence: [[Int]:Int] = [:]

extension Array where Element == Int {
    
    @MainActor func numberAsDigitSequence() -> Int {
        if(!memoNumberAsDigitSequence.keys.contains(self)) {
            memoNumberAsDigitSequence[self] = Int(self.map(String.init).joined())!
        }
                
        return memoNumberAsDigitSequence[self]!
    }
}

guard let lines = linesFromFile("day3.input") else {
    fatalError("No file found")
}

var banks = lines.map(Bank.init)
let largestCombos = banks.map{$0.convertIndices(indices:$0.largestCombo(numberOfDigits: 12, startingAt: 0)!)}

print("Result: \(largestCombos.reduce(0, +))")

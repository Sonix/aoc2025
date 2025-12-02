//
//  main.swift
//  day2
//
//  Created by Johannes Loepelmann on 02.12.25.
//

import Foundation

struct Range {
    let start: Int
    let end: Int
    
    init(from: String.SubSequence) {
        let elements = from.split(separator: "-")
        guard let start = Int(elements[0]) else { fatalError("Could not parse start") }
        guard let end = Int(elements[1]) else { fatalError("Could not parse end") }
        self.start = start
        self.end = end
    }
    
    func sillyNumbers() -> [Int] {
        var result: [Int] = []
        var start: Int = self.start
        
        if String(start).count % 2 != 0 {
            if(String(end).count == start) {
                return result
            }
            
            start = nextPowerOf10(start)
        }
        
        while String(start).count <= String(end).count {
            let startString = String(start)
            let digits = startString.count
            if (digits % 2 != 0) {
                start = nextPowerOf10(start)
                continue
            }
            
            let halfStartIndex = startString.index(startString.startIndex, offsetBy: digits/2)
            let halfStartString = startString[..<halfStartIndex]
            let endString : String
            if String(end).count == digits {
                endString = String(end)
            } else {
                endString = String(repeating: "9", count: digits)
            }
            
            let halfEndIndex = endString.index(endString.startIndex, offsetBy: digits/2)
            let halfEndString = endString[..<halfEndIndex]
            
            var halfStart = Int(halfStartString)!
            let halfEnd = Int(halfEndString)!
            
            if(Int("\(halfStart)\(halfStart)")! < start) {
                halfStart += 1
            }
            
            while(halfStart < halfEnd) {
                result.append(Int("\(halfStart)\(halfStart)")!)
                halfStart += 1
            }
            
            if(halfStart == halfEnd) {
                if(Int("\(halfStart)\(halfStart)")! <= end) {
                    result.append(Int("\(halfStart)\(halfStart)")!)
                }
            }
            
            start = nextPowerOf10(start)
        }
        
        
        return result
    }
    
    func sillyNumbersV2() -> Set<Int> {
        var result = Set<Int>()
        var start: Int = self.start
        
        if (start < 10) {
            start = nextPowerOf10(start)
        }
        
        while String(start).count <= String(end).count {
            let startString = String(start)
            let digits = startString.count
            
            let halfStartIndex = startString.index(startString.startIndex, offsetBy: digits/2)
            var halfStartString = String(startString[..<halfStartIndex])
            let endString : String
            if String(end).count == digits {
                endString = String(end)
            } else {
                endString = String(repeating: "9", count: digits)
            }
            
            let halfEndIndex = endString.index(endString.startIndex, offsetBy: digits/2)
            let halfEndString = endString[..<halfEndIndex]
            
            var halfStart = Int(halfStartString)!
            let halfEnd = Int(halfEndString)!
            
            while(halfStart <= halfEnd) {
                for i in 1...digits/2 {
                    if digits % i == 0 {
                        let fraction = halfStartString[..<halfStartString.index(halfStartString.startIndex, offsetBy: i)]
                        let candidate = Int(String(repeating: "\(fraction)", count: digits/i))!
                        if(candidate >= start && candidate <= end) {
                            result.insert(candidate)
                        }
                    }
                }
                
                halfStart += 1
                halfStartString = String(repeating:"\(halfStart)", count: digits/Int(digits/2))
            }
            
            start = nextPowerOf10(start)
        }
        
        
        return result
    }
}

guard let ranges = linesFromFile("day2.input")?.first?.split(separator: ",").map(Range.init) else {
    fatalError("No ranges found")
}

for r in ranges {
    print("Range: \(r): \(r.sillyNumbers())")
}

print("Result 1 \(ranges.flatMap{$0.sillyNumbers()}.reduce(0, +))")

for r in ranges {
    print("Range: \(r): \(r.sillyNumbersV2())")
}

print("Result 2 \(ranges.flatMap{$0.sillyNumbersV2()}.reduce(0, +))")


func nextPowerOf10(_ n: Int) -> Int {
    guard n > 0 else { return 1 }
    var result: Int = 1
    while result <= n {
        result *= 10
    }
    
    return result
}

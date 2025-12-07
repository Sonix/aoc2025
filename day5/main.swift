//
//  main.swift
//  day5
//
//  Created by Johannes Loepelmann on 07.12.25.
//

import Foundation

guard let lines = linesFromFile("day5.input") else {
    fatalError("Could not read file")
}

let lastRangeIndex = lines.lastIndex(where: {$0.contains("-")})!

var ranges = lines[...lastRangeIndex].map{
    let splitIndex = $0.firstIndex(of: "-")!
    let start = Int($0[..<splitIndex])!
    let end = Int($0[$0.index(after:splitIndex)...])!
    return start...end
}

let ids = lines[lines.index(after:lastRangeIndex)...].map{Int($0)!}

print(lines)

let containedIds = ids.filter{id in ranges.contains(where: {r in r.contains(id)})}.count

print("Part 1: \(containedIds)")
var toMerge: ClosedRange<Int>? = nil

repeat {
    toMerge = nil
    for range in ranges {
        if (ranges.contains(where: {r in r.overlaps(range) && r != range})) {
            toMerge = range
            break
        }
    }
    
    if let toMerge = toMerge {
        guard let mergeInto = ranges.first(where: {r in r.overlaps(toMerge) && r != toMerge}) else {
            fatalError("Could not find range to merge into")
        }
        let mergedRange = [min(toMerge.lowerBound, mergeInto.lowerBound)...max(toMerge.upperBound, mergeInto.upperBound)]
        ranges.remove(at: ranges.firstIndex(of: mergeInto)!)
        ranges.remove(at: ranges.firstIndex(of: toMerge)!)
        ranges.append(contentsOf: mergedRange)
    }
} while(toMerge != nil)

ranges = Array(Set(ranges))

for range in ranges {
    print("\(range): \(range.upperBound - range.lowerBound + 1)")
}
let totalCount = ranges.map{range in range.upperBound - range.lowerBound + 1}.reduce(0, +)

print("Part 2: \(totalCount)")

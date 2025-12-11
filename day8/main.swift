//
//  main.swift
//  day8
//
//  Created by Johannes Loepelmann on 11.12.25.
//

import Foundation

struct Point3D : Hashable {
    let x: Int
    let y: Int
    let z: Int
    
    init(_ from: String.SubSequence) {
        let parts = from.split(separator: ",")
        self.x = Int(parts[0])!
        self.y = Int(parts[1])!
        self.z = Int(parts[2])!
    }
    
    func distanceSq(to other: Point3D) -> Int {
        (x - other.x) * (x - other.x) + (y - other.y) * (y - other.y) + (z - other.z) * (z - other.z)
    }
}

guard let lines = linesFromFile("day8.input") else {
    fatalError("No input file")
}
let points = lines.map(Point3D.init)

print(points)

var distances = [Int: [(Point3D, Point3D)]]()

for i in 0..<points.count {
    for j in i+1..<points.count {
        let p1 = points[i]
        let p2 = points[j]
        
        let dist = p1.distanceSq(to: p2)
        
        if distances[dist] == nil {
            distances[dist] = [(p1, p2)]
        } else {
            distances[dist]!.append((p1, p2))
        }
    }
}


var sets = Set<Set<Point3D>>()
var pointToSet: [Point3D: Set<Point3D>] = [:]

for point in points {
    let initialSet = Set([point])
    pointToSet[point] = initialSet
    sets.insert(initialSet)
}


let sortedCombinations = distances.keys.sorted().flatMap { distances[$0]! }

let iterations = sortedCombinations.count

guard sortedCombinations.count >= iterations else {
    fatalError("Not enough combinations to do the iterations")
}

var part2 : Int = 0

for i in 0..<iterations {
    let (p1, p2) = sortedCombinations[i]
    if let existingSet = pointToSet[p1], let otherSet = pointToSet[p2] {
        if existingSet != otherSet {
            let combinedSet = existingSet.union(otherSet)
            for point in combinedSet {
                pointToSet[point] = combinedSet
            }
            sets.remove(existingSet)
            sets.remove(otherSet)
            sets.insert(combinedSet)
            
            if(sets.count == 1) {
                part2 = p1.x * p2.x
            }
        }
    }
}

let part1 = 0 // sets.sorted { $0.count > $1.count }[...2].map(\.count).reduce(1, *)

print("Part 1: \(part1)")
print("Part 2: \(part2)")

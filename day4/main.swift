//
//  main.swift
//  day4
//
//  Created by Johannes Loepelmann on 05.12.25.
//

import Foundation

enum Position {
    case EMPTY
    case PAPER
    
    init (_ rawValue: Character) {
        switch rawValue {
        case ".":
            self = .EMPTY
        case "@":
            self = .PAPER
        default:
            fatalError("Unknown position: \(rawValue)")
        }
    }
    
    func char() -> Character {
        switch self {
        case .EMPTY:
            return "."
        case .PAPER:
            return "@"
        }
    }
}

struct Point : Hashable {
    var x: Int
    var y: Int
    
    init(_ x: Int,_ y: Int) {
        self.x = x
        self.y = y
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(x)
        hasher.combine(y)
    }
}

struct Map {
    var positions: [[Position]]
    
    init(lines: [String.SubSequence]) {
        positions = lines.map{$0.map(Position.init)}
    }
    
    func at(_ point: Point) -> Position {
        guard point.x >= 0, point.x < positions[0].count, point.y >= 0, point.y < positions.count else {
            return .EMPTY
        }
        
        return positions[point.y][point.x]
    }
    
    func countSurroundingPapers(at point: Point) -> Int {
        var count: Int = 0
        let x = point.x
        let y = point.y
        
        for dy in -1...1 {
            for dx in -1...1 {
                if dx == 0 && dy == 0 {
                    continue
                }
                
                if at(Point(x + dx, y + dy)) == .PAPER {
                    count += 1
                }
            }
        }
        
        return count
    }
    
    func paperPositions() -> [Point] {
        var result = [Point]()
        for y in 0..<positions.count {
            for x in 0..<positions[y].count {
                if positions[y][x] == .PAPER {
                    result.append(Point(x, y))
                }
            }
        }
        
        return result
    }
    
    mutating func removeAccessiblePapers() -> Int {
        var removed = 0
        var newPositions = self.positions
        
        for point in self.paperPositions() {
            if self.countSurroundingPapers(at: point) < 4 {
                newPositions[point.y][point.x] = .EMPTY
                removed += 1
            }
        }
        
        self.positions = newPositions
        return removed
    }
    
    func printMap() {
        for line in positions {
            print(String(line.map{$0.char()}))
        }
    }
}

guard let lines = linesFromFile("day4.input") else {
    fatalError("Could not read file")
}

var map = Map(lines: lines)
let papers = Array(map.paperPositions())
let accessible = papers.count(where: { map.countSurroundingPapers(at: $0) < 4})
print("Part 1: \(accessible)")

var count = 0
var lastRemoved = 0

repeat {
    lastRemoved = map.removeAccessiblePapers()
    count += lastRemoved
} while (lastRemoved > 0)


map.printMap()
print("Part 2: \(count)")

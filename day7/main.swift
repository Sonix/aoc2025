//
//  main.swift
//  day7
//
//  Created by Johannes Loepelmann on 10.12.25.
//

import Foundation

struct Position : Hashable {
    let x: Int
    let y: Int
}

enum Tile: Hashable {
    case empty
    case splitter
    case start
    
    init (_ rawValue: Character) {
        switch rawValue {
        case ".": self = .empty
        case "^": self = .splitter
        case "S": self = .start
        default: fatalError("Unknown tile: \(rawValue)")
        }
    }
    
    var description: String {
        switch self {
        case .empty: return "."
        case .splitter: return "^"
        case .start: return "S"
        }
    }
}

struct Map : CustomStringConvertible {
    let tiles: [[Tile]]
    
    var optionsMemory: [Position:Int] = [:]
    
    init (_ lines: [String.SubSequence]) {
        self.tiles = lines.map{line in line.map(Tile.init)}
    }
    
    func tile(at position: Position) -> Tile? {
        guard position.y >= 0, position.y < tiles.count,
              position.x >= 0, position.x < tiles[position.y].count else {
            return nil
        }
        return tiles[position.y][position.x]
    }
    
    var description: String {
        return tiles.map{line in line.map(\.description).joined()}.joined(separator: "\n")
    }
    
    func startPosition() -> Position? {
        for y in 0..<tiles.count {
            for x in 0..<tiles[y].count {
                if tiles[y][x] == .start {
                    return Position(x: x, y: y)
                }
            }
        }
        return nil
    }
    
    mutating func options(from position: Position) -> Int {
        if let result = optionsMemory[position] {
            return result
        }
        
        let tile = self.tile(at: position)
        switch tile {
        case nil:
            optionsMemory[position] = 1
        case .empty, .start:
            let nextPosition = Position(x: position.x, y: position.y + 1)
            optionsMemory[position] = self.options(from: nextPosition)
        case .splitter:
            let candidateLeft = Position(x: position.x - 1, y: position.y + 1)
            let candidateRight = Position(x: position.x + 1, y: position.y + 1)
            optionsMemory[position] = self.options(from: candidateLeft) + self.options(from: candidateRight)
        }
        
        return optionsMemory[position]!
    }
}

guard let lines = linesFromFile("day7.input") else {
    fatalError("No input file")
}

var map = Map(lines)

print(map)

guard let start = map.startPosition() else {
    fatalError("No start position")
}

var nextPositions: Set<Position> = [start]
var result = 0
repeat {
    let toCheck = nextPositions
    nextPositions = []
    for position in toCheck {
        let newPosition = Position(x: position.x, y: position.y + 1)
        let tile = map.tile(at: newPosition)
        switch tile {
        case .empty:
            nextPositions.insert(newPosition)
        case .splitter:
            let candidateLeft = Position(x: position.x - 1, y: position.y + 1)
            let candidateRight = Position(x: position.x + 1, y: position.y + 1)
            if (map.tile(at: candidateLeft) != nil) {
                nextPositions.insert(candidateLeft)
            }
            if (map.tile(at: candidateRight) != nil) {
                nextPositions.insert(candidateRight)
            }
            
            result += 1
        case .start:
            fatalError("Found start again")
        case nil:
            continue
        }
    }
    
} while (nextPositions.count > 0)

print("Result: \(result)")

let options = map.options(from: start)
print("Result 2: \(options)")

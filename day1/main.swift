//
//  main.swift
//  aoc2025
//
//  Created by Johannes Loepelmann on 01.12.25.
//

import Foundation

enum Instruction {
    case L(Int)
    case R(Int)
    
    func apply(to position: Int) -> (Int, Int) {
        var result: Int
        var zeroes: Int = 0
        switch self {
        case .L(let value):
            if(position == 0) {
                zeroes = -1
            }
            result = position - value
            
        case .R(let value):
            result = position + value
            if (result % 100 == 0) {
                zeroes = -1
            }
        }
                
        while result < 0 {
            result += 100
            zeroes += 1
        }
        
        while result > 99 {
            result -= 100
            zeroes += 1
        }
        
        if(result == 0) {
            zeroes += 1
        }
        
        return (result, zeroes)
    }
    
    init (rawValue: String.SubSequence) {
        switch rawValue.first {
            case "L":
            self = .L(Int(rawValue.dropFirst())!)
        case "R":
            self = .R(Int(rawValue.dropFirst())!)
        default :
            fatalError("Unknown instruction: \(rawValue)")
        }
    }
}

guard let lines = linesFromFile("day1.input") else {
    fatalError("Could not read file")
}

let instructions = lines.map(Instruction.init)
var position: Int = 50
var result = 0
for instruction in instructions {
    let zeroes: Int
    (position, zeroes) = instruction.apply(to: position)
    result += zeroes
    print("Instruction: \(instruction), Position: \(position), zeroes: \(zeroes)")
}

print ("Result: \(result)")

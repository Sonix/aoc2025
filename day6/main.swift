//
//  main.swift
//  day6
//
//  Created by Johannes Loepelmann on 08.12.25.
//

import Foundation

enum Operation {
    case ADD
    case MUL
    
    init (_ string: String.SubSequence) {
        switch string {
        case "+":
            self = .ADD
        case "*":
            self = .MUL
        default:
            fatalError("Unknown operation: \(string)")
        }
    }
}

struct Problem {
    let numbers: [Int]
    let operation: Operation
    
    func result() -> Int {
        switch(operation) {
        case .ADD:
            return numbers.reduce(0, +)
        case .MUL:
            return numbers.reduce(1, *)
        }
    }
}

guard let lines = linesFromFile("day6.input") else {
    fatalError("No input file")
}

var rawNumbers: [[Int]]

rawNumbers = lines.map { line in
    let parts = line.split(separator: " ")
    let numbers = parts.compactMap{Int($0)}
    return numbers
}.dropLast()

let rawOps = lines.last!.split(separator: " ").map(Operation.init)

var problems : [Problem] = []
for i in 0..<rawNumbers[0].count {
    let numbers = rawNumbers.map(\.self[i])
    let problem = Problem(numbers: numbers, operation: rawOps[i])
    problems.append(problem)
}

print("Part 1: \(problems.map{$0.result()}.reduce(0, +))")


let part2Numbers : [[Int]] = []

var rawStrings : [String] = []
for i in 0..<lines.first!.count {
    let rawIn = String(lines.map{ $0[$0.index($0.startIndex, offsetBy: i)] })
    rawStrings.append(rawIn)
}

let problems2Input = rawStrings.split(whereSeparator: {$0.allSatisfy { c in c.isWhitespace }})
var problems2 : [Problem] = []

for problemInput in problems2Input {
    let op = Operation(Substring(String(problemInput.first!.last!)))
    var nums : [Int] = []
    let firstNumber = Int(problemInput.first!.dropLast().trimmingCharacters(in: CharacterSet.whitespacesAndNewlines))!
    let otherNumbers = problemInput[problemInput.index(after: problemInput.startIndex)...].compactMap{Int($0.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines))}
    nums.append(firstNumber)
    nums.append(contentsOf: otherNumbers)
    problems2.append(Problem(numbers: nums, operation: op))
}

print("Part 2: \(problems2.map{$0.result()}.reduce(0, +))")

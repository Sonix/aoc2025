//
//  utils.swift
//  day1
//
//  Created by Johannes Loepelmann on 02.12.25.
//

import Foundation

func linesFromFile(_ filename: String) -> [String.SubSequence]? {
    do {
        let result = try String.init(contentsOfFile: filename, encoding: .utf8)
        return result.split(whereSeparator: \.isNewline)
    } catch {
        print("Could not read file: \(filename)")
        return nil
    }
}

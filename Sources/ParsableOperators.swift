//
//  ParsableOperators.swift
//  Parsable
//
//  Created by Jo Albright on 1/1/16.
//  Copyright © 2016 Jo Albright. All rights reserved.
//

import UIKit


// MARK: - <-- Operator

infix operator <-- : AssignmentPrecedence

// Parsable Assignment

public func <-- <T:Parsable>(lhs:inout T, rhs: Any?) { lhs = T(rhs as? ParsedInfo ?? [:]) }
public func <-- <T:Parsable>(lhs:inout Any, rhs: T) { lhs = rhs.parse() }

// Parsable? Assignment

public func <-- <T:Parsable>(lhs:inout T?, rhs: Any?) { lhs = T(rhs as? ParsedInfo ?? [:]) }
public func <-- <T:Parsable>(lhs:inout Any?, rhs: T?) { lhs = rhs?.parse() }

// [Parsable] Assignment

public func <-- <T:Parsable>(lhs:inout [T], rhs: Any?) { lhs = (rhs as? [ParsedInfo])?.map { T($0) } ?? [] }
public func <-- <T:Parsable>(lhs:inout Any?, rhs: [T]) { lhs = rhs.parse() }

// Generic Assignment

public func <-- <T>(lhs:inout T, rhs: Any?) { lhs = rhs as? T ?? lhs }
public func <-- <T>(lhs:inout Any?, rhs: T) { lhs = rhs }
public func <-- <T>(lhs:inout Any??, rhs: T) { lhs = rhs as Any? }

// Generic? Assignment

public func <-- <T>(lhs:inout T?, rhs: Any?) { lhs = rhs as? T }
public func <-- <T>(lhs:inout Any?, rhs: T?) { lhs = rhs }

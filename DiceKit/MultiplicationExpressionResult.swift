//
//  MultiplicationExpressionResult.swift
//  DiceKit
//
//  Created by Brentley Jones on 7/18/15.
//  Copyright © 2015 Brentley Jones. All rights reserved.
//

import Foundation

public struct MultiplicationExpressionResult<MultiplierResult: protocol<ExpressionResultType, Equatable>, MultiplicandResult: protocol<ExpressionResultType, Equatable>>: Equatable {
    
    public let multiplierResult: MultiplierResult
    public let multiplicandResults: [MultiplicandResult]
    public let negateMultiplicandResults: Bool
    
    public init(multiplierResult: MultiplierResult, multiplicandResults: [MultiplicandResult]) {
        assert(abs(multiplierResult.resultValue.multiplierEquivalent) == multiplicandResults.count)
        
        self.multiplierResult = multiplierResult
        self.multiplicandResults = multiplicandResults
        self.negateMultiplicandResults = multiplierResult.resultValue < 0
    }
    
}

// MARK: - CustomStringConvertible

extension MultiplicationExpressionResult: CustomStringConvertible {
    
    public var description: String {
        let multiplicandResultsSign = negateMultiplicandResults ? "-" : ""
        let multiplicandStrings = multiplicandResults.map { String($0) }
        let multiplicandResultsDescription = multiplicandStrings.joinWithSeparator(" + ")
        return "((\(multiplierResult)) *> \(multiplicandResultsSign)(\(multiplicandResultsDescription)))"
    }
    
}

// MARK: - CustomDebugStringConvertible

extension MultiplicationExpressionResult: CustomDebugStringConvertible {
    
    public var debugDescription: String {
        let multiplicandResultsSign = negateMultiplicandResults ? "-" : ""
        let multiplierResultDebugString = String(reflecting: multiplierResult)
        let multiplicandDebugStrings = multiplicandResults.map { String(reflecting: $0) }
        let multiplicandResultsDebugDescription = multiplicandDebugStrings.joinWithSeparator(" + ")
        return "((\(multiplierResultDebugString)) *> \(multiplicandResultsSign)(\(multiplicandResultsDebugDescription)))"
    }
    
}

// MARK: - Equatable

public func == <M, R>(lhs: MultiplicationExpressionResult<M,R>, rhs: MultiplicationExpressionResult<M,R>) -> Bool {
    return lhs.multiplierResult == rhs.multiplierResult && lhs.multiplicandResults == rhs.multiplicandResults
}

// MARK: - ExpressionResultType

extension MultiplicationExpressionResult: ExpressionResultType {
    
    public var resultValue: ExpressionResultValue {
        let values = multiplicandResults.map { $0.resultValue }
        
        if negateMultiplicandResults {
            return values.reduce(0, combine: -)
        } else {
            return values.reduce(0, combine: +)
        }
    }
    
}

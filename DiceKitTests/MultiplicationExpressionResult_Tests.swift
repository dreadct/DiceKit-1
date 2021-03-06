//
//  MultiplicationExpressionResult_Tests.swift
//  DiceKit
//
//  Created by Brentley Jones on 7/18/15.
//  Copyright © 2015 Brentley Jones. All rights reserved.
//

import XCTest
import Nimble
import SwiftCheck

import DiceKit

/// Tests the `MultiplicationExpressionResult` type
class MultiplicationExpressionResult_Tests: XCTestCase {
    
}

// MARK: - Equatable
extension MultiplicationExpressionResult_Tests {
    
    func equatableFixture(a: UInt, _ b: UInt) -> (multiplierResult: Constant, multiplicandResults: [Constant]) {
        let multiplierResult = ExpressionResultValue(integerLiteral: Int(a % 101))
        let multiplicandRange = UInt32(b % 101)
        let multiplicandResults = (0..<multiplierResult.multiplierEquivalent).map { _ in
            c(ExpressionResultValue(integerLiteral: Int(arc4random_uniform(multiplicandRange))))
        }
        
        return (c(multiplierResult), multiplicandResults)
    }
    
    func test_shouldBeReflexive() {
        property("reflexive") <- forAll {
            (a: UInt, b: UInt) in
            
            let fixture = self.equatableFixture(a, b)
            
            return EquatableTestUtilities.checkReflexive {
                MultiplicationExpressionResult(multiplierResult: fixture.multiplierResult, multiplicandResults: fixture.multiplicandResults)
            }
        }
    }
    
    func test_shouldBeSymmetric() {
        property("symmetric") <- forAll {
            (a: UInt, b: UInt) in
            
            let fixture = self.equatableFixture(a, b)
            
            return EquatableTestUtilities.checkSymmetric {
                MultiplicationExpressionResult(multiplierResult: fixture.multiplierResult, multiplicandResults: fixture.multiplicandResults)
            }
        }
    }
    
    func test_shouldBeTransitive() {
        property("transitive") <- forAll {
            (a: UInt, b: UInt) in
            
            let fixture = self.equatableFixture(a, b)
            
            return EquatableTestUtilities.checkTransitive {
                MultiplicationExpressionResult(multiplierResult: fixture.multiplierResult, multiplicandResults: fixture.multiplicandResults)
            }
        }
    }
    
    func test_shouldBeAbleToNotEquate() {
        property("non-equal") <- forAll {
            (a: UInt, b: UInt, c: UInt, d: UInt) in
            
            // Only check one set of parameters since not commutitive
            return (a != c) ==> {
                let xFixture = self.equatableFixture(a, b)
                let yFixture = self.equatableFixture(c, d)
                
                return EquatableTestUtilities.checkNotEquate(
                    { MultiplicationExpressionResult(multiplierResult: xFixture.multiplierResult, multiplicandResults: xFixture.multiplicandResults) },
                    { MultiplicationExpressionResult(multiplierResult: yFixture.multiplierResult, multiplicandResults: yFixture.multiplicandResults) }
                )
            }
        }
    }
    
}

// MARK: - ExpressionResultType
extension MultiplicationExpressionResult_Tests {
    
    func test_value_shouldSumTheMultiplicandResultsForPositiveMultiplier() {
        property("value with positive multiplier") <- forAll {
            (a: ArrayOf<Constant>) in
            
            let a = a.getArray
            
            let multiplierResult = ExpressionResultValue(integerLiteral: a.count)
            let multiplicandResults = a
            let expectedValue = multiplicandResults.reduce(0) { $0 + $1.resultValue }
            let result = MultiplicationExpressionResult(multiplierResult: c(multiplierResult), multiplicandResults: multiplicandResults)
            
            let value = result.resultValue
            
            return value == expectedValue
        }
    }
    
    func test_value_shouldNegateTheMultiplicandResultsForNegativeMultiplier() {
        property("value with negative multiplier") <- forAll {
            (a: ArrayOf<Constant>) in
            
            let a = a.getArray
        
            let multiplierResult = ExpressionResultValue(integerLiteral: -a.count)
            let multiplicandResults = a
            let expectedValue = multiplicandResults.reduce(0) { $0 - $1.resultValue }
            let result = MultiplicationExpressionResult(multiplierResult: c(multiplierResult), multiplicandResults: multiplicandResults)
            
            let value = result.resultValue
            
            return value == expectedValue
        }
    }
    
}

// MARK: - CustomDebugStringConvertible
extension MultiplicationExpressionResult_Tests {
    
    func test_CustomDebugStringConvertible() {
        let expression = 2 * d(10)
        let evaluation = expression.evaluate()
        let expected = "((\(String(reflecting: c(2)))) *> (\(String(reflecting: evaluation.multiplicandResults[0])) + \(String(reflecting: evaluation.multiplicandResults[1]))))"
        
        let result = String(reflecting: evaluation)
        
        expect(result) == expected
    }
    
}

// MARK: = CustomStringConvertible
extension MultiplicationExpressionResult_Tests {
    
    func test_CustomStringConvertible() {
        let expression = 2 * d(10)
        let evaluation = expression.evaluate()
        let expected = "((\(c(2))) *> (\(evaluation.multiplicandResults[0]) + \(evaluation.multiplicandResults[1])))"
        
        let result = String(evaluation)
        
        expect(result) == expected
    }
    
}

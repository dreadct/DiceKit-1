//
//  MockExpression.swift
//  DiceKit
//
//  Created by Brentley Jones on 8/7/15.
//  Copyright © 2015 Brentley Jones. All rights reserved.
//

import DiceKit

class MockExpression: ExpressionType, Equatable {
    
    typealias Result = Constant
    
    var evaluateCalled = 0
    var stubResulter: () -> Result = { 0 }
    var stubProbabilityMass = ExpressionProbabilityMass(0)
    
    func evaluate() -> Result {
        let result = stubResulter()
        ++evaluateCalled
        return result
    }
    
    var probabilityMass: ExpressionProbabilityMass {
        return stubProbabilityMass
    }
    
}

// MARK: - Equatable

func == (lhs: MockExpression, rhs: MockExpression) -> Bool {
    return lhs === rhs
}

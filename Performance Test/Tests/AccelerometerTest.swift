//
//  AccelerometerTest.swift
//  Performance Test
//
//  Created by Djimon Nowak on 14.07.20.
//  Copyright © 2020 Djimon Nowak. All rights reserved.
//

import Foundation

class AccelerometerTest {
    //MARK: Properties
    let numberOfIterations: Int
    var testResults: [TestResult]
    var numberOfIterationsLeft: Int
    
    init(_ numberOfIterations: Int, testResults: inout [TestResult]) {
        self.testResults = testResults
        self.numberOfIterations = numberOfIterations
        self.numberOfIterationsLeft = numberOfIterations
    }
    
    //MARK: Member Methods
    func startTest() {
        
    }
}

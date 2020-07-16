//
//  AccelerometerTest.swift
//  Performance Test
//
//  Created by Djimon Nowak on 14.07.20.
//  Copyright © 2020 Djimon Nowak. All rights reserved.
//

import Foundation

class AccelerometerTest : ObservableObject {
    //MARK: Properties
    let numberOfIterations: Int
    @Published var testResults: [TestResult]
    var numberOfIterationsLeft: Int
    
    init(_ numberOfIterations: Int, testResults: [TestResult]) {
        self.testResults = testResults
        self.numberOfIterations = numberOfIterations
        self.numberOfIterationsLeft = numberOfIterations
    }
    
    //MARK: Member Methods
    func startTest() {
        //for i in 0...10 {
          //  testResults.append(TestResult(id: i, duration: 1.0, message: "moin"))
        //}
        let randomTestResult = TestResult(id: 0, duration: 1.0, message: "hi")
        testResults.append(randomTestResult)
    }
}

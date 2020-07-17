//
//  TestResult.swift
//  Performance Test
//
//  Created by Djimon Nowak on 14.07.20.
//  Copyright © 2020 Djimon Nowak. All rights reserved.
//

import Foundation

struct TestResult : Identifiable {
    var id: Int
    var duration: Double
    var message: String
    
    init(id: Int, duration: Double, message: String) {
        self.id = id
        self.duration = duration
        self.message = message
    }
}

class TestResults : ObservableObject {
    @Published var testResults: [TestResult]
    
    init(){
        testResults = [TestResult]()
    }
}

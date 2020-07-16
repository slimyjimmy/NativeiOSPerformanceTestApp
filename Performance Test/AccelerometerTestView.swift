//
//  AccelerometerTestView.swift
//  Performance Test
//
//  Created by Djimon Nowak on 14.07.20.
//  Copyright © 2020 Djimon Nowak. All rights reserved.
//

import SwiftUI
import CoreMotion

//MARK: AccelerometerTestView

struct AccelerometerTestView: View {
    
    @State var numberOfIterationsString = ""
    @State var testResults = [TestResult]()
    
    var body: some View {
        VStack {
            Text("Fetch the current accelerometer values")
            
            Text("Please specify test parameters")
            
            TextField("Number of iterations", text: $numberOfIterationsString).padding()

            Button(action: {
                self.startTest(Int(self.numberOfIterationsString) ?? 0)
            }) {
                Text("START BENCHMARK")
            }
            List(testResults) { testResult in
                Text(testResult.duration.description + "ns")
                Text(testResult.message)
            }
        }
    }
    
    func startTest(_ numberOfIterationsLeft: Int) -> () {
        var numberOfIterationsTotal = Int(numberOfIterationsString) ?? 0
        if (numberOfIterationsLeft == numberOfIterationsTotal) {
            testResults.removeAll()
        }
        if (numberOfIterationsLeft <= 0) {
            return
        }
        let motionManager = CMMotionManager()
        motionManager.accelerometerUpdateInterval = 0.1
        let startTime = DispatchTime.now()
        if (!motionManager.isAccelerometerAvailable) {
            print("geht hier nicht bro")
        }
        motionManager.startAccelerometerUpdates(to: OperationQueue.current!) { (data, error) in
                if let myData = data{
                    let stopTime = DispatchTime.now()
                    motionManager.stopAccelerometerUpdates()
                    let x = String(myData.acceleration.x * 9.8)
                    let y = String(myData.acceleration.y * 9.8)
                    let z = String(myData.acceleration.z * 9.8)
                    var testResult = TestResult(id: numberOfIterationsTotal + 1 - numberOfIterationsLeft, duration: startTime.distance(to: stopTime).toDouble(), message: "Test finished (X: " + x + ", Y: " + y + ", Z: " + z + ")")
                    self.testResults.append(testResult)
                    if (numberOfIterationsLeft > 1) {
                        self.startTest(numberOfIterationsLeft - 1)
                    }
                }
        }
    }
}






//MARK: Preview

struct AccelerometerTestView_Previews: PreviewProvider {
    static var previews: some View {
        AccelerometerTestView()
    }
}

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
        NavigationView {
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
        }.navigationBarTitle("Accelerometer", displayMode: .inline)
    }
    }
    
    //MARK: Test
    
    func startTest(_ numberOfIterationsLeft: Int) -> () {
        let numberOfIterationsTotal = Int(numberOfIterationsString) ?? 0
        if (numberOfIterationsLeft == numberOfIterationsTotal) {
            testResults.removeAll()
        }
        if (numberOfIterationsLeft == 0) {
            var durationSum = 0.0
            for i in 0...self.testResults.count - 1 {
                durationSum += self.testResults[i].duration
            }
            var durationAvg = durationSum / Double(self.testResults.count)
            testResults.append(TestResult(id: numberOfIterationsTotal + 1, duration: durationAvg, message: "ALL TESTS FINISHED SUCCESSFULLY AVERAGING"))
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
                    let x = String(myData.acceleration.x * 9.81)
                    let y = String(myData.acceleration.y * 9.81)
                    let z = String(myData.acceleration.z * 9.81)
                    var testResult = TestResult(id: numberOfIterationsTotal + 1 - numberOfIterationsLeft, duration: startTime.distance(to: stopTime).toDouble(), message: "Test finished (X: " + x + ", Y: " + y + ", Z: " + z + ")")
                    self.testResults.append(testResult)
                    self.startTest(numberOfIterationsLeft - 1)
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

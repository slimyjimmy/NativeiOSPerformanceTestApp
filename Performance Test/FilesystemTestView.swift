//
//  FilesystemTestView.swift
//  Performance Test
//
//  Created by Djimon Nowak on 14.07.20.
//  Copyright © 2020 Djimon Nowak. All rights reserved.
//

import SwiftUI
import CoreMotion
import Contacts

//MARK: FilesystemTestView

struct FilesystemTestView: View {
    
    @State var numberOfIterationsString = ""
    @State var testResults = [TestResult]()
    var fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("testImage.png")
    
    var body: some View {
        NavigationView {
        VStack {
            Text("Fetch image from device filesystem")
            
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
        }.navigationBarTitle("Filesystem", displayMode: .inline)
    }
    }
    
    //MARK: Test
    
    func writeFileToDevice() -> (){
        let fileManager = FileManager()
        if (fileManager.fileExists(atPath: fileURL.path)) {
            return
        }
        let convertedData = Data(base64Encoded: Base64Helper.encodedImage)
        do {
            try convertedData?.write(to: fileURL)
        }
        catch {
            print("pech gehant")
        }
        return
    }
    
    func startTest(_ numberOfIterationsLeft: Int) -> () {
        let numberOfIterationsTotal = Int(numberOfIterationsString) ?? 0
        if (numberOfIterationsLeft == numberOfIterationsTotal) {
            testResults.removeAll()
        }
        writeFileToDevice()
        if (numberOfIterationsLeft == 0) {
            var durationSum = 0.0
            for i in 0..<self.testResults.count {
                durationSum += self.testResults[i].duration
            }
            var durationAvg = durationSum / Double(self.testResults.count)
            testResults.append(TestResult(id: numberOfIterationsTotal + 1, duration: durationAvg, message: "ALL TESTS FINISHED SUCCESSFULLY AVERAGING"))
            return
        }
        
        let startTime: DispatchTime
        let stopTime: DispatchTime
        let fileManager = FileManager()
        startTime = DispatchTime.now()
        let data = fileManager.contents(atPath: fileURL.path)
        stopTime = DispatchTime.now()
        
        var testResult = TestResult(id: numberOfIterationsTotal + 1 - numberOfIterationsLeft, duration: startTime.distance(to: stopTime).toDouble(), message: "Test finished sucessfully")
        self.testResults.append(testResult)
        self.startTest(numberOfIterationsLeft - 1)
    }
}






//MARK: Preview

struct FilesystemTestView_Previews: PreviewProvider {
    static var previews: some View {
        ContactsTestView()
    }
}

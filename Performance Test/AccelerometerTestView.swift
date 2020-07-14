//
//  AccelerometerTestView.swift
//  Performance Test
//
//  Created by Djimon Nowak on 14.07.20.
//  Copyright © 2020 Djimon Nowak. All rights reserved.
//

import SwiftUI

struct AccelerometerTestView: View {
    
    @State var numberOfIterationsString = ""
    @State var testResults = [TestResult]()
    
    var body: some View {
        VStack {
            Text("Fetch the current accelerometer values")
            
            Text("Please specify test parameters")
            
            TextField("Number of iterations", text: $numberOfIterationsString).padding()

            Button(action: {
                let test = AccelerometerTest( Int(self.numberOfIterationsString) ?? 0)
            }) {
                Text("START BENCHMARK")
            }

            List(testResults, id: \.id) { testResult in
                HStack {
                    Text(testResult.duration.description)
                    Text(testResult.message)
                }
            }
        }
    }
}

struct AccelerometerTestView_Previews: PreviewProvider {
    static var previews: some View {
        AccelerometerTestView()
    }
}

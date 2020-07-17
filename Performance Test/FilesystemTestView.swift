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
    
    var body: some View {
        NavigationView {
        VStack {
            Text("Fetch image from device filesystem")
            
            Text("Please specify test parameters")
            
            TextField("Number of iterations", text: $numberOfIterationsString).padding()

            Button(action: {
                let contactStore = CNContactStore()
                if (CNContactStore.authorizationStatus(for: .contacts) != CNAuthorizationStatus.authorized) {
                    contactStore.requestAccess(for: .contacts, completionHandler: {_,_ in print("hi")})
                }
                self.startTest(Int(self.numberOfIterationsString) ?? 0)
            }) {
                Text("START BENCHMARK")
            }
            List(testResults) { testResult in
                Text(testResult.duration.description + "ns")
                Text(testResult.message)
            }
        }.navigationBarTitle("Contacts", displayMode: .inline)
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
            for i in 0..<self.testResults.count {
                durationSum += self.testResults[i].duration
            }
            var durationAvg = durationSum / Double(self.testResults.count)
            testResults.append(TestResult(id: numberOfIterationsTotal + 1, duration: durationAvg, message: "ALL TESTS FINISHED SUCCESSFULLY AVERAGING"))
            return
        }
        
        //Test zeit messen etc.
        let contact = CNMutableContact()
        contact.givenName = "SwiftIsWeird" + String(Int.random(in: 0 ... 1000))
        contact.phoneNumbers = [CNLabeledValue(
        label: CNLabelPhoneNumberiPhone,
        value: CNPhoneNumber(stringValue: "(408) 555-0126"))]
        let store = CNContactStore()
        let saveRequest = CNSaveRequest()
        saveRequest.add(contact, toContainerWithIdentifier: nil)
        let startTime = DispatchTime.now()
        do {
            try store.execute(saveRequest)
        }
        catch {
            print("huch")
        }
        let stopTime = DispatchTime.now()
        var testResult = TestResult(id: numberOfIterationsTotal + 1 - numberOfIterationsLeft, duration: startTime.distance(to: stopTime).toDouble(), message: "Test finished sucessfully (" + contact.givenName + ")")
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

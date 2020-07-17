//
//  GeolocationTestView.swift
//  Performance Test
//
//  Created by Djimon Nowak on 14.07.20.
//  Copyright © 2020 Djimon Nowak. All rights reserved.
//

import SwiftUI
import CoreMotion
import CoreLocation
import MapKit

//MARK: GeolocationTestView

struct GeolocationTestView: View {
    
    @State var numberOfIterationsString = ""
    @ObservedObject var myTestResults: TestResults = TestResults()
    let locationManager = CLLocationManager()
    var tempTestResults = [TestResult]()
    let locationService = LocationService()
    
    var body: some View {
        NavigationView {
        VStack {
            Text("Fetch the current geolocation values")
            
            Text("Please specify test parameters")
            
            TextField("Number of iterations", text: $numberOfIterationsString).padding()

            Button(action: {
                self.startTest(Int(self.numberOfIterationsString) ?? 0)
            }) {
                Text("START BENCHMARK")
            }
            List(myTestResults.testResults) { testResult in
                Text(testResult.duration.description + "ns")
                Text(testResult.message)
            }
        }.navigationBarTitle("Geolocation", displayMode: .inline)
    }
    }
    
    //MARK: Test
    
    func startTest(_ numberOfIterationsLeft: Int) -> () {
        myTestResults.testResults.removeAll()
        locationService.setNumberOfIterationsLeft(Int(numberOfIterationsString) ?? 0)
        locationService.setTestResults(myTestResults)
        locationService.startLocationUpdates()
    }
}
    
//MARK: LocationService

class LocationService : NSObject, CLLocationManagerDelegate {
    var locationManager = CLLocationManager()
    var locationFixAchieved : Bool = false
    var seenError: Bool = false
    var skippedFirstResult = false
    var locationStatus = "Not started yet"
    var numberOfIterationsLeft = 0
    //var testResults: [TestResult]
    //var testResults = [TestResult]()
    var testResults = TestResults()
    var startTime: DispatchTime = DispatchTime.now()
    
    override init() {
        super.init()
        initLocationManager()
    }
    
    func setNumberOfIterationsLeft(_ numberOfIterationsLeft: Int) {
        self.numberOfIterationsLeft = numberOfIterationsLeft
    }
    
    func setTestResults(_ testResults: TestResults) {
        self.testResults = testResults
    }
    
    func initLocationManager() {
        if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.denied || CLLocationManager.authorizationStatus() == CLAuthorizationStatus.notDetermined) {
            locationManager.requestWhenInUseAuthorization()
        } else {
            seenError = false
            locationFixAchieved = false
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.distanceFilter = 0
        }
    }
    
    func startLocationUpdates() {
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        locationManager.stopUpdatingLocation()
        print("alarm")
    }
        
        //MARK: DidUpdateLocations
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let startTimeOld = startTime
        startTime = DispatchTime.now()
        if (!skippedFirstResult) {
            skippedFirstResult = true
        } else {
            print("location did change")
            //locationManager.stopUpdatingLocation()
            let stopTime = DispatchTime.now()
            let lastLocation = locations.last!
            testResults.testResults.append(TestResult(id: self.numberOfIterationsLeft, duration: startTimeOld.distance(to: stopTime).toDouble(), message: "Test finished (Lat: " + lastLocation.coordinate.latitude.description + ", Long: " + lastLocation.coordinate.longitude.description))
            numberOfIterationsLeft -= 1
            if (numberOfIterationsLeft == 0) {
                locationManager.stopUpdatingLocation()
                var durationSum = 0.0
                for i in 0..<testResults.testResults.count {
                    durationSum += testResults.testResults[i].duration
                }
                let durationAvg = durationSum / Double(testResults.testResults.count)
                testResults.testResults.append(TestResult(id: testResults.testResults.count + 1, duration: durationAvg, message: "ALL TESTS FINISHED SUCCESSFULLY AVERAGING"))
            } else {
                //locationManager.startUpdatingLocation()
                //startTime = DispatchTime.now()
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {}
}





//MARK: Preview

struct GeolocationTestView_Previews: PreviewProvider {
    static var previews: some View {
        ContactsTestView()
    }
}

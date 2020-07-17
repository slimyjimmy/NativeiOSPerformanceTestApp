//
//  ContentView.swift
//  Performance Test
//
//  Created by Djimon Nowak on 14.07.20.
//  Copyright © 2020 Djimon Nowak. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Benchmarks for the performance of native iOS apps").fixedSize(horizontal: false, vertical: true)
                NavigationLink(destination: AccelerometerTestView()) {
                    Text("ACCELEROMETER TEST")
                }.padding()
                
                NavigationLink(destination: ContactsTestView()) {
                    Text("CONTACTS TEST")
                }.padding()
                
                NavigationLink(destination: GeolocationTestView()) {
                    Text("GEOLOCATION TEST")
                }.padding()
                
                NavigationLink(destination: GeolocationTestView()) {
                    Text("FILESYSTEM TEST")
                }.padding()
                Spacer()
            }
                .navigationBarTitle("Performance Test", displayMode: .inline)
                }
            }
        }

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

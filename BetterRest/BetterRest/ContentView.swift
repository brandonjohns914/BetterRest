//
//  ContentView.swift
//  BetterRest
//
//  Created by Brandon Johns on 6/11/23.
//

import CoreML
import SwiftUI

struct ContentView: View {
    @State private var wakeUp = defaultWakeTime
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1
    
    //@State private var alertTitle = ""
    //@State private var alertMessage = ""
    //@State private var showingAlert = false
    
    var sleepResults: String
    {
        do {
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)
            
            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
            
            let hour = (components.hour ?? 0) * 60 * 60
            let minute = (components.minute ?? 0) * 60
            
            let prediction = try model.prediction(wake: Double( hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            
            let sleepTime = wakeUp - prediction.actualSleep
            
            return "Your ideal bedtime is " + sleepTime.formatted(date: .omitted, time: .shortened)
        }
        catch
        {
            return "There was an error "
        }
    }
    static var defaultWakeTime: Date
    {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        
        return Calendar.current.date(from: components) ?? Date.now
    }
    
    var body: some View {
        
        NavigationView
        {
            Form
            {
                //VStack(alignment: .leading, spacing: 0)
                Section("When do you want to wake up?")
                {
                    //Text("When do you want to wake up?").font(.headline)
                    
                    DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                }
                Section("Desired amount of sleep")                                                                              //only works when section titles are text only
                {
                    
                    
                    Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
                }
                
                Section("Daily Coffee Intake")
                {
                    
                    Picker("Number of cups of coffee", selection: $coffeeAmount)
                    {
                        ForEach(1..<21)
                        {
                            Text("\($0) Cups")
                        }
                    }
                    .pickerStyle(.wheel)
                    .labelsHidden()
                    //Stepper(coffeeAmount == 1 ? "1 cup" : "\(coffeeAmount) cups", value: $coffeeAmount, in: 1...20)
                }
                
                Text(sleepResults).font(.title)
                
            }
            .navigationTitle("BetterRest")
            //            .toolbar {
            //                Button("Calculate", action: calculateBedtime)
            //            }
            //            .alert(alertTitle, isPresented: $showingAlert)
            //            {
            //                Button("OK") {}
            //            } message: {
            //                Text(alertMessage)
            //            }
        }
        
    }
    
    
    //    func calculateBedtime()
    //    {
    //        do
    //        {
    //            let config = MLModelConfiguration()
    //            let model = try SleepCalculator(configuration: config)
    //
    //            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
    //
    //            let hour = (components.hour ?? 0) * 60 * 60
    //            let minute = (components.minute ?? 0) * 60
    //
    //            let prediction = try model.prediction(wake: Double( hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
    //
    //            let sleepTime = wakeUp - prediction.actualSleep
    //
    //            //alertTitle = "Your ideal bedtime is..."
    //
    //           // alertMessage = sleepTime.formatted(date: .omitted, time: .shortened)
    //
    //        }
    //        catch
    //        {
    //            //alertTitle = "Error"
    //            //alertMessage = "Sorry there was a problem calculating your bedtime"
    //
    //
    //        }
    //
    //        //showingAlert = true
    //    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

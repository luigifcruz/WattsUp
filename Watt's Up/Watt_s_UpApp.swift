//
//  Watt_s_UpApp.swift
//  Watt's Up
//
//  Created by Luigi Cruz on 3/28/23.
//

import SwiftUI
import IOKit.ps
import Combine

func getACChargerWatts() -> Int {
    var ACwatts: Int = 0
    if let ACDetails = IOPSCopyExternalPowerAdapterDetails() {
        if let ACList = ACDetails.takeRetainedValue() as? [String: Any] {
            guard let watts = ACList[kIOPSPowerAdapterWattsKey] else {
                return ACwatts
            }
            ACwatts = Int(watts as! Int)
        }
    }
    return ACwatts
}

func isCharging() -> Bool {
    guard let powerSource = IOPSGetProvidingPowerSourceType(nil)?.takeRetainedValue() else {
        return false
    }
    return powerSource as String == kIOPMACPowerKey || powerSource as String == kIOPMUPSPowerKey || powerSource as String == kIOPMUPSPowerKey
}

@main
struct Watt_s_UpApp: App {
    @Environment(\.scenePhase) private var scenePhase
    
    @State var chargingSpeed: Int = 120
    @State var chargingSpeedLabel: String = "Current negotiated charging speed is"
    @State var chargingUnit: String = "W"
    @State var chargingState: Bool = false
    
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some Scene {
        WindowGroup {
            ContentView(chargingSpeed: $chargingSpeed, chargingSpeedLabel: $chargingSpeedLabel, chargingUnit: $chargingUnit, chargingState: $chargingState)
                .onAppear() {
                    updatePowerState()
                }
                .onChange(of: scenePhase) { phase in
                    if phase == .active {
                        timer.upstream.connect().store(in: &cancellables)
                    } else {
                        timer.upstream.connect().cancel()
                    }
                }
                .onReceive(timer) { _ in
                    if scenePhase == .active {
                        updatePowerState()
                    }
                }
                .frame(width: 400, height: 300)
                .fixedSize()
        }
        .windowResizability(.contentSize)
    }
    
    private func updatePowerState() {
        if (!isCharging()) {
            chargingSpeed = 0
            chargingSpeedLabel = "Laptop not charging."
            chargingState = false;
            return
        }
        
        chargingSpeed = getACChargerWatts()
        chargingSpeedLabel = "Current negotiated charging speed is"
        chargingState = true;
    }
    
    @State private var cancellables = Set<AnyCancellable>()
}

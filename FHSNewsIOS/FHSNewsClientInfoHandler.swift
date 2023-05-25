//
//  FHSNewsClientInfoHandler.swift
//  FHSNewsIOS
//
//  Created by Z Keffaber (0xilis) on 5/18/23.
//

import Foundation

let fhsNewsClientVersion = "1"
let cachedDeviceIdentifier = getDeviceIdentifier()
let cachedRunningInSimulator = amIRunningInSimulator()

func getDeviceIdentifier() -> String {
    
    /*
     
     In Objective-C:
     
     #import <sys/utsname.h>

     struct utsname systemInfo;
     uname(&systemInfo);

     NSString* deviceModel = [NSString stringWithCString:systemInfo.machine
                               encoding:NSUTF8StringEncoding];

     
     */
    
    //Thank you to https://stackoverflow.com/questions/26028918/how-to-determine-the-current-iphone-device-model I had no idea how to do this in Swift
    var systemInfo = utsname()
    uname(&systemInfo)
    let modelCode = withUnsafePointer(to: &systemInfo.machine) {
        $0.withMemoryRebound(to: CChar.self, capacity: 1) {
            ptr in String.init(validatingUTF8: ptr)
        }
    }!
    let actualIdentifier = String(validatingUTF8: modelCode) ?? "error"
    let simulatorActualIdentifiers = [
        "ppc",
        "ppc64",
        "i386",
        "x86_64",
        "arm64", //yes i know actual iOS devices are arm64 but they will return their device id, only macOS Simulator will return arm64. well, i *think* arm64 macs will return arm64, according to stack overflow; the M1 actually isn't arm64 - it's arm64e! but arm64e is basically just arm64 but with some new features, so i can see why it would return arm64
        "arm64e" //OK, JUST in case it returns arm64e instead and the stack overflow answer was incorrect, I also added arm64e here too.
    ]
    if simulatorActualIdentifiers.contains(actualIdentifier) {
        //we are running in simulator, lets get device id of the device being simulated
        if let simModelCode = ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] {
            return String(validatingUTF8: simModelCode) ?? "error"
        }
    }
    return actualIdentifier
}

func amIRunningInSimulator() -> String {
    var systemInfo = utsname()
    uname(&systemInfo)
    let modelCode = withUnsafePointer(to: &systemInfo.machine) {
        $0.withMemoryRebound(to: CChar.self, capacity: 1) {
            ptr in String.init(validatingUTF8: ptr)
        }
    }!
    let actualIdentifier = String(validatingUTF8: modelCode) ?? "error"
    let simulatorActualIdentifiers = [
        "ppc",
        "ppc64",
        "i386",
        "x86_64",
        "arm64", //yes i know actual iOS devices are arm64 but they will return their device id, only macOS Simulator will return arm64. well, i *think* arm64 macs will return arm64, according to stack overflow; the M1 actually isn't arm64 - it's arm64e! but arm64e is basically just arm64 but with some new features, so i can see why it would return arm64
        "arm64e" //OK, JUST in case it returns arm64e instead and the stack overflow answer was incorrect, I also added arm64e here too.
    ]
    if simulatorActualIdentifiers.contains(actualIdentifier) {
        return "YES"
    }
    return "NO"
}

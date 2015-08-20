//
//  main.m
//  BluetoothUnlock
//
//  Created by Daiqian Zhang on 8/20/15.
//  Copyright (c) 2015 Daiqian Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <IOBluetooth/IOBluetooth.h>

NSString *TARGET = @"Galaxy Nexus";

int main(int argc, const char * argv[])
{
    IOReturn r;
    IOBluetoothDevice *target = nil;
    
    NSArray *devices = [IOBluetoothDevice pairedDevices];
    for(IOBluetoothDevice *device in devices){
        if([TARGET isEqualToString:device.name]){
            NSLog(@"Target device found : %@", TARGET);
            target = device; break;
        }
    }
    
    
    Boolean isConnected = false;
    system("osascript /Users/daiqian.zhang/Work/UnixUtil/lock_unlock_scenario/outRange.scpt");
    while (true) {
        system("sleep 0.1");
        r = [target openConnection];
        if (r == kIOReturnSuccess && isConnected == false) {
            system("osascript /Users/daiqian.zhang/Work/UnixUtil/lock_unlock_scenario/inRange.scpt");
            isConnected = true; NSLog(@"Connected to : %@", TARGET);
        } else if (r != kIOReturnSuccess && isConnected == true) {
            system("osascript /Users/daiqian.zhang/Work/UnixUtil/lock_unlock_scenario/outRange.scpt");
            isConnected = false; NSLog(@"Disconnected to : %@", TARGET);
        } else {
            continue;
        }
    }
    return 0;
}

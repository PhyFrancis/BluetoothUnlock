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
NSString *SCENARIO = @"lock_unlock_scenario";

int TIME_OUT = 1000; // in unit of milli-second
int SIG_THRESHOLD = -60; // the threshold signal strength in unit of db
int SIG_TOLERANCE = 5; // smear the boundary of in-range and out-range to suppress lock-unlock jumping near boundary.

int REPEAT_MEASUREMENT = 3; // repeated measurement to get more accurate signal strength

bool isInRangeSingle(IOBluetoothDevice *device, int timeOut, int sigThreshold, bool wasInRange)
{
    IOReturn ioRet = [device openConnection:nil withPageTimeout:timeOut authenticationRequired:false];
    if (ioRet != kIOReturnSuccess) {
        NSLog(@"disconnected");
        return false;
    }
    else {
        NSLog(@"conneted with sig: %d", [device rawRSSI]);
        return [device rawRSSI] > sigThreshold + (wasInRange ? -1 : 1) * SIG_TOLERANCE;
    }
}

bool isInRange(IOBluetoothDevice *device, int timeOut, int sigThreshold, bool wasInRange) {
    int vote = 0;
    for (int i = 0; i < REPEAT_MEASUREMENT; i++) {
        vote += isInRangeSingle(device, timeOut, sigThreshold, wasInRange);
    }
    return vote > REPEAT_MEASUREMENT / 2; // mojority vote
}

void inRangeAction(NSString *scenario)
{
    NSLog(@"Running in-range action");
    NSString *command = [NSString stringWithFormat:@"osascript ~/Work/UnixUtil/%@/inRange.scpt", scenario];
    system([command UTF8String]);
}

void outRangeAction(NSString *scenario)
{
    NSLog(@"Running out-range action");
    NSString *command = [NSString stringWithFormat:@"osascript ~/Work/UnixUtil/%@/outRange.scpt", scenario];
    system([command UTF8String]);
}

int main(int argc, const char * argv[])
{
    IOBluetoothDevice *targetDevice = nil;
    NSArray *pairedDevices = [IOBluetoothDevice pairedDevices];
    for(IOBluetoothDevice *device in pairedDevices){
        if([TARGET isEqualToString:device.name]){
            NSLog(@"Target device: %@", TARGET);
            targetDevice = device; break;
        }
    }
    
    Boolean inRange = false; outRangeAction(SCENARIO);
    while (true) {
        system("sleep 0.5");
        bool inRangeUpdate = isInRange(targetDevice, TIME_OUT, SIG_THRESHOLD, inRange);
        if ( inRange == inRangeUpdate) continue;
        else {
            if (inRangeUpdate == true) inRangeAction(SCENARIO);
            else outRangeAction(SCENARIO);
            inRange = inRangeUpdate;
        }
    }
    return 0;
}

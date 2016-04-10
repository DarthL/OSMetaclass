//
//  ClientConnect.m
//  fuzzFoundation
//
//  Created by dayyang on 15/8/1.
//
//

#import <Foundation/Foundation.h>
#import "ClientConnect.h"
#import "dataBuild.h"
#import <IOKit/IOKitLib.h>
#import <UIKit/UIKit.h>
#import <IOKit/IOCFSerialize.h>
#import <IOKit/IOKitKeys.h>

@implementation ClientConnect

-(BOOL)ConnectIOHIDLibUserClient{
    
    CFDictionaryRef     matchDict = NULL;
    io_service_t        service   = 0;
    kern_return_t       kr;
    void *              property;
    vm_size_t           size;
    uint64_t            flag;
    uint32_t            zero = 0;
    //
    //connect IOHIDResource to create a device
    //
    matchDict   = IOServiceMatching([@"IOHIDResource" UTF8String]);
    service     = IOServiceGetMatchingService(kIOMasterPortDefault, matchDict);
    kr          = IOServiceOpen(service, mach_task_self(), 0, &connect);
    if(kr != 0){
        NSLog(@"[-] IOHIDResource open failed");
        connectState = false;
        return false;
    }
    else
        NSLog(@"[+] IOHIDResouce open succeed");
    
    [dataBuild _deviceCreate_data:&property andSize:&size];
    
    kr = IOConnectCallMethod(connect, 0, flag, 1, property, size, NULL, &zero, NULL, (size_t *)&zero);
    
    if(kr != 0){
        NSLog(@"[-] create device failed");
        connectState = false;
        return false;
    }
    else
        NSLog(@"[+] device creating succeed");
    //
    //connect IOHIDLibUserClient
    //
    matchDict   =   IOServiceMatching([@"IOHIDDevice" UTF8String]);
    service     =   IOServiceGetMatchingService(kIOMasterPortDefault, matchDict);
    kr          =   IOServiceOpen(service, mach_task_self(), 0, &connect);
    
    if(kr != 0){
        NSLog(@"[-] IOHIDLibUserClient connect failed");
        return false;
    }
    else{
        NSLog(@"[+] IOHIDLibUserClient connect succeed");
        connectState = true;
    }
    return true;
}

@end
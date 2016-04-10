//
//  Client.m
//  fuzzFoundation
//
//  Created by dayyang on 15/8/6.
//
//

#import <Foundation/Foundation.h>
#import "Client.h"
#import <IOKit/IOKitLib.h>
#import <UIKit/UIKit.h>
#import <IOKit/IOCFSerialize.h>
#import <IOKit/IOKitKeys.h>
@implementation Client

-(BOOL)connectCient{
    CFDictionaryRef     matchDict = NULL;
    io_service_t        service   = 0;
    kern_return_t       kr;
    matchDict   = IOServiceMatching([serviceName UTF8String]);
    service     = IOServiceGetMatchingService(kIOMasterPortDefault, matchDict);
    kr          = IOServiceOpen(service, mach_task_self(), 0, &connect);
    if(kr != 0){
        NSLog(@"[-] service %@ open failed",serviceName);
        connect_state = false;
        return false;
    }
    else
        connect_state = true;
    return true;
}

@end
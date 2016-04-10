//
//  FuzzIOHIDResourceUserClient.m
//  fuzzFoundation
//
//  Created by dayyang on 15/8/7.
//
//  remaining to complete

#import <Foundation/Foundation.h>
#import "FuzzIOHIDResourceUserClient.h"
#import <IOKit/IOKitLib.h>
#import <UIKit/UIKit.h>
#import <IOKit/IOCFSerialize.h>
#import <IOKit/IOKitKeys.h>

@implementation FuzzIOHIDResourceUserClient


-(void)initMethodSelector{
     SEL fuzzMethod2[] = {
         @selector(createDevice),
         @selector(terminateDevice),
         @selector(handleReport),
         @selector(postReportResult),
         nil
     };
    fuzzMethod = (SEL *)malloc(sizeof(fuzzMethod2));
    memcpy(fuzzMethod,fuzzMethod2,sizeof(fuzzMethod2));
    methondNumber = 4;
    serviceName = @"IOHIDResource";
}

-(void)krCheck:(kern_return_t)kr{
    if(kr == kIOReturnSuccess)
        return;
    else if(kr == kIOReturnBadArgument)
        NSLog(@"Argument fail");
    else if(kr == kIOReturnUnsupported)
        NSLog(@"Unsupported");
    else
        NSLog(@"kr = %x",kr);
}

-(void)methodDispatch:(int)selector{
    [self performSelectorInBackground:fuzzMethod[selector] withObject:nil];
}


-(void)createDevice{
    
}

-(void)terminateDevice{
    
}

-(void)handleReport{
    
}

-(void)postReportResult{
    
}

@end
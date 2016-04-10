//
//  FuzzIOHIDResourceUserClient.h
//  fuzzFoundation
//
//  Created by dayyang on 15/8/7.
//
//
//remaining to complete

#import <Foundation/Foundation.h>
#import "Client.h"
#import "ClientDelegate.h"

@interface FuzzIOHIDResourceUserClient : Client<ClientDelegate>

-(void)initMethodSelector;
-(void)methodDispatch:(int)selector;
//-(BOOL)connectClient;
-(void)krCheck:(kern_return_t)kr;

-(void)createDevice;    //StuIn:Axml<report> 1,-1,0,0
-(void)terminateDevice; //0,0,0,0
-(void)handleReport;    //need a device  ScaIn:time  StuIn:commen <report> 1,-1,0,0
-(void)postReportResult;//ScaIn:ret,objToken  StuIn:commen   2,-1,0,0


@end
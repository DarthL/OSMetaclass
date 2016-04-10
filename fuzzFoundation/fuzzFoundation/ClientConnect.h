//
//  Header.h
//  fuzzFoundation
//
//  Created by dayyang on 15/8/1.
//
//

#import <Foundation/Foundation.h>
#import <IOKit/IOKitLib.h>
#import <UIKit/UIKit.h>
#import <IOKit/IOCFSerialize.h>
#import <IOKit/IOKitKeys.h>

@interface ClientConnect : NSObject{
    @public
    io_connect_t    connect;
    @private
    bool            connectState;
}

-(BOOL)ConnectIOHIDLibUserClient;

@end
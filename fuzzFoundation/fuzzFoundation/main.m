//
//  main.m
//  fuzzFoundation
//
//  Created by dayyang on 15/8/6.
//  Copyright (c) 2015年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GoFuzz.h"
#define clientNumber 1

//void addClient(NSMutableArray *client)
//{
//    FuzzIOHIDLibUserClient* IOHIDLibUserClient = [[FuzzIOHIDLibUserClient alloc] init];
//    /*
//     other client
//    */
//    [client addObject:IOHIDLibUserClient];
//    /* others 
//     */
//}
//
//void GoFuzz(NSMutableArray *client){
//    int i;
//    for(i=0;i<clientNumber;i++){
//    }
//}

int main (int argc, const char * argv[])
{

    @autoreleasepool
    {	
        GoFuzz *fuzzAll = [[GoFuzz alloc] init];
        [fuzzAll initMethodSelector];
        [fuzzAll go];
    }
	return 0;
}


//
//  GoFuzz.m
//  fuzzFoundation
//
//  Created by dayyang on 15/8/6.
//
//

#import <Foundation/Foundation.h>
#import "GoFuzz.h"
#import "FuzzIOHIDLibUserClient.h"
#define the_number 1
@implementation GoFuzz

-(void)initMethodSelector{
    SEL fuzzMethod2[] = {
        @selector(goIOHIDLibUserClient),
        nil
    };
    fuzzMethod = (SEL *)malloc((the_number+1)*sizeof(SEL));
    memcpy(fuzzMethod,fuzzMethod2,(the_number+1)*sizeof(SEL));
    number = the_number;
}



-(void)goIOHIDLibUserClient{
    uint32_t count = 0;
    NSLog(@"222!");
    FuzzIOHIDLibUserClient *fuzz = [[FuzzIOHIDLibUserClient alloc] init];
    [fuzz initMethodSelector];
    [fuzz connectClient];
    NSLog(@"333!");
    while(count < fuzz->methondNumber){
        [fuzz methodDispatch:count];
        count++;
    }
}

-(void)go{
    uint32_t i;
    for(i=0;i<number;i++){
        NSLog(@"111!");
        [self performSelectorInBackground:fuzzMethod[i] withObject:nil];
    }
    while(1){
    
    }
   // [self performSelectorInBackground:@selector(goIOHIDLibUserClient) withObject:nil];
}


@end
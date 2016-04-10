//
//  ClientDelegate.h
//  fuzzFoundation
//
//  Created by dayyang on 15/8/6.
//
//
#import <Foundation/Foundation.h>
@protocol ClientDelegate <NSObject>

@required
//-(BOOL)connectClient;
-(void)methodDispatch:(int)selector;
-(void)initMethodSelector;
@end
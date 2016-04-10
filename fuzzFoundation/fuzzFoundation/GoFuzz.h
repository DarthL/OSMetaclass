//
//  GoFuzz.h
//  fuzzFoundation
//
//  Created by dayyang on 15/8/6.
//
//


#import <Foundation/Foundation.h>

@interface GoFuzz : NSObject{
@private
    SEL *fuzzMethod;
    uint32_t number;
}
-(void)goIOHIDLibUserClient;
-(void)go;
-(void)initMethodSelector;

@end
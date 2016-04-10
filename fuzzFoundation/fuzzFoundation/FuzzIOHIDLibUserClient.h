//
//  FuzzIOHIDLibUserClient.h
//  fuzzFoundation
//
//  Created by dayyang on 15/8/6.
//
//


#import <Foundation/Foundation.h>
#import "Client.h"
#import "ClientDelegate.h"


@interface Queue : NSObject{
@public
    uint64_t    *theQueue;
    uint32_t    queueCount;
}
@end



@interface FuzzIOHIDLibUserClient : Client<ClientDelegate>


@property(atomic,strong)Queue *queue;

-(void)initMethodSelector;
-(void)methodDispatch:(int)selector;
-(BOOL)connectClient;

-(uint64_t)createAQueue;
-(void)krCheck:(kern_return_t)kr;

//client method
-(void)deviceIsValid;
-(void)open;
-(void)close;
-(void)createQueue;
-(void)disposeQueue;
-(void)disposeQueue:(uint64_t)queue;
-(void)addElementToQueue;
-(void)addElementToQueue:(uint64_t)queue;
-(void)removeElementFromQueue;
-(void)removeElementFromQueue:(uint64_t)queue;
-(void)queueHasElement;
-(void)queueHasElement:(uint64_t)queue;
-(void)startQueue;
-(void)startQueue:(uint64_t)queue;
-(void)stopQueue:(uint64_t)queue;
-(void)updateElementValues;
-(void)postElementValues;
-(void)getReport;
-(void)setReport;
-(void)getElementCount;
-(void)getElements;
//quque组合的:
-(void)fuzzQueue;
-(void)fuzzQueueCreateQueue;
-(void)fuzzQueueDisposeQueue;
-(void)fuzzQueueAddElementToQueue;
-(void)fuzzQueueRemoveElementFromQueue;
-(void)fuzzQueueStartQueue;
-(void)fuzzQueueStopQueue;
-(void)addQueue:(uint64_t)queue;
-(void)removeQueue:(uint64_t)queue;

-(void)dealloc;




@end
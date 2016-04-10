//
//  FuzzIOHIDLibUserClient.m
//  fuzzFoundation
//
//  Created by dayyang on 15/8/6.
//
//

#import <Foundation/Foundation.h>
#import "FuzzIOHIDLibUserClient.h"
#import "DataBuild.h"
#import <IOKit/IOKitLib.h>
#import <UIKit/UIKit.h>
#import <IOKit/IOCFSerialize.h>
#import <IOKit/IOKitKeys.h>

#define ScalarMax 16

@implementation Queue
@end

@implementation FuzzIOHIDLibUserClient

-(void)initMethodSelector{
    SEL fuzzMethod2[] = {
        @selector(deviceIsValid),
        @selector(open),
        @selector(close),
        @selector(createQueue),
        @selector(disposeQueue),
        @selector(addElementToQueue),
        @selector(removeElementFromQueue),
        @selector(queueHasElement),
        @selector(startQueue),
        @selector(stopQueue),
        @selector(updateElementValues),
        @selector(postElementValues),
        @selector(getReport),
        @selector(setReport),
        @selector(getElementCount),
        @selector(getElements),
        @selector(fuzzQueue),
        nil
    };
    fuzzMethod = (SEL *)malloc(sizeof(fuzzMethod2));
    memcpy(fuzzMethod,fuzzMethod2,sizeof(fuzzMethod2));
    methondNumber = 17;
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

-(BOOL)connectClient{
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
        connect_state = false;
        return false;
    }
    else
        NSLog(@"[+] IOHIDResouce open succeed");
    
    [DataBuild deviceCreateData:&property andSize:&size];
    
    kr = IOConnectCallMethod(connect, 0, &flag, 1, property, size, NULL, &zero, NULL, (size_t *)&zero);
    
    if(kr != 0){
        NSLog(@"[-] create device failed");
        connect_state = false;
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
        connect_state = true;
    }
    return true;
}

-(uint64_t)createAQueue{
    kern_return_t   kr;
    uint64_t        result;
    DataBuild *data = [[DataBuild alloc] initWithCount:2 structureInSize:0 scalarOutCount:1 structureOutSize:0];
    data->scalarInput[0] = 0;
    data->scalarInput[1] = arc4random()%10000;
    kr = IOConnectCallMethod(connect,
                             3,
                             data->scalarInput, data->scalarInputCount,
                             data->structureInput, data->structureInputSize,
                             data->scalarOutput, &data->scalarOutputCount,
                             data->structureOutput, &data->structureOutputSize);
    result = data->scalarOutput[0];
    [self addQueue:result];
    [data dealloc];
    return result;
}


-(void)methodDispatch:(int)selector
{
    [self performSelectorInBackground:fuzzMethod[selector] withObject:nil];
}

-(void)deviceIsValid{
    kern_return_t kr;
    BOOL end = false;
    int count = 0;
    if(!connect_state){
        NSLog(@"no connect");
        return;
    }
    DataBuild *data = [[DataBuild alloc] initWithCount:0 structureInSize:0 scalarOutCount:2 structureOutSize:0]; //data count init
    
    while(!end){
        /*
         build  fuzz data
         */
        count++;
        kr = IOConnectCallMethod(connect,
                                 0,
                                 data->scalarInput, data->scalarInputCount,
                                 data->structureInput, data->structureInputSize,
                                 data->scalarOutput, &data->scalarOutputCount,
                                 data->structureOutput, &data->structureOutputSize);
        [self krCheck:kr];
        
        /*
         end condition
         */
        if(count >100)
            end = true;
    }
    [data dealloc];
}

-(void)open{
    kern_return_t kr;
    BOOL end = false;
    int count = 0;
    if(!connect_state){
        NSLog(@"no connect");
        return;
    }
    DataBuild *data = [[DataBuild alloc] initWithCount:1 structureInSize:0 scalarOutCount:0 structureOutSize:0]; //data count init
    while(!end){
        [data buildScalarInput:0];
        kr = IOConnectCallMethod(connect,
                                 1,
                                 data->scalarInput, data->scalarInputCount,
                                 data->structureInput, data->structureInputSize,
                                 data->scalarOutput, &data->scalarOutputCount,
                                 data->structureOutput, &data->structureOutputSize);
        [self krCheck:kr];
        count++;
        if(count >100)
            end = true;
    }
    [data dealloc];
    
};

-(void)close{
    kern_return_t kr;
    if(!connect_state){
        NSLog(@"no connect");
        return;
    }
    DataBuild *data = [[DataBuild alloc] initWithCount:0 structureInSize:0 scalarOutCount:0 structureOutSize:0];
    kr = IOConnectCallMethod(    connect,
                             2,
                             data->scalarInput, data->scalarInputCount,
                             data->structureInput, data->structureInputSize,
                             data->scalarOutput, &data->scalarOutputCount,
                             data->structureOutput, &data->structureOutputSize);
    [self krCheck:kr];
    [data dealloc];
}

-(void)createQueue{
    kern_return_t kr;
    BOOL end = false;
    int count = 0;
    if(!connect_state){
        NSLog(@"no connect");
        return;
    }
    DataBuild *data = [[DataBuild alloc] initWithCount:2 structureInSize:0 scalarOutCount:1 structureOutSize:0]; //data count init
    while(!end){
        [data buildScalarInput:0];
        kr = IOConnectCallMethod(connect,
                                 3,
                                 data->scalarInput, data->scalarInputCount,
                                 data->structureInput, data->structureInputSize,
                                 data->scalarOutput, &data->scalarOutputCount,
                                 data->structureOutput, &data->structureOutputSize);
        [self krCheck:kr];
        count++;
        if(count >100)
            end = true;
    }
    [data dealloc];
}

-(void)disposeQueue{
    kern_return_t   kr;
    if(!connect_state){
        NSLog(@"no connect");
        return;
    }
    DataBuild *data = [[DataBuild alloc] initWithCount:1 structureInSize:0 scalarOutCount:0 structureOutSize:0];
    data->scalarInput[0] = [self createAQueue];
    [data buildScalarInput:0];
    kr = IOConnectCallMethod(connect,
                             4,
                             data->scalarInput, data->scalarInputCount,
                             data->structureInput, data->structureInputSize,
                             data->scalarOutput, &data->scalarOutputCount,
                             data->structureOutput, &data->structureOutputSize);
    [self krCheck:kr];
    [data dealloc];
    
}

-(void)disposeQueue:(uint64_t)queue{
    kern_return_t   kr;
    if(!connect_state){
        NSLog(@"no connect");
        return;
    }
    DataBuild *data = [[DataBuild alloc] initWithCount:1 structureInSize:0 scalarOutCount:0 structureOutSize:0];
    data->scalarInput[0] = queue;
    [data buildScalarInput:0];
    kr = IOConnectCallMethod(connect,
                             4,
                             data->scalarInput, data->scalarInputCount,
                             data->structureInput, data->structureInputSize,
                             data->scalarOutput, &data->scalarOutputCount,
                             data->structureOutput, &data->structureOutputSize);
    [self krCheck:kr];
    [data dealloc];
}

-(void)addElementToQueue{
    kern_return_t   kr;
    uint64_t        queue;
    BOOL            end = false;
    int             count = 0;
    if(!connect_state){
        NSLog(@"no connect");
        return;
    }
    DataBuild *data = [[DataBuild alloc] initWithCount:3 structureInSize:0 scalarOutCount:1 structureOutSize:0];
    queue = [self createAQueue];
    while(end){
        [data buildScalarInput:0];
        data->scalarInput[0] = queue;
        kr = IOConnectCallMethod(connect,
                                 5,
                                 data->scalarInput, data->scalarInputCount,
                                 data->structureInput, data->structureInputSize,
                                 data->scalarOutput, &data->scalarOutputCount,
                                 data->structureOutput, &data->structureOutputSize);
        [self krCheck:kr];
        count++;
        if(count >1000)
            end = true;
    }
    [data dealloc];
}

-(void)addElementToQueue:(uint64_t)queue{
    kern_return_t   kr;
    if(!connect_state){
        NSLog(@"no connect");
        return;
    }
    DataBuild *data = [[DataBuild alloc] initWithCount:3 structureInSize:0 scalarOutCount:1 structureOutSize:0];
    [data buildScalarInput:0];
    data->scalarInput[0] = queue;
    kr = IOConnectCallMethod(connect,
                             5,
                             data->scalarInput, data->scalarInputCount,
                             data->structureInput, data->structureInputSize,
                             data->scalarOutput, &data->scalarOutputCount,
                             data->structureOutput, &data->structureOutputSize);
    [self krCheck:kr];
    [data dealloc];
}

-(void)removeElementFromQueue{
    kern_return_t   kr;
    uint64_t        queue;
    BOOL            end = false;
    int             count = 0;
    if(!connect_state){
        NSLog(@"no connect");
        return;
    }
    DataBuild *data = [[DataBuild alloc] initWithCount:2 structureInSize:0 scalarOutCount:1 structureOutSize:0];
    queue = [self createAQueue];
    while(end){
        [data buildScalarInput:0];
        data->scalarInput[0] = queue;
        kr = IOConnectCallMethod(connect,
                                 6,
                                 data->scalarInput, data->scalarInputCount,
                                 data->structureInput, data->structureInputSize,
                                 data->scalarOutput, &data->scalarOutputCount,
                                 data->structureOutput, &data->structureOutputSize);
        [self krCheck:kr];
        count++;
        if(count >1000)
            end = true;
    }
    [data dealloc];
}

-(void)removeElementFromQueue:(uint64_t)queue{
    kern_return_t   kr;
    if(!connect_state){
        NSLog(@"no connect");
        return;
    }
    DataBuild *data = [[DataBuild alloc] initWithCount:2 structureInSize:0 scalarOutCount:1 structureOutSize:0];
    [data buildScalarInput:0];
    data->scalarInput[0] = queue;
    kr = IOConnectCallMethod(connect,
                             6,
                             data->scalarInput, data->scalarInputCount,
                             data->structureInput, data->structureInputSize,
                             data->scalarOutput, &data->scalarOutputCount,
                             data->structureOutput, &data->structureOutputSize);
    [self krCheck:kr];
    [data dealloc];
}

-(void)queueHasElement{
    kern_return_t   kr;
    uint64_t        queue;
    BOOL            end = false;
    int             count = 0;
    if(!connect_state){
        NSLog(@"no connect");
        return;
    }
    DataBuild *data = [[DataBuild alloc] initWithCount:2 structureInSize:0 scalarOutCount:1 structureOutSize:0];
    queue = [self createAQueue];
    while(end){
        [data buildScalarInput:0];
        data->scalarInput[0] = queue;
        kr = IOConnectCallMethod(connect,
                                 7,
                                 data->scalarInput, data->scalarInputCount,
                                 data->structureInput, data->structureInputSize,
                                 data->scalarOutput, &data->scalarOutputCount,
                                 data->structureOutput, &data->structureOutputSize);
        [self krCheck:kr];
        count++;
        if(count >1000)
            end = true;
    }
    [data dealloc];
}

-(void)queueHasElement:(uint64_t)queue{
    kern_return_t   kr;
    if(!connect_state){
        NSLog(@"no connect");
        return;
    }
    DataBuild *data = [[DataBuild alloc] initWithCount:2 structureInSize:0 scalarOutCount:1 structureOutSize:0];
    [data buildScalarInput:0];
    data->scalarInput[0] = queue;
    kr = IOConnectCallMethod(connect,
                             7,
                             data->scalarInput, data->scalarInputCount,
                             data->structureInput, data->structureInputSize,
                             data->scalarOutput, &data->scalarOutputCount,
                             data->structureOutput, &data->structureOutputSize);
    [self krCheck:kr];
    [data dealloc];
}

-(void)startQueue{
    [self startQueue:[self createAQueue]];
}

-(void)startQueue:(uint64_t)queue{
    kern_return_t   kr;
    if(!connect_state){
        NSLog(@"no connect");
        return;
    }
    DataBuild *data = [[DataBuild alloc] initWithCount:1 structureInSize:0 scalarOutCount:0 structureOutSize:0];
    data->scalarInput[0] = queue;
    kr = IOConnectCallMethod(connect,
                             8,
                             data->scalarInput, data->scalarInputCount,
                             data->structureInput, data->structureInputSize,
                             data->scalarOutput, &data->scalarOutputCount,
                             data->structureOutput, &data->structureOutputSize);
    [self krCheck:kr];
    [data dealloc];
}

-(void)stopQueue{
    [self stopQueue:[self createAQueue]];
}

-(void)stopQueue:(uint64_t)queue{
    kern_return_t   kr;
    if(!connect_state){
        NSLog(@"no connect");
        return;
    }
    DataBuild *data = [[DataBuild alloc] initWithCount:1 structureInSize:0 scalarOutCount:0 structureOutSize:0];
    data->scalarInput[0] = queue;
    kr = IOConnectCallMethod(connect,
                             9,
                             data->scalarInput, data->scalarInputCount,
                             data->structureInput, data->structureInputSize,
                             data->scalarOutput, &data->scalarOutputCount,
                             data->structureOutput, &data->structureOutputSize);
    [self krCheck:kr];
    [data dealloc];
}

-(void)updateElementValues{
    kern_return_t   kr;
    uint32_t        scalarInputCount;
    BOOL            end = false;
    int             count = 0;
    if(!connect_state){
        NSLog(@"no connect");
        return;
    }
    while(!end){
        for(scalarInputCount=0;scalarInputCount<16;scalarInputCount++){
            DataBuild *data = [[DataBuild alloc] initWithCount:scalarInputCount structureInSize:0 scalarOutCount:0 structureOutSize:0];
            data->scalarRange = 0x10000;
            [data buildScalarInput:1];
            kr = IOConnectCallMethod(connect,
                                     10,
                                     data->scalarInput, data->scalarInputCount,
                                     data->structureInput, data->structureInputSize,
                                     data->scalarOutput, &data->scalarOutputCount,
                                     data->structureOutput, &data->structureOutputSize);
            [self krCheck:kr];
            [data dealloc];
        }
        if(count++ > 1000)
            end = true;
    }
}

-(void)postElementValues{
    kern_return_t   kr;
    uint32_t        scalarInputCount;
    BOOL            end = false;
    int             count = 0;
    if(!connect_state){
        NSLog(@"no connect");
        return;
    }
    while(!end){
        for(scalarInputCount=0;scalarInputCount<ScalarMax;scalarInputCount++){
            DataBuild *data = [[DataBuild alloc] initWithCount:scalarInputCount structureInSize:0 scalarOutCount:0 structureOutSize:0];
            data->scalarRange = 0x10000;            //[0-16] : element index
            [data buildScalarInput:1];
            kr = IOConnectCallMethod(connect,
                                     11,
                                     data->scalarInput, data->scalarInputCount,
                                     data->structureInput, data->structureInputSize,
                                     data->scalarOutput, &data->scalarOutputCount,
                                     data->structureOutput, &data->structureOutputSize);
            [self krCheck:kr];
            [data dealloc];
        }
        if(count++ > 1000)
            end = true;
    }
}
-(void)setReport{
    kern_return_t   kr;
    size_t          structureInputDescriptorSize;
    BOOL            end = false;
    int             count = 0;
    uint32_t        reportType;
    if(!connect_state){
        NSLog(@"no connect");
        return;
    }
    /*using descriptor*/
    DataBuild *data = [[DataBuild alloc] initWithCount:3 structureInSize:0 scalarOutCount:0 structureOutSize:0];
    while(!end){
        reportType = arc4random()%4;
        data->scalarInput[0] = reportType;
        data->scalarInput[1] = arc4random()%0x1000;
        structureInputDescriptorSize = arc4random()%0x10000;
        [data changeSize:structureInputDescriptorSize structureOutDescriptorSize:0];
        [data buildDescriptor];         // property的构造
        kr = io_connect_method(connect, 12,
                               data->scalarInput, data->scalarInputCount,
                               data->structureInput, (uint32_t)data->structureInputSize,
                               data->structureInputDescriptor,data->structureInputDescriptorSize,
                               data->scalarOutput, &data->scalarOutputCount,
                               data->structureOutput, (uint32_t)&data->structureOutputSize,
                               data->structureOutputDescriptor,&data->structureOutputDescriptorSize);
        [self krCheck:kr];
        if(count>0x10000)
            end = true;
    }
    [data dealloc];
}

-(void)getReport{
    kern_return_t   kr;
    size_t          structurOutputDescriptorSize;
    BOOL            end = false;
    int             count = 0;
    uint32_t        reportType;
    if(!connect_state){
        NSLog(@"no connect");
        return;
    }
    /*using descriptor*/
    DataBuild *data = [[DataBuild alloc] initWithCount:3 structureInSize:0 scalarOutCount:0 structureOutSize:0];
    while(!end){
        reportType = arc4random()%4;
        data->scalarInput[0] = reportType;
        data->scalarInput[1] = arc4random()%0x1000;
        structurOutputDescriptorSize = arc4random()%0x10000;
        [data changeSize:0 structureOutDescriptorSize:structurOutputDescriptorSize];
        kr = io_connect_method(connect, 13,
                               data->scalarInput, data->scalarInputCount,
                               data->structureInput, (uint32_t)data->structureInputSize,
                               data->structureInputDescriptor,data->structureInputDescriptorSize,
                               data->scalarOutput, &data->scalarOutputCount,
                               data->structureOutput, (uint32_t)&data->structureOutputSize,
                               data->structureOutputDescriptor,&data->structureOutputDescriptorSize);
        [self krCheck:kr];
        if(count>0x10000)
            end = true;
    }
    [data dealloc];
}

-(void)getElementCount{
    kern_return_t   kr;
    if(!connect_state){
        NSLog(@"no connect");
        return;
    }
    DataBuild *data = [[DataBuild alloc] initWithCount:0 structureInSize:0 scalarOutCount:2 structureOutSize:0];
    kr = IOConnectCallMethod(connect,
                             14,
                             data->scalarInput, data->scalarInputCount,
                             data->structureInput, data->structureInputSize,
                             data->scalarOutput, &data->scalarOutputCount,
                             data->structureOutput, &data->structureOutputSize);
    [self krCheck:kr];
    [data dealloc];
}

-(void)getElements{
    kern_return_t   kr;
    size_t          structureOutputDescripterSize;
    BOOL            end = false;
    int             count = 0;
    if(!connect_state){
        NSLog(@"no connect");
        return;
    }
    DataBuild *data = [[DataBuild alloc] initWithCount:1 structureInSize:0 scalarOutCount:0 structureOutSize:0];
    while(!end){
        structureOutputDescripterSize = arc4random();
        [data changeSize:0 structureOutDescriptorSize:structureOutputDescripterSize];
        data->scalarInput[0] = (count%2==0)?1:0;
        kr = io_connect_method(connect, 15,
                               data->scalarInput, data->scalarInputCount,
                               data->structureInput, (uint32_t)data->structureInputSize,
                               data->structureInputDescriptor,data->structureInputDescriptorSize,
                               data->scalarOutput, &data->scalarOutputCount,
                               data->structureOutput, (uint32_t)&data->structureOutputSize,
                               data->structureOutputDescriptor,&data->structureOutputDescriptorSize);
        [self krCheck:kr];
        if(count>0x10000)
            end = true;
    }
    [data dealloc];
}

-(void)fuzzQueue{
    int i;//quque相关方法组合的fuzz
    SEL QueueMethod[] = {
        @selector(fuzzQueueCreateQueue),
        @selector(fuzzQueueDisposeQueue),
        @selector(fuzzQueueRemoveElementFromQueue),
        @selector(fuzzQueueAddElementToQueue),
        @selector(fuzzQueueStartQueue),
        @selector(fuzzQueueStopQueue)
    };
    _queue = [[Queue alloc] init];
    for(i=0;i<6;i++)
        [self performSelectorInBackground:QueueMethod[i] withObject:nil];       //调用起来，每个method分开跑
    free(_queue->theQueue);
}

-(void)addQueue:(uint64_t)queue{            //_quque要上锁
    @synchronized(_queue){
        _queue->theQueue = (uint64_t *)realloc(_queue->theQueue,sizeof(++_queue->queueCount));
        _queue->theQueue[_queue->queueCount-1] = queue;
    }
}

-(void)removeQueue:(uint64_t)queue{
    int i,flag = 0;
    if(_queue->queueCount<1)
        return;
    @synchronized(_queue){
        for(i=0;i<_queue->queueCount;i++){
            if(queue != _queue->theQueue[i])
                flag = 1;
            if(flag==1)
                _queue->theQueue[i] = _queue->theQueue[i+1];
        }
        _queue->theQueue = (uint64_t *)realloc(_queue->theQueue,sizeof(--_queue->queueCount));
    }
}

-(void)fuzzQueueCreateQueue{
    BOOL        end =false;
    int         count = 0;
    while(!end){
        [self createAQueue];
        if(count++>0x10000)
            end = true;
    }
    
}

-(void)fuzzQueueDisposeQueue{
    BOOL        end =false;
    int         count = 0;
    uint64_t    theQueue;
    if(_queue->queueCount<1)
        return;
    while(!end){
        theQueue = _queue->theQueue[arc4random()%_queue->queueCount];
        [self disposeQueue:theQueue];
        if(count++>0x10000)
            end = true;
    }
}

-(void)fuzzQueueAddElementToQueue{
    BOOL        end =false;
    int         count = 0;
    uint64_t    theQueue;
    if(_queue->queueCount<1)
        return;
    while(!end){
        theQueue = _queue->theQueue[arc4random()%_queue->queueCount];
        [self addElementToQueue:theQueue];
        if(count++>0x10000)
            end = true;
    }
}

-(void)fuzzQueueRemoveElementFromQueue{
    BOOL        end =false;
    int         count = 0;
    uint64_t    theQueue;
    if(_queue->queueCount<1)
        return;
    while(!end){
        theQueue = _queue->theQueue[arc4random()%_queue->queueCount];
        [self removeElementFromQueue:theQueue];
        if(count++>0x10000)
            end = true;
    }
    
}

-(void)fuzzQueueStartQueue{
    BOOL        end =false;
    int         count = 0;
    uint64_t    theQueue;
    if(_queue->queueCount<1)
        return;
    while(!end){
        theQueue = _queue->theQueue[arc4random()%_queue->queueCount];
        [self startQueue:theQueue];
        if(count++>0x10000)
            end = true;
    }
}

-(void)fuzzQueueStopQueue{
    BOOL        end =false;
    int         count = 0;
    uint64_t    theQueue;
    if(_queue->queueCount<1)
        return;
    while(!end){
        theQueue = _queue->theQueue[arc4random()%_queue->queueCount];
        [self stopQueue:theQueue];
        if(count++>0x10000)
            end = true;
    }
    
}
-(void)dealloc{
    [_queue dealloc];
    [super dealloc];
}
@end


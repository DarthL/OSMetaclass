//
//  DataBuild.m
//  fuzzFoundation
//
//  Created by dayyang on 15/8/6.
//
//

#import <Foundation/Foundation.h>
#import "DataBuild.h"
#import <IOKit/IOKitLib.h>
#import <UIKit/UIKit.h>
#import <IOKit/IOCFSerialize.h>
#import <IOKit/IOKitKeys.h>
@implementation DataBuild

static UInt8 gTelephonyButtonsDesc[] = {
    0x05, 0x0B,                               // Usage Page (Telephony Device)
    0x09, 0x01,                               // Usage 1 (0x1)
    0xA1, 0x01,                               // Collection (Application)
    0x05, 0x0B,                               //   Usage Page (Telephony Device)
    
    0x09, 0x21,                               //   Usage 33 (0x21)
    0x09, 0xB0,                               //   Usage 176 (0xb0)
    0x09, 0xB1,                               //   Usage 177 (0xb1)
    0x09, 0xB2,                               //   Usage 178 (0xb2)
    
    
    0x15, 0x00,                               //   Logical Minimum......... (0)
    0x25, 0x01,                               //   Logical Maximum......... (1)
    0x75, 0x01,                               //   Report Size............. (1)
    0x95, 0x0D,                               //   Report Count............ (13)
    0x81, 0x02,                               //   Input...................(Data, Variable, Absolute)
    0x75, 0x03,                               //   Report Size............. (3)
    0x95, 0x01,                               //   Report Count............ (1)
    0x81, 0x01,                               //   Input...................(Constant)
    0xC0,                                     // End Collection
};


-(id)initWithCount:(uint32_t)scalarIn
   structureInSize:(size_t)structureIn
    scalarOutCount:(uint32_t)scalarOut
  structureOutSize:(size_t)structureOut{
    // init the size
    scalarInputCount    = scalarIn;
    scalarOutputCount   = scalarOut;
    structureInputSize  = structureIn;
    structureOutputSize = structureOut;
    //malloc
    if(scalarInputCount)
        scalarInput     = malloc(scalarInputCount);
    if(structureInputSize)
        structureInput  = malloc(structureInput);
    if(scalarOutputCount)
        scalarOutput    = malloc(scalarOutputCount);
    if(structureOutputSize)
        structureOutput = malloc(structureOutputSize);
    countInitState = true;
    return self;
}

-(void)changeSize:(uint32_t)scalarIn
  structureInSize:(size_t)structureIn
   scalarOutCount:(uint32_t)scalarOut
 structureOutSize:(size_t)structureOut{
    if(scalarIn!=scalarInputCount&&scalarInput){
        scalarInput = realloc(scalarInput, scalarIn);
        scalarInputCount    = scalarIn;
    }
    if(structureIn!=structureInputSize&&structureInput){
        structureInput = realloc(structureInput,structureIn);
        structureInputSize  = structureIn;
    }
    if(scalarOut!=scalarOutputCount&&scalarOutput){
        scalarOutput = realloc(scalarOutput,scalarOut);
        scalarOutputCount   = scalarOut;
    }
    if(structureOut!=structureOutputSize&&structureOutput){
        structureOutput = realloc(structureOutput,structureOut);
        structureOutputSize = structureOut;
    }
}

-(void)changeSize:(mach_vm_size_t)descriptorIn
structureOutDescriptorSize:(mach_vm_size_t)descriptorOut{
    if(descriptorIn>0){
        if(!structureInputDescriptor)
            structureInputDescriptor = malloc(descriptorIn);
        else
            structureInputDescriptor = realloc(structureInputDescriptor,descriptorIn);
        structureInputDescriptorSize = descriptorIn;
    }
    if(descriptorOut>0){
        if(!structureOutputDescriptor)
            structureOutputDescriptor = malloc(descriptorIn);
        else
            structureOutputDescriptor = realloc(structureOutputDescriptor,descriptorOut);
        structureOutputDescriptorSize = descriptorOut;
    }
}

+(void)deviceCreateData:(void **)buffer andSize:(vm_size_t *)bufferSize{
    
    vm_size_t descriptorLength = sizeof(gTelephonyButtonsDesc);
    void      *descriptor      = (void *)malloc(descriptorLength);
    bcopy(gTelephonyButtonsDesc, descriptor, descriptorLength);
    
    CFMutableDictionaryRef properties = CFDictionaryCreateMutable(kCFAllocatorDefault, 0, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
    
    CFDataRef   descriptorData  = NULL;
    CFNumberRef timeoutNumber   = NULL;
    CFNumberRef intervalNumber  = NULL;
    uint32_t    value           = 5000000;
    uint32_t    reportinterval  = 5000;

    descriptorData = CFDataCreate(kCFAllocatorDefault, descriptor, descriptorLength);
    timeoutNumber = CFNumberCreate(kCFAllocatorDefault, kCFNumberSInt32Type, &value);
    intervalNumber = CFNumberCreate(kCFAllocatorDefault, kCFNumberSInt32Type, &reportinterval);
    
    
    CFDictionarySetValue(properties,CFSTR("ReportDescriptor"),descriptorData);
    CFDictionarySetValue(properties,CFSTR("RequestTimeout"),timeoutNumber);
    CFDictionarySetValue(properties,CFSTR("ReportInterval"),intervalNumber);
    
    CFDataRef data = IOCFSerialize(properties,0);
    *buffer = (UInt8 *)CFDataGetBytePtr(data);
    *bufferSize = CFDataGetLength(data);

}

-(uint64_t)getScalarRandom:(int)type{  //remain to complete
    switch(type){
        case 0:    return  (arc4random()%2==0)?(arc4random()%0x7fffffff+0x80000000):(arc4random()%0x7fffffff);break;
        case 1:    return  (arc4random()%scalarRange);
        default:   return   0;
    }
}

-(void)buildScalarInput:(int)type{
    uint32_t i;
    if(!scalarInput){
        if((scalarInput = (uint64_t *)malloc(scalarInputCount*sizeof(uint64_t))) == nil){
            NSLog(@"memory fail");
            return;
        }
    }
    for(i=0;i<scalarInputCount;i++)
        scalarInput[i] = [self getScalarRandom:type];
}

-(void)buildStructureInput{
    if(!structureInput&&structureInputSize){
        if((structureInput = (void *)malloc(structureInputSize)) == nil){
            NSLog(@"memory fail");
            return;
        }
    }
    memset(structureInput,0,structureInputSize);
    arc4random_buf(structureInput, structureInputSize);
}

-(void)buildStructureInput_property{
    
}

-(void)buildDescriptor{
}           //remain to complete

-(void)dataRelease{
    if(scalarInput)
        free(scalarInput);
    if(scalarOutput)
        free(scalarOutput);
    if(structureOutput)
        free(structureOutput);
    if(structureInput)
        free(structureInput);
    if(structureInputDescriptor)
        free(structureInputDescriptor);
    if(structureOutputDescriptor)
        free(structureOutputDescriptor);
    scalarInput = nil;
    scalarOutput = nil;
    structureOutput = nil;
    structureInput = nil;
    structureOutputDescriptor = nil;
    structureInputDescriptor = nil;
    structureOutputDescriptorSize = 0;
    structureInputDescriptorSize = 0;
    scalarInputCount    = 0;
    scalarOutputCount   = 0;
    structureInputSize  = 0;
    structureOutputSize = 0;
    
}

-(void)dealloc{
    [self dataRelease];
    [super dealloc];
}
@end
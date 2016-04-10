//
//  DataBuild.h
//  fuzzFoundation
//
//  Created by dayyang on 15/8/6.
//
//
#import <Foundation/Foundation.h>
@interface DataBuild : NSObject{
@public
    uint64_t            *scalarInput;
    uint32_t            scalarInputCount;
    void                *structureInput;
    size_t              structureInputSize;
    uint64_t            *scalarOutput;
    uint32_t            scalarOutputCount;
    void                *structureOutput;
    size_t              structureOutputSize;
    uint32_t            asyncWackPort;
    uint64_t            asyncReferenceCount;
    mach_vm_address_t   *structureOutputDescriptor;
    mach_vm_size_t      structureOutputDescriptorSize;
    mach_vm_address_t   *structureInputDescriptor;
    mach_vm_size_t      structureInputDescriptorSize;
    int                 scalarRange;
@private
    bool countInitState;
    
}

-(id)initWithCount:(uint32_t)scalarIn
   structureInSize:(size_t)structureIn
    scalarOutCount:(uint32_t)scalarOut
  structureOutSize:(size_t)structureOut;

-(void)buildScalarInput:(int)type;          //commen data
-(void)buildStructureInput;                 //commen data
-(void)dataRelease;
-(void)buildStructureInput_property;
-(void)buildDescriptor;

-(void)changeSize:(uint32_t)scalarIn
  structureInSize:(size_t)structureIn
   scalarOutCount:(uint32_t)scalarOut
 structureOutSize:(size_t)structureOut;     //commen data

-(void)changeSize:(mach_vm_size_t)descriptorIn
    structureOutDescriptorSize:(mach_vm_size_t)descriptorOut;//descriptor

-(uint64_t)getScalarRandom:(int)type;
+(void)deviceCreateData:(void **)buffer andSize:(vm_size_t *)bufferSize;

@end
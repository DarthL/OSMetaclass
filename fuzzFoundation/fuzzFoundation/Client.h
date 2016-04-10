//
//  Client.h
//  fuzzFoundation
//
//  Created by dayyang on 15/8/6.
//
//


#import <Foundation/Foundation.h>
#import <IOKit/IOTypes.h>

kern_return_t io_connect_method
(
 mach_port_t connection,
 uint32_t selector,
 io_scalar_inband64_t input,
 mach_msg_type_number_t inputCnt,
 io_struct_inband_t inband_input,
 mach_msg_type_number_t inband_inputCnt,
 mach_vm_address_t ool_input,
 mach_vm_size_t  ool_input_size __unused,
 io_scalar_inband64_t output,
 mach_msg_type_number_t *outputCnt,
 io_struct_inband_t inband_output,
 mach_msg_type_number_t *inband_outputCnt,
 mach_vm_address_t ool_output,
 mach_vm_size_t * ool_output_size __unused
 );

@interface Client : NSObject{
    @public
    io_connect_t    connect;
    BOOL            connect_state;
    SEL             *fuzzMethod;
    uint32_t        methondNumber;
    NSString        *serviceName;
}
-(BOOL)connectCient;
@end
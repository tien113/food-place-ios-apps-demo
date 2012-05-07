//
//  MacAddress.m
//  MacAddress
//
//  Created by vo on 5/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MacAddress.h"

#include <sys/socket.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>

@implementation MacAddress

+ (NSString *)getMacAddress {
    
    int                  mgmtInfoBase[6];
    char                 *msgBuffer = NULL;
    NSString             *errorFlag = NULL;
    size_t               length;
    
    mgmtInfoBase[0] = CTL_NET;
    mgmtInfoBase[1] = AF_ROUTE;
    mgmtInfoBase[2] = 0;
    mgmtInfoBase[3] = AF_LINK;
    mgmtInfoBase[4] = NET_RT_IFLIST;
    
    if ((mgmtInfoBase[5] = if_nametoindex("en0")) == 0) 
        errorFlag = @"if_nametoindex failure";
    
    else if (sysctl(mgmtInfoBase, 6, NULL, &length, NULL, 0) < 0) 
        errorFlag = @"sysctl mgmInfoBase failure";
    
    else if ((msgBuffer = malloc(length)) == NULL) 
        errorFlag = @"buffer allocation failure";
    
    else if (sysctl(mgmtInfoBase, 6, msgBuffer, &length, NULL, 0) < 0) { 
        free(msgBuffer);
        errorFlag = @"sysctl msgBuffer failure";
    }
    
    if (errorFlag != NULL) {
        NSLog(@"Error: %@", errorFlag);
        return errorFlag;
    }
    
    struct if_msghdr *interfaceMsgStruct = (struct if_msghdr *)msgBuffer;
    
    struct sockaddr_dl *socketStruct = (struct sockaddr_dl *)(interfaceMsgStruct + 1);
    
    unsigned char macAddress[6];
    
    memcpy(&macAddress, socketStruct->sdl_data + socketStruct->sdl_nlen, 6);
    
    NSString *macAddressString = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X", 
                                  macAddress[0], macAddress[1], macAddress[2], 
                                  macAddress[3], macAddress[4], macAddress[5]];
    NSLog(@"Mac Address: %@", macAddressString);
    
    free(msgBuffer);
    
    return macAddressString;
}

@end

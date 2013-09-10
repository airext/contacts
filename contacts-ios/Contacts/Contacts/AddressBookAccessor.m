//
//  AddressBookAccessManager.m
//  Contacts
//
//  Created by Maxim on 9/9/13.
//  Copyright (c) 2013 Max Rozdobudko. All rights reserved.
//

#import "AddressBookAccessor.h"

@implementation AddressBookAccessor

#pragma mark Main methods

+(BOOL) isAvailable:(ABAuthorizationStatus)status
{
    return status == kABAuthorizationStatusAuthorized || status == kABAuthorizationStatusRestricted;
}

+(void) request:(AddressBookRequestHandler)handler
{
    ABAddressBookRef addressBook = NULL;
    
    if ([self isIOS6])
    {
        CFErrorRef * error = nil;
        
        addressBook = ABAddressBookCreateWithOptions(nil, error);
        
        if (error != nil)
        {
            handler(nil, false);
        }
        else
        {
            ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();
            
            if (status == kABAuthorizationStatusNotDetermined)
            {
                ABAddressBookRequestAccessWithCompletion(addressBook,
                ^(bool granted, CFErrorRef error)
                {
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                    ^(void)
                    {
                        handler(addressBook, [self isAvailable:status]);

                        CFRelease(addressBook);
                    });
                });
            }
            else
            {
                handler(addressBook, [self isAvailable:status]);
                
                if (addressBook != nil)
                {
                    CFRelease(addressBook);
                }
            }
        }
    }
    else
    {
        addressBook = ABAddressBookCreate();
        
        handler(addressBook, TRUE);
        
        CFRelease(addressBook);
    }
}

#pragma mark Util methods

+( BOOL ) isIOS6
{
    float currentVersion = 6.0;
    return [[[UIDevice currentDevice] systemVersion] floatValue] >= currentVersion;
}

@end

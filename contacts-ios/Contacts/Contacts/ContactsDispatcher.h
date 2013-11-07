//
//  ContactsConversionRoutines.h
//  Contacts
//
//  Created by Maxim on 9/11/13.
//  Copyright (c) 2013 Max Rozdobudko. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FlashRuntimeExtensions.h"

@interface ContactsDispatcher : NSObject

@end

#pragma mark C Interface
     
void Contacts_dispatchErrorEvent(FREContext context, NSString* code);
void Contacts_dispatchStatusEvent(FREContext context, NSString* code);
void Contacts_dispatchResponseEvent(FREContext context, NSUInteger callId, NSString* status, NSString* method, NSString* data);
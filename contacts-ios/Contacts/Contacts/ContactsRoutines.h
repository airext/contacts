//
//  ContactsConversionRoutines.h
//  Contacts
//
//  Created by Maxim on 9/11/13.
//  Copyright (c) 2013 Max Rozdobudko. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FlashRuntimeExtensions.h"

@interface ContactsRoutines : NSObject

@end

#pragma mark C Interface
     
void dispatchErrorEvent(FREContext context, NSString* code);
void dispatchStatusEvent(FREContext context, NSString* code);
void dispatchResponseEvent(FREContext context, NSUInteger callId, NSString* status, NSString* method);

FREObject personToContact(NSDictionary* person);

FREObject peopleToContacts(NSArray* people);

NSRange convertToNSRange(FREObject source);
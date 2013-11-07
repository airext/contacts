//
//  Contacts.h
//  Contacts
//
//  Created by Maxim on 9/9/13.
//  Copyright (c) 2013 Max Rozdobudko. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FlashRuntimeExtensions.h"

#import "AddressBookAccessor.h"
#import "AddressBookProvider.h"

@interface Contacts : NSObject
{
    NSUInteger currentCallId;
    
    NSMutableDictionary* resultStorage;
    
    ABAddressBookRef addressBookForChangeCallback;
}

#pragma mark Shared Instance

+(Contacts*) sharedInstance;

#pragma mark Properties

@property FREContext context;

#pragma mark ANE methods

-(BOOL) isSupported;

#pragma mark Synchronous methods

-(BOOL) isModified:(NSDate*) since;
-(FREObject) getContactCount;
-(FREObject) getContacts:(NSRange) range;
-(FREObject) getContacts:(NSRange) range withOptions:(NSDictionary*) options;

-(BOOL) updateContact:(FREObject) contact;
-(NSData*) getContactThumbnail:(NSInteger) recordId;

#pragma mark Asyncronous methods

-(NSUInteger) isModifiedAsync:(NSDate*) since;
-(NSUInteger) getContactCountAsync;
-(NSUInteger) getContactsAsync:(NSRange) range;
-(NSUInteger) getContactsAsync:(NSRange) range withOptions:(NSDictionary*) options;

-(NSUInteger) updateContactAsync:(FREObject) contact;

#pragma mark Utilities

-(NSUInteger) getNextCallId;

#pragma mark Callbacks

-(void) registerChangeCallback;
-(void) unregisterChangeCallback;

#pragma mark C Interface

void externalChangeCallback(ABAddressBookRef addressBook, CFDictionaryRef info, void* context);

@end

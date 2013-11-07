//
//  Contacts.m
//  Contacts
//
//  Created by Maxim on 9/9/13.
//  Copyright (c) 2013 Max Rozdobudko. All rights reserved.
//

#import <mach/mach_time.h>

#import "FlashRuntimeExtensions.h"

#import "Contacts_FRETypeConversion.h"

#import "AddressBookAccessor.h"
#import "AddressBookProvider.h"

#import "Contacts.h"
#import "ContactsDispatcher.h"
#import "AddressBookProviderUpdateRoutines.h"

@implementation Contacts

#pragma mark Shared Instance

static Contacts* _sharedInstance = nil;

+(Contacts*) sharedInstance
{
    if (_sharedInstance == nil)
    {
        _sharedInstance = [[super allocWithZone:NULL] init];
    }
    
    return _sharedInstance;
}

#pragma mark Properties

@synthesize context;

#pragma mark ANE methods

-(BOOL) isSupported
{
    return TRUE;
}

#pragma mark Synchronous methods

-(BOOL) isModified:(NSDate*) since
{
    __block BOOL result = FALSE;
    
    [[AddressBookAccessor sharedInstance] request:^(ABAddressBookRef addressBook, BOOL available)
     {
         if (available)
         {
             AddressBookProvider* provider = [[AddressBookProvider alloc] init];
             
             [provider setAddressBook:addressBook];
             
             result = [provider isModified:since];
         }
         else
         {
             Contacts_dispatchErrorEvent(self.context, @"Contacts.IsModified.Failed");
         }
     }];
    
    return result;
}

-(FREObject) getContacts:(NSRange) range
{
    return [self getContacts:range withOptions:NULL];
}

-(FREObject) getContacts:(NSRange) range withOptions:(NSDictionary*) options
{
    __block FREObject result = NULL;
    
    [[AddressBookAccessor sharedInstance] request:^(ABAddressBookRef addressBook, BOOL available)
     {
         if (available)
         {
             AddressBookProvider* provider = [[AddressBookProvider alloc] init];
             
             provider.addressBook = addressBook;
             
             result = [provider getContactsAsFRE:range withOptions:options];
         }
         else
         {
             Contacts_dispatchErrorEvent(self.context, @"Contacts.GetContacts.Failed");
         }
     }];
    
    return result;
}

-(FREObject) getContactCount
{
    __block FREObject result = NULL;
    
    [[AddressBookAccessor sharedInstance] request:^(ABAddressBookRef addressBook, BOOL available)
     {
         if (available)
         {
             AddressBookProvider* provider = [[AddressBookProvider alloc] init];
             
             provider.addressBook = addressBook;
             
             result = [provider getContactCountAsFRE];
         }
         else
         {
             Contacts_dispatchErrorEvent(self.context, @"Contacts.GetContactCount.Failed");
         }
     }];
    
    return result;
}

-(BOOL) updateContact:(FREObject) contact
{
    __block BOOL result = FALSE;
    
    [[AddressBookAccessor sharedInstance] request:^(ABAddressBookRef addressBook, BOOL available)
     {
         if (available)
         {
             AddressBookProvider* provider = [[AddressBookProvider alloc] init];
             
             provider.addressBook = addressBook;
             
             result = [provider updateContactWithOptions:contact withOptions:NULL];
         }
         else
         {
             Contacts_dispatchErrorEvent(self.context, @"Contacts.UpdateContact.Failed");
         }
     }];
    
    return result;
}

-(NSData*) getContactThumbnail:(NSInteger) recordId
{
    __block NSData* result;
    
    [[AddressBookAccessor sharedInstance] request:^(ABAddressBookRef addressBook, BOOL available)
     {
         if (available)
         {
             AddressBookProvider* provider = [[AddressBookProvider alloc] init];
             
             provider.addressBook = addressBook;
             
             result = [provider getPersonThumbnail:recordId];
         }
         else
         {
             Contacts_dispatchErrorEvent(self.context, @"Contacts.GetContactThumbnail.Failed");
         }
     }];
    
    return result;
}

#pragma mark Asynchronous methods

-(NSUInteger) isModifiedAsync:(NSDate*) since
{
    NSUInteger callId = [self getNextCallId];
    
    __block BOOL result = FALSE;
    
    [[AddressBookAccessor sharedInstance] request:^(ABAddressBookRef addressBook, BOOL available)
    {
        if (available)
        {
            AddressBookProvider* provider = [[AddressBookProvider alloc] init];
             
            [provider setAddressBook:addressBook];
             
            result = [provider isModified:since];
             
            dispatch_async(dispatch_get_main_queue(),
            ^(void)
            {
                Contacts_dispatchResponseEvent(self.context, callId, @"result", @"isModifiedAsync", result ? @"true" : @"false");
            });
        }
        else
        {
            Contacts_dispatchErrorEvent(self.context, @"Contacts.IsModified.Failed");
        }
     }];
    
    return callId;
}

-(NSUInteger) getContactsAsync:(NSRange) range
{
    return [self getContactsAsync:range withOptions:NULL];
}

-(NSUInteger) getContactsAsync:(NSRange) range withOptions:(NSDictionary*) options
{
    NSUInteger callId = [self getNextCallId];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
    ^{
        [[AddressBookAccessor sharedInstance] request: ^(ABAddressBookRef addressBook, BOOL available)
        {
            if (available)
            {
                AddressBookProvider* provider = [[AddressBookProvider alloc] init];
                
                provider.addressBook = addressBook;

                NSString* result = [provider getContactsAsJSON:range withOptions:options];
                
                dispatch_async(dispatch_get_main_queue(),
                ^(void)
                {
                    Contacts_dispatchResponseEvent(self.context, callId, @"result", @"getContactsAsync", result);
                });
            }
            else
            {
                Contacts_dispatchErrorEvent(self.context, @"Contacts.GetContacts.Failed");
            }
        }];
    });
    
    return callId;
}

-(NSUInteger) getContactCountAsync
{
    NSUInteger callId = [self getNextCallId];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
    ^{
        [[AddressBookAccessor sharedInstance] request: ^(ABAddressBookRef addressBook, BOOL available)
        {
            if (available)
            {
                AddressBookProvider* provider = [[AddressBookProvider alloc] init];
                 
                provider.addressBook = addressBook;
                 
                NSString* result = [provider getContactCountAsString];
                 
                dispatch_async(dispatch_get_main_queue(),
                ^(void)
                {
                    Contacts_dispatchResponseEvent(self.context, callId, @"result", @"getContactCountAsync", result);
                });
            }
            else
            {
                Contacts_dispatchErrorEvent(self.context, @"Contacts.GetContactCount.Failed");
            }
        }];
    });
    
    return callId;
}

-(NSUInteger) updateContactAsync:(FREObject) contact
{
    NSUInteger callId = [self getNextCallId];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
    ^{
        [[AddressBookAccessor sharedInstance] request: ^(ABAddressBookRef addressBook, BOOL available)
        {
            if (available)
            {
                AddressBookProvider* provider = [[AddressBookProvider alloc] init];
                 
                provider.addressBook = addressBook;
                 
                BOOL result = [provider updateContactWithOptions:contact withOptions:NULL];
                 
                dispatch_async(dispatch_get_main_queue(),
                ^(void)
                {
                    Contacts_dispatchResponseEvent(self.context, callId, @"result", @"updateContactAsync", result ? @"true" : @"false");
                });
            }
            else
            {
                Contacts_dispatchErrorEvent(self.context, @"Contacts.UpdateContact.Failed");
            }
        }];
    });
    
    return callId;
}

#pragma mark Utilities

-(NSUInteger) getNextCallId
{
    if (currentCallId == NSUIntegerMax)
        currentCallId = 0;
    else
        currentCallId++;
    
    return currentCallId;
}

#pragma mark Callbacks

-(void) registerChangeCallback
{
    if (addressBookForChangeCallback)
    {
        [self unregisterChangeCallback];
    }
    
    CFErrorRef error = nil;
    
    addressBookForChangeCallback = ABAddressBookCreateWithOptions(nil, &error);
    
    if (error == NULL)
    {
        ABAddressBookRegisterExternalChangeCallback(addressBookForChangeCallback, externalChangeCallback, (__bridge void *)(self));
    }
}

-(void) unregisterChangeCallback
{
    if (addressBookForChangeCallback)
    {
        ABAddressBookUnregisterExternalChangeCallback(addressBookForChangeCallback, externalChangeCallback, (__bridge void *)(self));

        addressBookForChangeCallback = nil;
    }
}

@end

#pragma mark C Interface

void externalChangeCallback(ABAddressBookRef addressBook, CFDictionaryRef info, void* context)
{
    ABAddressBookRevert(addressBook);
    
    Contacts_dispatchStatusEvent([Contacts sharedInstance].context, @"Contacts.AddressBook.Change");
}

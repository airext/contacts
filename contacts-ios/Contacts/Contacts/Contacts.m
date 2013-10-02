//
//  Contacts.m
//  Contacts
//
//  Created by Maxim on 9/9/13.
//  Copyright (c) 2013 Max Rozdobudko. All rights reserved.
//

#import <mach/mach_time.h>

#import "FlashRuntimeExtensions.h"

#import "FRETypeConversion.h"

#import "AddressBookAccessor.h"
#import "AddressBookProvider.h"

#import "Contacts.h"
#import "ContactsRoutines.h"
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
             dispatchErrorEvent(self.context, @"Contacts.IsModified.Failed");
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
             dispatchErrorEvent(self.context, @"Contacts.GetContacts.Failed");
         }
     }];
    
    return result;
}

-(NSInteger) getContactCount
{
    __block NSInteger result = -1;
    
    [[AddressBookAccessor sharedInstance] request:^(ABAddressBookRef addressBook, BOOL available)
     {
         if (available)
         {
             AddressBookProvider* provider = [[AddressBookProvider alloc] init];
             
             provider.addressBook = addressBook;
             
             result = [provider getPersonCount];
         }
         else
         {
             dispatchErrorEvent(self.context, @"Contacts.GetContactCount.Failed");
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
                [self holdAsyncCallResult:[NSNumber numberWithBool:result] forCallId:callId];
                                
                dispatchResponseEvent(self.context, callId, @"result", @"isModifiedAsync", nil);
                                
                dispatchStatusEvent(self.context, @"Contacts.IsModified.Result");
            });
        }
        else
        {
            dispatchErrorEvent(self.context, @"Contacts.IsModified.Failed");
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
                    [self holdAsyncCallResult:result forCallId:callId];
                    
                    dispatchResponseEvent(self.context, callId, @"result", @"getContactsAsync", result);
                                   
                    dispatchStatusEvent(self.context, @"Contacts.GetContacts.Result");
                });
            }
            else
            {
                dispatchErrorEvent(self.context, @"Contacts.GetContacts.Failed");
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
                 
                NSInteger result = [provider getPersonCount];
                 
                dispatch_async(dispatch_get_main_queue(),
                ^(void)
                {
                    [self holdAsyncCallResult:[NSNumber numberWithInteger:result] forCallId:callId];
                                    
                    dispatchResponseEvent(self.context, callId, @"result", @"getContactCountAsync", nil);
                                    
                    dispatchStatusEvent(self.context, @"Contacts.GetContactCount.Result");
                });
            }
            else
            {
                dispatchErrorEvent(self.context, @"Contacts.GetContactCount.Failed");
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
                    [self holdAsyncCallResult:[NSNumber numberWithInteger:result] forCallId:callId];
                    
                    dispatchResponseEvent(self.context, callId, @"result", @"updateContactAsync", nil);
                                    
                    dispatchStatusEvent(self.context, @"Contacts.GetContactCount.Result");
                });
            }
            else
            {
                dispatchErrorEvent(self.context, @"Contacts.UpdateContact.Failed");
            }
        }];
    });
    
    return callId;
}

#pragma mark Asynchronous result methods

-(NSUInteger) getNextCallId
{
    if (currentCallId == NSUIntegerMax)
        currentCallId = 0;
    else
        currentCallId++;
    
    return currentCallId;
}

-(void) holdAsyncCallResult:(NSObject*) result forCallId:(NSUInteger) callId
{
    if (resultStorage == nil)
        resultStorage = [NSMutableDictionary dictionary];
    
    [resultStorage setValue:result forKey:[NSString stringWithFormat:@"%i", callId]];
}

-(BOOL) pickIsModifiedResult:(NSUInteger) callId
{
    if (resultStorage == nil)
        return FALSE;
    
    NSString* key = [NSString stringWithFormat:@"%i", callId];
    
    NSNumber* result = [resultStorage objectForKey:key];
    
    if (result)
    {
        [resultStorage removeObjectForKey:key];
        
        return [result boolValue];
    }
    
    return FALSE;
}

-(NSString*) pickGetContactsResult:(NSUInteger) callId
{
    if (resultStorage == nil)
        return nil;
    
    NSString* key = [NSString stringWithFormat:@"%i", callId];
    
    NSString* result = [resultStorage objectForKey:key];
    
    if (result)
    {
        [resultStorage removeObjectForKey:key];
    }
    
    return result;
}

-(NSInteger) pickGetContactCountResult:(NSUInteger) callId
{
    if (resultStorage == nil)
        return -1;
    
    NSString* key = [NSString stringWithFormat:@"%i", callId];
    
    NSNumber* result = [resultStorage objectForKey:key];
    
    if (result)
    {
        [resultStorage removeObjectForKey:key];
        
        return [result integerValue];
    }
    
    return -1;
}

#pragma mark Modification data

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
             dispatchErrorEvent(self.context, @"Contacts.UpdateContact.Failed");
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
             dispatchErrorEvent(self.context, @"Contacts.GetContactThumbnail.Failed");
         }
     }];
    
    return result;
}

-(BOOL) setProperty:(NSInteger) recordId forName:(NSString*) name withValue:(NSString*) value
{
    return FALSE;
}

-(BOOL) setProperties:(NSInteger) recordId forNames:(NSArray*) names withValues:(NSArray*) values
{
    return FALSE;
}

-(NSDictionary*) getProperty:(NSInteger) recordId forName:(NSString*) name
{
    return NULL;
}

-(NSDictionary*) getProperties:(NSInteger) recordId forNames:(NSArray*) names
{
    return NULL;
}

#pragma mark Internal methods

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
    
    dispatchStatusEvent([Contacts sharedInstance].context, @"Contacts.AddressBook.Change");
}

#pragma mark FRE Synchronous functions

FREObject isSupported(FREContext context, void* functionData, uint32_t argc, FREObject argv[])
{
    FREObject result = NULL;
    
    FRENewObjectFromBool([[Contacts sharedInstance] isSupported], &result);
    
    return result;
}

FREObject isModified(FREContext context, void* functionData, uint32_t argc, FREObject argv[])
{
    FREObject result = NULL;
    
    double time = 0;
    
    if (FREGetObjectAsDouble(argv[0], &time) == FRE_OK)
    {
        NSDate* since = [NSDate dateWithTimeIntervalSince1970:(NSTimeInterval)time];
        
        FRENewObjectFromBool([[Contacts sharedInstance] isModified:since], &result);
    }
    
    return result;
}

FREObject getContacts(FREContext context, void* functionData, uint32_t argc, FREObject argv[])
{  
    NSRange range = convertToNSRange(argv[0]);
    
    return [[Contacts sharedInstance] getContacts:range];
}

FREObject getContactCount(FREContext context, void* functionData, uint32_t argc, FREObject argv[])
{
    FREObject result;
    
    FRENewObjectFromInt32((int32_t) [[Contacts sharedInstance] getContactCount], &result);
    
    return result;
}

#pragma mark FRE Asynchronous functions

FREObject isModifiedAsync(FREContext context, void* functionData, uint32_t argc, FREObject argv[])
{
    FREObject result;
    
    double time = 0;
    
    FREGetObjectAsDouble(argv[0], &time);
    
    NSDate* since = [NSDate dateWithTimeIntervalSince1970:(NSTimeInterval)time];
    
    FRENewObjectFromUint32((uint32_t) [[Contacts sharedInstance] isModifiedAsync:since], &result);
    
    return result;
}

FREObject pickIsModifiedResult(FREContext context, void* functionData, uint32_t argc, FREObject argv[])
{
    FREObject result;
    
    uint32_t callId;
    
    FREGetObjectAsUint32(argv[0], &callId);
    
    FRENewObjectFromBool((uint32_t) [[Contacts sharedInstance] pickIsModifiedResult:callId], &result);
                          
    return result;
}

FREObject getContactCountAsync(FREContext context, void* functionData, uint32_t argc, FREObject argv[])
{
    FREObject result;
    
    FRENewObjectFromUint32((uint32_t) [[Contacts sharedInstance] getContactCountAsync], &result);
    
    return result;
}

FREObject pickGetContactCountResult(FREContext context, void* functionData, uint32_t argc, FREObject argv[])
{
    FREObject result;
    
    uint32_t callId;
    FREGetObjectAsUint32(argv[0], &callId);
    
    FRENewObjectFromInt32([[Contacts sharedInstance] pickGetContactCountResult:callId], &result);
    
    return result;
}

FREObject getContactsAsync(FREContext context, void* functionData, uint32_t argc, FREObject argv[])
{
    FREObject result;
    
    NSRange range = convertToNSRange(argv[0]);
    
    if (argc == 1)
    {
        FRENewObjectFromUint32((uint32_t) [[Contacts sharedInstance] getContactsAsync:range], &result);
    }
    else
    {
        FRENewObjectFromUint32((uint32_t) [[Contacts sharedInstance] getContactsAsync:range withOptions:nil], &result);
    }
    
    return result;
}

FREObject pickGetContactsResult(FREContext context, void* functionData, uint32_t argc, FREObject argv[])
{
    FREObject result;
    
    uint64_t start;
    uint64_t end;
    uint64_t elapsed;
    
    start = mach_absolute_time();
    
    uint32_t callId;
    
    FREGetObjectAsUint32(argv[0], &callId);
    
    NSString* json = [[Contacts sharedInstance] pickGetContactsResult: callId];

    [FRETypeConversion convertNSStringToFREString:json asString:&result];
    
    end = mach_absolute_time();
    
    elapsed = end - start;
    
    static mach_timebase_info_data_t info;
    
    mach_timebase_info(&info);
    
    uint64_t nanoseconds = elapsed * info.numer / info.denom;
    
    NSLog(@"Contacts.pickGetContactsResult: before %llu, after %llu, time elapsed was: %llu", start, end, nanoseconds);
    
    return result;
}

FREObject updateContact(FREContext context, void* functionData, uint32_t argc, FREObject argv[])
{
    FREObject result = NULL;

    FRENewObjectFromBool([[Contacts sharedInstance] updateContact:argv[0]], &result);
    
//    AddressBookProviderUpdateRoutines* routines = [AddressBookProviderUpdateRoutines new];
//    
//    [routines updateContactWithOptions:argv[0] withOptions:NULL];
    
    return result;
}

FREObject getContactThumbnail(FREContext context, void* functionData, uint32_t argc, FREObject argv[])
{
    FREObject result = NULL;
    
    int32_t recordId;
    
    FREGetObjectAsInt32(argv[0], &recordId);
    
    NSData* data = [[Contacts sharedInstance] getContactThumbnail:recordId];
    
    if (data != NULL)
    {
        [FRETypeConversion convertNSDataToFREBitmapData:data asBitmapData:&result];
    }
    
    return result;
}

#pragma mark ContextInitialize/ContextFinalizer

void ContactsContextInitializer(void* extData, const uint8_t* ctxType, FREContext ctx, uint32_t* numFunctionsToTest, const FRENamedFunction** functionsToSet)
{
    *numFunctionsToTest = 12;
    
    FRENamedFunction* func = (FRENamedFunction*) malloc(sizeof(FRENamedFunction) * (*numFunctionsToTest));
    
    func[0].name = (const uint8_t*) "isSupported";
    func[0].functionData = NULL;
    func[0].function = &isSupported;
    
    func[1].name = (const uint8_t*) "isModified";
    func[1].functionData = NULL;
    func[1].function = &isModified;
    
    func[2].name = (const uint8_t*) "getContacts";
    func[2].functionData = NULL;
    func[2].function = &getContacts;
    
    func[3].name = (const uint8_t*) "getContactCount";
    func[3].functionData = NULL;
    func[3].function = &getContactCount;
    
    func[4].name = (const uint8_t*) "isModifiedAsync";
    func[4].functionData = NULL;
    func[4].function = &isModifiedAsync;
    
    func[5].name = (const uint8_t*) "pickIsModifiedResult";
    func[5].functionData = NULL;
    func[5].function = &pickIsModifiedResult;
    
    func[6].name = (const uint8_t*) "getContactsAsync";
    func[6].functionData = NULL;
    func[6].function = &getContactsAsync;
    
    func[7].name = (const uint8_t*) "pickGetContactsResult";
    func[7].functionData = NULL;
    func[7].function = &pickGetContactsResult;
    
    func[8].name = (const uint8_t*) "getContactCountAsync";
    func[8].functionData = NULL;
    func[8].function = &getContactCountAsync;
    
    func[9].name = (const uint8_t*) "pickGetContactCountResult";
    func[9].functionData = NULL;
    func[9].function = &pickGetContactCountResult;
    
    func[10].name = (const uint8_t*) "updateContact";
    func[10].functionData = NULL;
    func[10].function = &updateContact;
    
    func[11].name = (const uint8_t*) "getContactThumbnail";
    func[11].functionData = NULL;
    func[11].function = &getContactThumbnail;
    
    *functionsToSet = func;
    
    [Contacts sharedInstance].context = ctx;
    
    [[Contacts sharedInstance] registerChangeCallback];
}

void ContactsContextFinalizer(FREContext ctx)
{
    [[Contacts sharedInstance] unregisterChangeCallback];
    
    [Contacts sharedInstance].context = nil;
}

#pragma mark Initializer/Finalizer

void ContactsInitializer(void** extDataToSet, FREContextInitializer* ctxInitializerToSet, FREContextFinalizer* ctxFinalizerToSet)
{
    *extDataToSet = NULL;
    
    *ctxInitializerToSet = &ContactsContextInitializer;
	*ctxFinalizerToSet = &ContactsContextFinalizer;
}

void ContactsFinalizer(void* extData)
{
    
}


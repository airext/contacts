//
//  Contacts.m
//  Contacts
//
//  Created by Maxim on 9/9/13.
//  Copyright (c) 2013 Max Rozdobudko. All rights reserved.
//

#import "FlashRuntimeExtensions.h"

#import "AddressBookAccessor.h"
#import "AddressBookProvider.h"

#import "Contacts.h"
#import "ContactsRoutines.h"

@implementation Contacts

#pragma mark Instantiation methods

static Contacts* _sharedInstance = nil;

+(Contacts*) sharedInstance
{
    if (_sharedInstance == nil)
    {
        _sharedInstance = [[super allocWithZone:NULL] init];
    }
    
    return _sharedInstance;
}

#pragma mark ANE methods

-(BOOL) isSupported
{
    return TRUE;
}

#pragma mark Asynchronous wrappers

-(void) isModifiedAsync:(NSDate*) since
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
    ^(void)
    {
        BOOL result = [self isModified:since];
            
        dispatch_async(dispatch_get_main_queue(),
        ^(void)
        {
            NSLog(@"isModifiedAsync=%i", result);
            
            // notify AIR
        });
    });
}

-(void) getContactsAsync:(NSRange) range
{
    [self getContactsAsync:range withOptions:NULL];
}

-(void) getContactsAsync:(NSRange) range withOptions:(NSDictionary*) options
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
    ^(void)
    {
        NSArray* result = [self getContacts:range withOptions:options];
                       
        dispatch_async(dispatch_get_main_queue(),
        ^(void)
        {
            NSLog(@"getContactsAsync=%@", result);
            
            // notify AIR
        });
    });
}

-(void) updateContactAsync:(NSDictionary*) contact
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
    ^(void)
    {
        BOOL result = [self updateContact:contact];
                       
        dispatch_async(dispatch_get_main_queue(),
        ^(void)
        {
            NSLog(@"updateContact=%i", result);
            
            // notify AIR
        });
    });
}

#pragma mark Checks

-(BOOL) isModified:(NSDate*) since
{
    __block BOOL result = FALSE;
    
    [AddressBookAccessor request:^(ABAddressBookRef addressBook, BOOL available)
    {
        if (available)
        {
            AddressBookProvider* provider = [[AddressBookProvider alloc] init];
            
            [provider setAddressBook:addressBook];
            
            result = [provider isModified:since];
        }
        else
        {
            // notify AIR
        }
    }];
    
    return result;
}

#pragma mark Retrieving data

-(NSArray*) getContacts:(NSRange) range
{
    return [self getContacts:range withOptions:NULL];
}

-(NSArray*) getContacts:(NSRange) range withOptions:(NSDictionary*) options
{
    __block NSArray* result = NULL;
    
    [AddressBookAccessor request:^(ABAddressBookRef addressBook, BOOL available)
    {
        if (available)
        {
            AddressBookProvider* provider = [[AddressBookProvider alloc] init];
            
            provider.addressBook = addressBook;
            
            result = [provider getPeople:range withOptions:options];
        }
    }];
    
    return result;
}

#pragma mark Modification data

-(BOOL) updateContact:(NSDictionary*) contact
{
    return FALSE;
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

@end

#pragma mark C Interface

#pragma mark FRE Functions

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
    FREObject result = NULL;
    
    FREObject freOffset;
    FREObject freLimit;
    
    FREGetArrayElementAt(argv[0], 0, &freOffset);
    FREGetArrayElementAt(argv[0], 1, &freLimit);
   
    uint32_t offset;
    uint32_t limit;
    
    FREGetObjectAsUint32(freOffset, &offset);
    FREGetObjectAsUint32(freLimit, &limit);
    
    NSLog(@"ofsset: %i, limit: %i", offset, limit);
    
    NSRange range = NSMakeRange(offset, limit);
    
    NSArray* people = NULL;
    
    people = [[Contacts sharedInstance] getContacts:range];
    
//    if (argc == 2)
//    {
//        people = NULL;
//    }
//    else
//    {
//        people = [[Contacts sharedInstance] getContacts:range];
//    }
    
    if (people != NULL)
    {
        FRENewObject((const uint8_t*) "Array", 0, NULL, &result, NULL);
        
        NSUInteger n = [people count];
        
        FRESetArrayLength(result, (uint32_t) n);
        
        for (NSUInteger i = 0; i < n; i++)
        {
            NSDictionary* person = [people objectAtIndex:i];
            
            FREObject contact = personToContact(person);
            
            FRESetArrayElementAt(result, (uint32_t) i, contact);
        }
    }
    
    return result;
}

#pragma mark ContextInitialize/ContextFinalizer

void ContactsContextInitializer(void* extData, const uint8_t* ctxType, FREContext ctx, uint32_t* numFunctionsToTest, const FRENamedFunction** functionsToSet)
{
    *numFunctionsToTest = 2;
    
    FRENamedFunction* func = (FRENamedFunction*) malloc(sizeof(FRENamedFunction) * (*numFunctionsToTest));
    
    func[0].name = (const uint8_t*) "isModified";
    func[0].functionData = NULL;
    func[0].function = &isModified;
    
    func[1].name = (const uint8_t*) "getContacts";
    func[1].functionData = NULL;
    func[1].function = &getContacts;
    
    *functionsToSet = func;
}

void ContactsContextFinalizer(FREContext ctx)
{
    
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


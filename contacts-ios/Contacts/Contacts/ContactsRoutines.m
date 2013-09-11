//
//  ContactsConversionRoutines.m
//  Contacts
//
//  Created by Maxim on 9/11/13.
//  Copyright (c) 2013 Max Rozdobudko. All rights reserved.
//

#import "FlashRuntimeExtensions.h"

#import "ContactsRoutines.h"

@implementation ContactsRoutines

@end

#pragma mark C Interface

#pragma mark Utility functions

void setStringProperty(FREObject contact, const uint8_t* name, NSString* value)
{
    if (value)
    {
        FREObject propertyValue;
        
        const char* valueInUTF8 = [value UTF8String];
        
        FRENewObjectFromUTF8(strlen(valueInUTF8) + 1, (const uint8_t*) valueInUTF8, &propertyValue);
        
        FRESetObjectProperty(contact, name, propertyValue, NULL);
    }
    else
    {
        FRESetObjectProperty(contact, name, NULL, NULL);
    }
}

#pragma mark Event functions

void dispatchErrorEvent(FREContext context, NSString* code)
{
    NSLog(@"Dispatch error event with code: %@", code);
    
    FREDispatchStatusEventAsync(context, (const uint8_t*) [code UTF8String], (const uint8_t*) "error");
}

void dispatchStatusEvent(FREContext context, NSString* code)
{
    NSLog(@"Dispatch status event with code: %@", code);
    
    FREDispatchStatusEventAsync(context, (const uint8_t*) [code UTF8String], (const uint8_t*) "status");
}

#pragma mark Conversion functions

NSRange convertToNSRange(FREObject source)
{
    FREObject freOffset;
    FREObject freLimit;
    
    FREGetArrayElementAt(source, 0, &freOffset);
    FREGetArrayElementAt(source, 1, &freLimit);
    
    uint32_t offset;
    uint32_t limit;
    
    FREGetObjectAsUint32(freOffset, &offset);
    FREGetObjectAsUint32(freLimit, &limit);
    
    NSLog(@"ofsset: %i, limit: %i", offset, limit);
    
    NSRange range = NSMakeRange(offset, limit);
    
    return range;
}

FREObject personToContact(NSDictionary* person)
{
    FREObject contact;
    
    FRENewObject((const uint8_t*) "Object", 0, NULL, &contact, NULL);
    
    // define FRE variables
    
    FREObject freIntValue;
    //    FREObject freUintValue;
    //    FREObject freStringValue;
    
    // recordId
    
    NSNumber* recordId = [person valueForKey:@"personId"];
    
    FRENewObjectFromInt32(recordId.integerValue, &freIntValue);
    
    FRESetObjectProperty(contact, (const uint8_t*) "recordId", freIntValue, NULL);
    
    // compositeName
    
    NSString* compositeName = [person valueForKey:@"compositeName"];
    
    setStringProperty(contact, (const uint8_t*) "compositeName", compositeName);
    
    //
    //    if (compositeName)
    //    {
    //        FRENewObjectFromUTF8(strlen([compositeName UTF8String]) + 1, (const uint8_t*) [compositeName UTF8String], NULL);
    //
    //        FRESetObjectProperty(contact, const uint8_t * "compositeName", freCompositeName, NULL);
    //    }
    //    else
    //    {
    //        FRESetObjectProperty(contact, const uint8_t * "compositeName", NULL, NULL);
    //    }
    
    return contact;
}

FREObject peopleToContacts(NSArray* people)
{
    FREObject result = NULL;
    
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

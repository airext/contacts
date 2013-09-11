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

#pragma mark Conversion functions

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

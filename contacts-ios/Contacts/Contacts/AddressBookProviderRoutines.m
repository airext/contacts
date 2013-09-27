//
//  AddressBookProviderRoutines.m
//  Contacts
//
//  Created by Maxim on 9/10/13.
//  Copyright (c) 2013 Max Rozdobudko. All rights reserved.
//

#import <AddressBook/AddressBook.h>

#import "AddressBookProviderRoutines.h"

@implementation AddressBookProviderRoutines

#pragma mark Main tasks

+(NSDictionary*) createContact:(ABRecordRef)person
{
    NSMutableDictionary* contact = [NSMutableDictionary dictionaryWithCapacity:10];
    
    // recordId
    
    NSNumber* recordId = [NSNumber numberWithInt:ABRecordGetRecordID(person)];
    
    [contact setValue:recordId forKey:@"recordId"];
    
    // compositeName
    
    [self setStringProperty:contact withValue:CFBridgingRelease(ABRecordCopyCompositeName(person)) forKey:@"compositeName"];
    
    // firstName
    
    [self setStringProperty:contact withValue:CFBridgingRelease(ABRecordCopyValue(person, kABPersonFirstNameProperty)) forKey:@"firstName"];
    
    // lastName
    
    [self setStringProperty:contact withValue:CFBridgingRelease(ABRecordCopyValue(person, kABPersonLastNameProperty)) forKey:@"lastName"];
    
    // middleName
    
    [self setStringProperty:contact withValue:CFBridgingRelease(ABRecordCopyValue(person, kABPersonLastNameProperty)) forKey:@"lastName"];
    
    // prefix
    
    [self setStringProperty:contact withValue:CFBridgingRelease(ABRecordCopyValue(person, kABPersonPrefixProperty)) forKey:@"prefix"];
    
    // suffix
    
    [self setStringProperty:contact withValue:CFBridgingRelease(ABRecordCopyValue(person, kABPersonSuffixProperty)) forKey:@"suffix"];
    
    // nickname
    
    [self setStringProperty:contact withValue:CFBridgingRelease(ABRecordCopyValue(person, kABPersonNicknameProperty)) forKey:@"nickname"];
    
    // firstNamePhonetic
    
    [self setStringProperty:contact withValue:CFBridgingRelease(ABRecordCopyValue(person, kABPersonFirstNamePhoneticProperty)) forKey:@"firstNamePhonetic"];
    
    // lastNamePhonetic
    
    [self setStringProperty:contact withValue:CFBridgingRelease(ABRecordCopyValue(person, kABPersonLastNamePhoneticProperty)) forKey:@"lastNamePhonetic"];
    
    // middleNamePhonetic
    
    [self setStringProperty:contact withValue:CFBridgingRelease(ABRecordCopyValue(person, kABPersonMiddleNamePhoneticProperty)) forKey:@"middleNamePhonetic"];
    
    // organization
    
    [self setStringProperty:contact withValue:CFBridgingRelease(ABRecordCopyValue(person, kABPersonOrganizationProperty)) forKey:@"organization"];
    
    // jobTitle
    
    [self setStringProperty:contact withValue:CFBridgingRelease(ABRecordCopyValue(person, kABPersonJobTitleProperty)) forKey:@"jobTitle"];
    
    // department
    
    [self setStringProperty:contact withValue:CFBridgingRelease(ABRecordCopyValue(person, kABPersonDepartmentProperty)) forKey:@"department"];
    
    // note
    
    [self setStringProperty:contact withValue:CFBridgingRelease(ABRecordCopyValue(person, kABPersonNoteProperty)) forKey:@"note"];
    
    // birthday
    
    [self setDateProperty:contact withValue:CFBridgingRelease(ABRecordCopyValue(person, kABPersonBirthdayProperty)) forKey:@"birthday"];
    
    // creationDate
    
    [self setDateProperty:contact withValue:CFBridgingRelease(ABRecordCopyValue(person, kABPersonCreationDateProperty)) forKey:@"creationDate"];
    
    // modificationDate
    
    [self setDateProperty:contact withValue:CFBridgingRelease(ABRecordCopyValue(person, kABPersonModificationDateProperty)) forKey:@"modificationDate"];
    
    // emails
    
    ABMultiValueRef emails = ABRecordCopyValue(person, kABPersonEmailProperty);
    
    CFIndex emailCount = ABMultiValueGetCount(emails);
    
    if (emailCount > 0)
    {
        [self setMultiStringValueProperty:contact withValue:emails inNumber:emailCount forKey:@"emails"];
    }
    else
    {
        [contact setValue:nil forKey:@"emails"];
    }
    
    CFRelease(emails);
    
    // phones
    
    ABMultiValueRef phones = ABRecordCopyValue(person, kABPersonPhoneProperty);
    
    CFIndex phoneCount = ABMultiValueGetCount(phones);
    
    if (phoneCount > 0)
    {
        [self setMultiStringValueProperty:contact withValue:phones inNumber:phoneCount forKey:@"phones"];
    }
    else
    {
        [contact setValue:nil forKey:@"phones"];
    }
    
    CFRelease(phones);
    
    // address
    
    [self setMultiDictionaryProperty:contact withValue:ABRecordCopyValue(person, kABPersonAddressProperty) forKey:@"address"];
    
    // profiles
    
    [self setMultiDictionaryProperty:contact withValue:ABRecordCopyValue(person, kABPersonSocialProfileProperty) forKey:@"profiles"];
    
    // thumbnail
    
    if (ABPersonHasImageData(person))
    {
        NSData* image = CFBridgingRelease(ABPersonCopyImageDataWithFormat(person, kABPersonImageFormatThumbnail));
        
        [contact setValue:image forKey:@"thumbnail"];
    }
    else
    {
        [contact setValue:nil forKey:@"thumbnail"];
    }
    
    return contact;
}

#pragma mark Utility methods

+(void) setStringProperty:(NSDictionary*) contact withValue:(NSString*) value forKey:(NSString*) key
{
    if (value)
    {
        [contact setValue:value forKey:key];
    }
    else
    {
        [contact setValue:nil forKey:key];
    }
}

+(void) setMultiDictionaryProperty:(NSDictionary*) contact withValue:(ABMultiValueRef) value forKey:(NSString*) key
{
    if (value)
    {
        CFIndex n = ABMultiValueGetCount(value);
        
        NSMutableArray* array = [NSMutableArray arrayWithCapacity:n];
        
        for (NSUInteger i = 0; i < n; i++)
        {
            CFDictionaryRef dic = ABMultiValueCopyValueAtIndex(value, i);
            
            NSMutableDictionary* item = [NSMutableDictionary dictionary];
            
            CFDictionaryApplyFunction(dic, setDictionaryProperty, (void*) item);
            
            [array insertObject:item atIndex:i];
        }
        
        [contact setValue:array forKey:key];
        
        CFRelease(value);
    }
    else
    {
        [contact setValue:nil forKey:key];
    }
}

void setDictionaryProperty(const void *key, const void *value, void *context)
{
    NSMutableDictionary* item = (__bridge NSMutableDictionary*) context;
    
    [item setValue:CFBridgingRelease(value) forKey:CFBridgingRelease(key)];
}

+(void) setMultiStringValueProperty:(NSDictionary*) contact withValue:(ABMultiValueRef) value inNumber:(CFIndex) count forKey:(NSString*) key
{
        NSMutableArray* array = [NSMutableArray arrayWithCapacity:count];
        
        for (CFIndex i = 0; i < count; i++)
        {
            CFStringRef propertyLabel = ABMultiValueCopyLabelAtIndex(value, i);
            CFStringRef propertyValue = ABMultiValueCopyValueAtIndex(value, i);

            NSDictionary* item;
            
            if (propertyLabel)
            {
                item = [NSDictionary dictionaryWithObject:CFBridgingRelease(propertyValue) forKey:CFBridgingRelease(propertyLabel)];
            }
            else
            {
                item = [NSDictionary dictionaryWithObject:CFBridgingRelease(propertyValue) forKey:@""];
            }

            [array insertObject:item atIndex:i];
        }
        
        [contact setValue:array forKey:key];

}

+(void) setDateProperty:(NSDictionary*) contact withValue:(NSDate*) value forKey:(NSString*) key
{
    if (value)
    {
        [contact setValue:value forKey:key];
    }
    else
    {
        [contact setValue:nil forKey:key];
    }
}

@end


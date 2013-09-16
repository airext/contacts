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
    
    [self setStringProperty:contact withValue:ABRecordCopyCompositeName(person) forKey:@"compositeName"];
    
    // firstName
    
    [self setStringProperty:contact withValue:ABRecordCopyValue(person, kABPersonFirstNameProperty) forKey:@"firstName"];
    
    // lastName
    
    [self setStringProperty:contact withValue:ABRecordCopyValue(person, kABPersonLastNameProperty) forKey:@"lastName"];
    
    // middleName
    
    [self setStringProperty:contact withValue:ABRecordCopyValue(person, kABPersonLastNameProperty) forKey:@"lastName"];
    
    // prefixProperty
    
    [self setStringProperty:contact withValue:ABRecordCopyValue(person, kABPersonPrefixProperty) forKey:@"prefixProperty"];
    
    // suffixProperty
    
    [self setStringProperty:contact withValue:ABRecordCopyValue(person, kABPersonSuffixProperty) forKey:@"suffixProperty"];
    
    // nickname
    
    [self setStringProperty:contact withValue:ABRecordCopyValue(person, kABPersonNicknameProperty) forKey:@"nickname"];
    
    // firstNamePhonetic
    
    [self setStringProperty:contact withValue:ABRecordCopyValue(person, kABPersonFirstNamePhoneticProperty) forKey:@"firstNamePhonetic"];
    
    // lastNamePhonetic
    
    [self setStringProperty:contact withValue:ABRecordCopyValue(person, kABPersonLastNamePhoneticProperty) forKey:@"lastNamePhonetic"];
    
    // middleNamePhonetic
    
    [self setStringProperty:contact withValue:ABRecordCopyValue(person, kABPersonMiddleNamePhoneticProperty) forKey:@"middleNamePhonetic"];
    
    // organization
    
    [self setStringProperty:contact withValue:ABRecordCopyValue(person, kABPersonOrganizationProperty) forKey:@"organization"];
    
    // jobTitle
    
    [self setStringProperty:contact withValue:ABRecordCopyValue(person, kABPersonJobTitleProperty) forKey:@"jobTitle"];
    
    // department
    
    [self setStringProperty:contact withValue:ABRecordCopyValue(person, kABPersonDepartmentProperty) forKey:@"department"];
    
    // note
    
    [self setStringProperty:contact withValue:ABRecordCopyValue(person, kABPersonNoteProperty) forKey:@"note"];
    
    // emails
    
    [self setMultiStringValueProperty:contact withValue:ABRecordCopyValue(person, kABPersonEmailProperty) forKey:@"emails"];
    
    // phones
    
    [self setMultiStringValueProperty:contact withValue:ABRecordCopyValue(person, kABPersonPhoneProperty) forKey:@"phones"];
    
    // birthday
    
    [self setDateProperty:contact withValue:ABRecordCopyValue(person, kABPersonBirthdayProperty) forKey:@"birthday"];
    
    // creationDate
    
    [self setDateProperty:contact withValue:ABRecordCopyValue(person, kABPersonCreationDateProperty) forKey:@"creationDate"];
    
    // modificationDate
    
    [self setDateProperty:contact withValue:ABRecordCopyValue(person, kABPersonModificationDateProperty) forKey:@"modificationDate"];
    
    // TODO: Add address
    
    // address
    
    ABMultiValueRef address  = ABRecordCopyValue(person, kABPersonAddressProperty);
    
    [self setMultiDictionaryProperty:contact withValue:address forKey:@"address"];
    
    // profiles
    
    ABMultiValueRef profiles = ABRecordCopyValue(person, kABPersonSocialProfileProperty);
    
    [self setMultiDictionaryProperty:contact withValue:profiles forKey:@"profiles"];
    
    return contact;
    
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
}


//void SaveName(const void* key, const void* value, void* context)
//{
//
//}

#pragma mark Utility methods

+(void) setStringProperty:(NSDictionary*) contact withValue:(CFStringRef) value forKey:(NSString*) key
{
    if (value)
    {
        [contact setValue:CFBridgingRelease(value) forKey:key];
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
            CFDictionaryRef profile = ABMultiValueCopyValueAtIndex(value, i);
            
            NSMutableDictionary* profiles = [NSMutableDictionary dictionary];
            
            CFDictionaryApplyFunction(profile, setDictionaryProperty, (void*) profiles);
            
            CFDictionaryGetValue(profile, kABPersonSocialProfileServiceTwitter);
            
            [array insertObject:profiles atIndex:i];
        }
        
        [contact setValue:array forKey:key];
    }
    else
    {
        [contact setValue:nil forKey:key];
    }
}

void setDictionaryProperty(const void *key, const void *value, void *context)
{
    NSMutableDictionary* dictionary = (__bridge NSMutableDictionary*) context;
    
    NSString* profileKey = CFBridgingRelease(key);
    NSString* profileValue = CFBridgingRelease(value);
    
    [dictionary setValue:profileValue forKey:profileKey];
}

+(void) setMultiStringValueProperty:(NSDictionary*) contact withValue:(ABMultiValueRef) value forKey:(NSString*) key
{
    if (value)
    {
        CFIndex n = ABMultiValueGetCount(value);
        
        NSMutableArray* array = [NSMutableArray arrayWithCapacity:n];
        
        for (CFIndex i = 0; i < n; i++)
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
        
        CFRelease(value);
    }
    else
    {
        [contact setValue:nil forKey:key];
    }
    
}

+(void) setDateProperty:(NSDictionary*) contact withValue:(CFDateRef) value forKey:(NSString*) key
{
    if (value)
    {
        [contact setValue:CFBridgingRelease(value) forKey:key];
    }
    else
    {
        [contact setValue:nil forKey:key];
    }
}

@end


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
    
    ABRecordID recordId = ABRecordGetRecordID(person);
    
    [contact setValue:[NSNumber numberWithInt:recordId] forKey:@"recordId"];
    
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
    
    // middleNamePhonetic
    
    [self setStringProperty:contact withValue:ABRecordCopyValue(person, kABPersonMiddleNamePhoneticProperty) forKey:@"middleNamePhonetic"];
    
    // middleNamePhonetic
    
    [self setStringProperty:contact withValue:ABRecordCopyValue(person, kABPersonMiddleNamePhoneticProperty) forKey:@"middleNamePhonetic"];
    
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
    
    [self setStringMultiValueProperty:contact withValue:ABRecordCopyValue(person, kABPersonEmailProperty) forKey:@"emails"];
    
    // phones
    
    [self setStringMultiValueProperty:contact withValue:ABRecordCopyValue(person, kABPersonPhoneProperty) forKey:@"phones"];
    
    // birthday
    
    [self setDateProperty:contact withValue:ABRecordCopyValue(person, kABPersonBirthdayProperty) forKey:@"birthday"];
    
    // creationDate
    
    [self setDateProperty:contact withValue:ABRecordCopyValue(person, kABPersonCreationDateProperty) forKey:@"creationDate"];
    
    // modificationDate
    
    [self setDateProperty:contact withValue:ABRecordCopyValue(person, kABPersonModificationDateProperty) forKey:@"modificationDate"];
    
    // TODO: Add address
    
    // thumbnail
    
    if (ABPersonHasImageData(person))
    {
        NSData* image = CFBridgingRelease(ABPersonCopyImageDataWithFormat(person, kABPersonImageFormatThumbnail));
        
        [contact setValue:image forKey:@"thumbnail"];
    }
    else
    {
        [contact setValue:[NSNull null] forKey:@"thumbnail"];
    }
    
    return contact;
}

#pragma mark Utility methods


+(void) setStringProperty:(NSDictionary*) contact withValue:(CFStringRef) value forKey:(NSString*) key
{
    if (value)
    {
        [contact setValue:CFBridgingRelease(value) forKey:key];
    }
    else
    {
        [contact setValue:[NSNull null] forKey:key];
    }
}

+(void) setStringMultiValueProperty:(NSDictionary*) contact withValue:(ABMultiValueRef) value forKey:(NSString*) key
{
    if (value)
    {
        CFIndex n = ABMultiValueGetCount(value);
        
        NSMutableArray* array = [NSMutableArray arrayWithCapacity:n];
        
        for (CFIndex i = 0; i < n; i++)
        {
            [array insertObject:CFBridgingRelease(ABMultiValueCopyValueAtIndex(value, i)) atIndex:i];
        }
        
        [contact setValue:array forKey:key];
        
        CFRelease(value);
    }
    else
    {
        [contact setValue:[NSNull null] forKey:key];
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
        [contact setValue:[NSNull null] forKey:key];
    }
}

@end


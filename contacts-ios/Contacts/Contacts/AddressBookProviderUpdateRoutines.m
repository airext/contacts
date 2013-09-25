//
//  ContactsUpdateRoutines.m
//  Contacts
//
//  Created by Maxim on 9/23/13.
//  Copyright (c) 2013 Max Rozdobudko. All rights reserved.
//

#import "FRETypeConversion.h"

#import "AddressBookProviderUpdateRoutines.h"

@implementation AddressBookProviderUpdateRoutines

+(BOOL) updateContactWithOptions:(FREObject) contact withOptions:(FREObject) options
{
    [[AddressBookAccessor sharedInstance] request:^(ABAddressBookRef addressBook, BOOL available)
    {
        if (available)
        {
            ABRecordID recordId = [self getContactRecordId:contact];
            
            ABRecordRef person = ABAddressBookGetPersonWithRecordID(addressBook, recordId);
            
            // firstName
            
            CFStringRef firstName = [self getContactPropertyAsString:contact fromProperty:(const uint8_t*) "firstName"];
            
            if (firstName != NULL)
            {
                ABRecordSetValue(person, kABPersonFirstNameProperty, firstName, NULL);
                
                
                CFRelease(firstName);
            }
            NSLog(@"firstName is %@", firstName);
            
            // lastName
            
            CFStringRef lastName = [self getContactPropertyAsString:contact fromProperty:(const uint8_t*) "lastName"];
            
            if (lastName != NULL)
            {
                ABRecordSetValue(person, kABPersonLastNameProperty, lastName, NULL);
                
                CFRelease(lastName);
            }
            NSLog(@"lastName is %@", lastName);
            
            // middleName
            
            CFStringRef middleName = [self getContactPropertyAsString:contact fromProperty:(const uint8_t*) "middleName"];
            
            if (middleName != NULL)
            {
                ABRecordSetValue(person, kABPersonMiddleNameProperty, middleName, NULL);
                
                CFRelease(middleName);
            }
            NSLog(@"middleName is %@", middleName);
            
            // prefixProperty
            
            CFStringRef prefixProperty = [self getContactPropertyAsString:contact fromProperty:(const uint8_t*) "prefixProperty"];
            
            if (prefixProperty != NULL)
            {
                
                ABRecordSetValue(person, kABPersonPrefixProperty, prefixProperty, NULL);
                
                CFRelease(prefixProperty);                
            }
            NSLog(@"prefixProperty is %@", prefixProperty);
            
            // suffixProperty
            
            CFStringRef suffixProperty = [self getContactPropertyAsString:contact fromProperty:(const uint8_t*) "suffixProperty"];
            
            if (suffixProperty != NULL)
            {
                ABRecordSetValue(person, kABPersonSuffixProperty, suffixProperty, NULL);
                
                CFRelease(suffixProperty);
            }
            NSLog(@"suffixProperty is %@", suffixProperty);
            
            // nickname
            
            CFStringRef nickname = [self getContactPropertyAsString:contact fromProperty:(const uint8_t*) "nickname"];
            
            if (nickname != NULL)
            {
                ABRecordSetValue(person, kABPersonNicknameProperty, nickname, NULL);
                
                CFRelease(nickname);
            }
            NSLog(@"nickname is %@", nickname);
            
            // firstNamePhonetic
            
            CFStringRef firstNamePhonetic = [self getContactPropertyAsString:contact fromProperty:(const uint8_t*) "firstNamePhonetic"];
            
            if (firstNamePhonetic != NULL)
            {
                ABRecordSetValue(person, kABPersonFirstNamePhoneticProperty, firstNamePhonetic, NULL);
            
                CFRelease(firstNamePhonetic);
            }
            NSLog(@"firstNamePhonetic is %@", firstNamePhonetic);
            
            // lastNamePhonetic
            
            CFStringRef lastNamePhonetic = [self getContactPropertyAsString:contact fromProperty:(const uint8_t*) "lastNamePhonetic"];
            
            if (lastNamePhonetic != NULL)
            {
                ABRecordSetValue(person, kABPersonLastNamePhoneticProperty, lastNamePhonetic, NULL);
                
                CFRelease(lastNamePhonetic);
            }
            NSLog(@"lastNamePhonetic is %@", lastNamePhonetic);
            
            // middleNamePhonetic
            
            CFStringRef middleNamePhonetic = [self getContactPropertyAsString:contact fromProperty:(const uint8_t*) "middleNamePhonetic"];
            
            if (middleNamePhonetic != NULL)
            {
                ABRecordSetValue(person, kABPersonMiddleNamePhoneticProperty, middleNamePhonetic, NULL);
                
                CFRelease(middleNamePhonetic);
            }
            NSLog(@"middleNamePhonetic is %@", middleNamePhonetic);
            
            // organization
            
            CFStringRef organization = [self getContactPropertyAsString:contact fromProperty:(const uint8_t*) "organization"];
            
            if (organization != NULL)
            {
                ABRecordSetValue(person, kABPersonOrganizationProperty, organization, NULL);
                
                CFRelease(organization);
            }
            NSLog(@"organization is %@", organization);
            
            // jobTitle
            
            CFStringRef jobTitle = [self getContactPropertyAsString:contact fromProperty:(const uint8_t*) "jobTitle"];
            
            if (jobTitle != NULL)
            {
                ABRecordSetValue(person, kABPersonJobTitleProperty, jobTitle, NULL);
                
                CFRelease(jobTitle);
            }
            NSLog(@"jobTitle is %@", jobTitle);
            
            // department
            
            CFStringRef department = [self getContactPropertyAsString:contact fromProperty:(const uint8_t*) "department"];
            
            if (department != NULL)
            {
                ABRecordSetValue(person, kABPersonDepartmentProperty, department, NULL);
                
                NSLog(@"department is %@", department);
                CFRelease(department);
            }
            
            // note
            
            CFStringRef note = [self getContactPropertyAsString:contact fromProperty:(const uint8_t*) "note"];
            
            if (note != NULL)
            {
                ABRecordSetValue(person, kABPersonNoteProperty, note, NULL);
                
                NSLog(@"note is %@", note);
                CFRelease(note);
            }
            
            // emails
            
            ABMultiValueRef emails = [self getContactPropertyAsMultiString:contact fromProperty:(const uint8_t *) "emails"];
            
            if (emails != NULL)
            {
                ABRecordSetValue(person, kABPersonEmailProperty, emails, NULL);
                
                NSLog(@"emails is %@", emails);
                CFRelease(emails);
            }
            
            // phones
            
            ABMultiValueRef phones = [self getContactPropertyAsMultiString:contact fromProperty:(const uint8_t *) "phones"];
            
            if (phones != NULL)
            {
                ABRecordSetValue(person, kABPersonPhoneProperty, phones, NULL);
                
                NSLog(@"phones is %@", phones);
                CFRelease(phones);
            }
            
//            // birthday
//            
//            CFDateRef birhday = [self getContactPropertyAsDate:contact fromProperty:(const uint8_t *) "birthday"];
//            
//            if (birhday != NULL)
//            {
//                ABRecordSetValue(person, kABPersonBirthdayProperty, birhday, NULL);
//                
//                NSLog(@"birhday is %@", birhday);
//                CFRelease(birhday);
//            }
            
            // profiles
            
            NSArray* profileKeys = [NSArray arrayWithObjects:
                                    (NSString*)kABPersonSocialProfileServiceKey,
                                    (NSString*)kABPersonSocialProfileUsernameKey,
                                    (NSString*)kABPersonSocialProfileURLKey,
                                    nil];
            
            ABMultiValueRef profiles = [self getContactPropertyAsMultiDictionary:contact fromProperty:(const uint8_t *) "profiles" withKeys:profileKeys];
            
            if (profiles)
            {
                ABRecordSetValue(person, kABPersonSocialProfileProperty, profiles, NULL);
                
                NSLog(@"profiles is %@", profiles);
                CFRelease(profiles);
            }
            
            // address
            
            NSArray* addressKeys = [NSArray arrayWithObjects:
                                    (NSString*)kABPersonAddressStreetKey,
                                    (NSString*)kABPersonAddressCityKey,
                                    (NSString*)kABPersonAddressStateKey,
                                    (NSString*)kABPersonAddressZIPKey,
                                    (NSString*)kABPersonAddressCountryKey,
                                    (NSString*)kABPersonAddressCountryCodeKey,
                                    nil];
            
            ABMultiValueRef address = [self getContactPropertyAsMultiDictionary:contact fromProperty:(const uint8_t *) "address" withKeys:addressKeys];
            
            if (address)
            {
                ABRecordSetValue(person, kABPersonAddressProperty, address, NULL);
                
                NSLog(@"address is %@", address);
                CFRelease(address);
            }
            
            // save
            
            ABAddressBookSave(addressBook, nil);
        }
        else
        {
            // disptch error event 
        }
    }];
    
    return TRUE;
}

+(ABRecordID) getContactRecordId:(FREObject) contact
{
    FREObject value = NULL;
    
    FREGetObjectProperty(contact, (const uint8_t*) "recordId", &value, NULL);
    
    int32_t result;
    
    FREGetObjectAsInt32(value, &result);
    
    return result;
}

+(CFStringRef) getContactPropertyAsString:(FREObject) contact fromProperty:(const uint8_t*) propertyName
{
    FREObject value = NULL;
    
    FREGetObjectProperty(contact, propertyName, &value, NULL);
    
    if (value)
    {
        uint32_t length;
        
        const uint8_t* buffer;
        
        FREGetObjectAsUTF8(value, &length, &buffer);
        
        return CFStringCreateWithCString(NULL, (const char*) buffer, kCFStringEncodingUTF8);
    }
    else
    {
        return  NULL;
    }
}

+(CFDateRef) getContactPropertyAsDate:(FREObject) contact fromProperty:(const uint8_t*) propertyName
{
    FREObject value;
    FREGetObjectProperty(contact, propertyName, &value, NULL);
    
    if (value)
    {
        NSDate* date;
        
        [FRETypeConversion convertFREDateToNSDate:value asDate:date];
        
        return (__bridge CFDateRef) date;
    }
    else
    {
        return NULL;
    }
}

+(ABMultiValueRef) getContactPropertyAsMultiString:(FREObject) contact fromProperty:(const uint8_t*) propertyName
{
    FREObject array = NULL;
    FREGetObjectProperty(contact, propertyName, &array, NULL);
    
    if (array)
    {
        ABMultiValueRef result = ABMultiValueCreateMutable(kABMultiStringPropertyType);
        
        uint32_t n;
        FREGetArrayLength(array, &n);
        
        for (uint32_t i = 0; i < n; i++)
        {
            FREObject item;
            FREGetArrayElementAt(array, i, &item);
            
            FREObject itemLabel;
            FREGetObjectProperty(item, (const uint8_t*) "label", &itemLabel, NULL);

            NSString* label;
            
            [FRETypeConversion convertFREStringToNSString:itemLabel asString:&label];
            
            FREObject itemValue;
            FREGetObjectProperty(item, (const uint8_t*) "value", &itemValue, NULL);
            
            NSString* value;
            [FRETypeConversion convertFREStringToNSString:itemValue asString:&value];

            NSLog(@"label:%@", label);
            NSLog(@"value:%@", value);

            ABMultiValueAddValueAndLabel(result, CFBridgingRetain(value), CFBridgingRetain(label), NULL);
        }
        
        return result;
    }
    else
    {
        return NULL;
    }
}

+(ABMultiValueRef) getContactPropertyAsMultiDictionary:(FREObject) contact fromProperty:(const uint8_t*) propertyName withKeys:(NSArray*) dictionaryKeys
{
    FREObject array = NULL;
    FREGetObjectProperty(contact, propertyName, &array, NULL);
    
    if (array)
    {
        ABMultiValueRef result = ABMultiValueCreateMutable(kABMultiDictionaryPropertyType);
        
        uint32_t n;
        FREGetArrayLength(array, &n);
        
        for (uint32_t i = 0; i < n; i++)
        {
            FREObject item;
            FREGetArrayElementAt(array, i, &item);
            
            NSUInteger dictionaryKeyCount = [dictionaryKeys count];
            
            CFStringRef keys[dictionaryKeyCount];
            CFStringRef values[dictionaryKeyCount];
            
            for (NSUInteger j = 0; j < dictionaryKeyCount; j++)
            {
                NSString* key = [dictionaryKeys objectAtIndex:j];
                
                FREObject valueObject;
                FREGetObjectProperty(item, (const uint8_t *) [key UTF8String], &valueObject, nil);
                
                uint32_t length;
                const uint8_t* valueInUTF8;
                
                FREGetObjectAsUTF8(valueObject, &length, &valueInUTF8);
                
                NSString* value = [NSString stringWithUTF8String:(const char *) valueInUTF8];
                
                keys[j] = CFBridgingRetain(key);
                values[j] = CFBridgingRetain(value);
                
//                keys[j] = (__bridge CFStringRef)(key);
//                values[j] = (__bridge CFStringRef)(value);
                
//                NSLog(@"key=%@", key);
//                NSLog(@"value=%@", value);
            }
            
            ABMultiValueAddValueAndLabel(result, CFDictionaryCreate(kCFAllocatorDefault, (void*) keys, (void*)values, dictionaryKeyCount, NULL, NULL), NULL, NULL);
        }
        
        return result;
    }
    else
    {
        return NULL;
    }
}

@end

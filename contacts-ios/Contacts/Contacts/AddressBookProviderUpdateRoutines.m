//
//  ContactsUpdateRoutines.m
//  Contacts
//
//  Created by Maxim on 9/23/13.
//  Copyright (c) 2013 Max Rozdobudko. All rights reserved.
//

#import "Contacts_FRETypeConversion.h"

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
            
            CFStringRef firstName = [self copyContactStringProperty:contact fromProperty:(const uint8_t*) "firstName"];
            
            if (firstName)
            {
                ABRecordSetValue(person, kABPersonFirstNameProperty, firstName, NULL);
                
                CFRelease(firstName);
            }
//            NSLog(@"firstName is %@", firstName);
            
            // lastName
            
            CFStringRef lastName = [self copyContactStringProperty:contact fromProperty:(const uint8_t*) "lastName"];
            
            if (lastName)
            {
                ABRecordSetValue(person, kABPersonLastNameProperty, lastName, NULL);
                
                CFRelease(lastName);
            }
//            NSLog(@"lastName is %@", lastName);
            
            // middleName
            
            CFStringRef middleName = [self copyContactStringProperty:contact fromProperty:(const uint8_t*) "middleName"];
            
            if (middleName != NULL)
            {
                ABRecordSetValue(person, kABPersonMiddleNameProperty, middleName, NULL);
                
                CFRelease(middleName);
            }
//            NSLog(@"middleName is %@", middleName);
            
            // prefixProperty
            
            CFStringRef prefixProperty = [self copyContactStringProperty:contact fromProperty:(const uint8_t*) "prefixProperty"];
            
            if (prefixProperty)
            {
                ABRecordSetValue(person, kABPersonPrefixProperty, prefixProperty, NULL);
                
                CFRelease(prefixProperty);                
            }
            
//            NSLog(@"prefixProperty is %@", prefixProperty);
            
            // suffixProperty
            
            CFStringRef suffixProperty = [self copyContactStringProperty:contact fromProperty:(const uint8_t*) "suffixProperty"];
            
            if (suffixProperty)
            {
                ABRecordSetValue(person, kABPersonSuffixProperty, suffixProperty, NULL);
                
                CFRelease(suffixProperty);
            }
//            NSLog(@"suffixProperty is %@", suffixProperty);
            
            // nickname
            
            CFStringRef nickname = [self copyContactStringProperty:contact fromProperty:(const uint8_t*) "nickname"];
            
            if (nickname)
            {
                ABRecordSetValue(person, kABPersonNicknameProperty, nickname, NULL);
                
                CFRelease(nickname);
            }
//            NSLog(@"nickname is %@", nickname);
            
            // firstNamePhonetic
            
            CFStringRef firstNamePhonetic = [self copyContactStringProperty:contact fromProperty:(const uint8_t*) "firstNamePhonetic"];
            
            if (firstNamePhonetic)
            {
                ABRecordSetValue(person, kABPersonFirstNamePhoneticProperty, firstNamePhonetic, NULL);
            
                CFRelease(firstNamePhonetic);
            }
//            NSLog(@"firstNamePhonetic is %@", firstNamePhonetic);
            
            // lastNamePhonetic
            
            CFStringRef lastNamePhonetic = [self copyContactStringProperty:contact fromProperty:(const uint8_t*) "lastNamePhonetic"];
            
            if (lastNamePhonetic)
            {
                ABRecordSetValue(person, kABPersonLastNamePhoneticProperty, lastNamePhonetic, NULL);
                
                CFRelease(lastNamePhonetic);
            }
//            NSLog(@"lastNamePhonetic is %@", lastNamePhonetic);
            
            // middleNamePhonetic
            
            CFStringRef middleNamePhonetic = [self copyContactStringProperty:contact fromProperty:(const uint8_t*) "middleNamePhonetic"];
            
            if (middleNamePhonetic)
            {
                ABRecordSetValue(person, kABPersonMiddleNamePhoneticProperty, middleNamePhonetic, NULL);
                
                CFRelease(middleNamePhonetic);
            }
//            NSLog(@"middleNamePhonetic is %@", middleNamePhonetic);
            
            // organization
            
            CFStringRef organization = [self copyContactStringProperty:contact fromProperty:(const uint8_t*) "organization"];
            
            if (organization)
            {
                ABRecordSetValue(person, kABPersonOrganizationProperty, organization, NULL);
                
                CFRelease(organization);
            }
//            NSLog(@"organization is %@", organization);
            
            // jobTitle
            
            CFStringRef jobTitle = [self copyContactStringProperty:contact fromProperty:(const uint8_t*) "jobTitle"];
            
            if (jobTitle)
            {
                ABRecordSetValue(person, kABPersonJobTitleProperty, jobTitle, NULL);
                
                CFRelease(jobTitle);
            }
//            NSLog(@"jobTitle is %@", jobTitle);
            
            // department
            
            CFStringRef department = [self copyContactStringProperty:contact fromProperty:(const uint8_t*) "department"];
            
            if (department)
            {
                ABRecordSetValue(person, kABPersonDepartmentProperty, department, NULL);
                
//                NSLog(@"department is %@", department);
                CFRelease(department);
            }
            
            // note
            
            CFStringRef note = [self copyContactStringProperty:contact fromProperty:(const uint8_t*) "note"];
            
            if (note != NULL)
            {
                ABRecordSetValue(person, kABPersonNoteProperty, note, NULL);
                
//                NSLog(@"note is %@", note);
                CFRelease(note);
            }
            
            // emails
            
            ABMultiValueRef emails = [self copyContactMultiStringProperty:contact fromProperty:(const uint8_t *) "emails"];
            
            if (emails != NULL)
            {
                ABRecordSetValue(person, kABPersonEmailProperty, emails, NULL);
                
//                NSLog(@"emails is %@", emails);
                CFRelease(emails);
            }
            
            // phones
            
            ABMultiValueRef phones = [self copyContactMultiStringProperty:contact fromProperty:(const uint8_t *) "phones"];
            
            if (phones != NULL)
            {
                ABRecordSetValue(person, kABPersonPhoneProperty, phones, NULL);
                
//                NSLog(@"phones is %@", phones);
                CFRelease(phones);
            }
            
            // related
            
            ABMultiValueRef related = [self copyContactMultiStringProperty:contact fromProperty:(const uint8_t *) "related"];
            
            if (related != NULL)
            {
                ABRecordSetValue(person, kABPersonRelatedNamesProperty, related, NULL);
                
//                NSLog(@"related is %@", related);
                CFRelease(related);
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
            
            ABMultiValueRef profiles = [self copyContactMultiDictionaryProperty:contact fromProperty:(const uint8_t *) "profiles" withKeys:profileKeys];
            
            if (profiles)
            {
                ABRecordSetValue(person, kABPersonSocialProfileProperty, profiles, NULL);
                
//                NSLog(@"profiles is %@", profiles);
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
            
            ABMultiValueRef address = [self copyContactMultiDictionaryProperty:contact fromProperty:(const uint8_t *) "address" withKeys:addressKeys];
            
            if (address)
            {
                ABRecordSetValue(person, kABPersonAddressProperty, address, NULL);
                
//                NSLog(@"address is %@", address);
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
    
    FREResult result = FREGetObjectProperty(contact, (const uint8_t*) "recordId", &value, NULL);
    
    if (result == FRE_OK)
    {
        int32_t id;
        
        result = FREGetObjectAsInt32(value, &id);
        
        if (result == FRE_OK)
            return id;
    }
    
    return -1;
}

+(CFStringRef) copyContactStringProperty:(FREObject) contact fromProperty:(const uint8_t*) propertyName
{
    FREObject value = NULL;
    
    FREResult result = FREGetObjectProperty(contact, propertyName, &value, NULL);
    
    if (value && result == FRE_OK)
    {
        uint32_t length;
        
        const uint8_t* buffer;
        
        result = FREGetObjectAsUTF8(value, &length, &buffer);
        
        if (buffer != NULL && result == FRE_OK)
        {
            return CFStringCreateWithCString(NULL, (const char*) buffer, kCFStringEncodingUTF8);
        }
    }
    
    return  NULL;
}

+(CFDateRef) getContactPropertyAsDate:(FREObject) contact fromProperty:(const uint8_t*) propertyName
{
    FREObject value;
    FREResult result = FREGetObjectProperty(contact, propertyName, &value, NULL);
    
    if (value && result == FRE_OK)
    {
        NSDate* date;
        
        [Contacts_FRETypeConversion Contacts_convertFREDateToNSDate:value asDate:&date];
        
        return (__bridge CFDateRef) date;
    }
    
    return NULL;
}

+(ABMultiValueRef) copyContactMultiStringProperty:(FREObject) contact fromProperty:(const uint8_t*) propertyName
{
    FREObject array = NULL;
    FREResult result = FREGetObjectProperty(contact, propertyName, &array, NULL);
    
    if (array && result == FRE_OK)
    {
        ABMultiValueRef dictionary = ABMultiValueCreateMutable(kABMultiStringPropertyType);
        
        uint32_t n;
        FREGetArrayLength(array, &n);
        
        for (uint32_t i = 0; i < n; i++)
        {
            FREObject item;
            result = FREGetArrayElementAt(array, i, &item);
            
            if (result != FRE_OK)
                continue;
            
            FREObject itemLabel;
            result = FREGetObjectProperty(item, (const uint8_t*) "label", &itemLabel, NULL);
            
            if (result != FRE_OK)
                continue;

            NSString* label;
            
            [Contacts_FRETypeConversion Contacts_convertFREStringToNSString:itemLabel asString:&label];
            
            FREObject itemValue;
            result = FREGetObjectProperty(item, (const uint8_t*) "value", &itemValue, NULL);
            
            if (result != FRE_OK)
                continue;
            
            NSString* value;
            [Contacts_FRETypeConversion Contacts_convertFREStringToNSString:itemValue asString:&value];

//            NSLog(@"label:%@", label);
//            NSLog(@"value:%@", value);

            ABMultiValueAddValueAndLabel(dictionary, CFBridgingRetain(value), CFBridgingRetain(label), NULL);
        }
        
        return dictionary;
    }
    else
    {
        return NULL;
    }
}

+(ABMultiValueRef) copyContactMultiDictionaryProperty:(FREObject) contact fromProperty:(const uint8_t*) propertyName withKeys:(NSArray*) dictionaryKeys
{
    FREObject array = NULL;
    FREResult result = FREGetObjectProperty(contact, propertyName, &array, NULL);
    
    if (array && result == FRE_OK)
    {
        uint32_t n;
        result = FREGetArrayLength(array, &n);
        
        if (result != FRE_OK)
            return NULL;
     
        ABMultiValueRef dictionary = ABMultiValueCreateMutable(kABMultiDictionaryPropertyType);

        for (uint32_t i = 0; i < n; i++)
        {
            FREObject item;
            result = FREGetArrayElementAt(array, i, &item);
            
            if (result != FRE_OK)
                continue;
            
            NSUInteger dictionaryKeyCount = [dictionaryKeys count];
            
            CFStringRef keys[dictionaryKeyCount];
            CFStringRef values[dictionaryKeyCount];
            
            for (NSUInteger j = 0; j < dictionaryKeyCount; j++)
            {
                NSString* key = [dictionaryKeys objectAtIndex:j];
                
                FREObject valueObject;
                result = FREGetObjectProperty(item, (const uint8_t *) [key UTF8String], &valueObject, nil);
                
                if (result != FRE_OK)
                    continue;
                
                if (valueObject == NULL)
                    continue;
                
                uint32_t length;
                const uint8_t* valueInUTF8;
                
                result = FREGetObjectAsUTF8(valueObject, &length, &valueInUTF8);
                
                if (result != FRE_OK)
                    continue;
                
                NSString* value = [NSString stringWithUTF8String:(const char *) valueInUTF8];
                
                keys[j] = CFBridgingRetain(key);
                values[j] = CFBridgingRetain(value);
                
//                keys[j] = (__bridge CFStringRef)(key);
//                values[j] = (__bridge CFStringRef)(value);
                
//                NSLog(@"key=%@", key);
//                NSLog(@"value=%@", value);
            }
            
            CFDictionaryRef dict = CFDictionaryCreate(kCFAllocatorDefault, (void*) keys, (void*)values, dictionaryKeyCount, NULL, NULL);
            
            ABMultiValueAddValueAndLabel(dictionary, dict, NULL, NULL);
            
            CFRelease(dict);
        }
        
        return dictionary;
    }
    
    return NULL;
}

@end

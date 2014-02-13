//
//  AddressBookProviderFRERoutines.m
//  Contacts
//
//  Created by Maxim on 10/2/13.
//  Copyright (c) 2013 Max Rozdobudko. All rights reserved.
//

#import "AddressBookProviderFRERetriever.h"

@implementation AddressBookProviderFRERetriever

#pragma mark Utility methods

+(FREObject) createContactFromPerson:(ABRecordRef) person
{
    FREObject contact;
    FRENewObject((const uint8_t*) "Object", 0, NULL, &contact, NULL);
    
    // recordId
    
    [self setContactIntegerProperty:contact forProperty:(const uint8_t *) "recordId" withValue:ABRecordGetRecordID(person)];
    
    // compositeName
    
    [self setContactStringProperty:contact forProperty:(const uint8_t *) "compositeName" withValue:CFBridgingRelease(ABRecordCopyCompositeName(person))];
    
    // firstName
    
    [self setContactStringProperty:contact forProperty:(const uint8_t *) "firstName" withValue:CFBridgingRelease(ABRecordCopyValue(person, kABPersonFirstNameProperty))];
    
    // lastName
    
    [self setContactStringProperty:contact forProperty:(const uint8_t *) "lastName" withValue:CFBridgingRelease(ABRecordCopyValue(person, kABPersonLastNameProperty))];
    
    // middleName TODO
    
    [self setContactStringProperty:contact forProperty:(const uint8_t *) "lastName" withValue:CFBridgingRelease(ABRecordCopyValue(person, kABPersonLastNameProperty))];
    
    // prefix
    
    [self setContactStringProperty:contact forProperty:(const uint8_t *) "middleName" withValue:CFBridgingRelease(ABRecordCopyValue(person, kABPersonMiddleNameProperty))];
    
    // suffix
    
    [self setContactStringProperty:contact forProperty:(const uint8_t *) "suffix" withValue:CFBridgingRelease(ABRecordCopyValue(person, kABPersonSuffixProperty))];
    
    // nickname
    
    [self setContactStringProperty:contact forProperty:(const uint8_t *) "nickname" withValue:CFBridgingRelease(ABRecordCopyValue(person, kABPersonNicknameProperty))];
    
    // firstNamePhonetic
    
    [self setContactStringProperty:contact forProperty:(const uint8_t *) "firstNamePhonetic" withValue:CFBridgingRelease(ABRecordCopyValue(person, kABPersonFirstNamePhoneticProperty))];
    
    // lastNamePhonetic
    
    [self setContactStringProperty:contact forProperty:(const uint8_t *) "lastNamePhonetic" withValue:CFBridgingRelease(ABRecordCopyValue(person, kABPersonLastNamePhoneticProperty))];
    
    // middleNamePhonetic
    
    [self setContactStringProperty:contact forProperty:(const uint8_t *) "middleNamePhonetic" withValue:CFBridgingRelease(ABRecordCopyValue(person, kABPersonMiddleNamePhoneticProperty))];
    
    // organization
    
    [self setContactStringProperty:contact forProperty:(const uint8_t *) "organization" withValue:CFBridgingRelease(ABRecordCopyValue(person, kABPersonOrganizationProperty))];
    
    // jobTitle
    
    [self setContactStringProperty:contact forProperty:(const uint8_t *) "jobTitle" withValue:CFBridgingRelease(ABRecordCopyValue(person, kABPersonJobTitleProperty))];
    
    // department
    
    [self setContactStringProperty:contact forProperty:(const uint8_t *) "department" withValue:CFBridgingRelease(ABRecordCopyValue(person, kABPersonDepartmentProperty))];
    
    // note
    
    [self setContactStringProperty:contact forProperty:(const uint8_t *) "note" withValue:CFBridgingRelease(ABRecordCopyValue(person, kABPersonNoteProperty))];
    
    // birthday
    
    [self setContactDateProperty:contact forProperty:(const uint8_t *) "birthday" withValue:CFBridgingRelease(ABRecordCopyValue(person, kABPersonBirthdayProperty))];
    
    // creationDate
    
    [self setContactDateProperty:contact forProperty:(const uint8_t *) "creationDate" withValue:CFBridgingRelease(ABRecordCopyValue(person, kABPersonCreationDateProperty))];
    
    // modificationDate
    
    [self setContactDateProperty:contact forProperty:(const uint8_t *) "modificationDate" withValue:CFBridgingRelease(ABRecordCopyValue(person, kABPersonModificationDateProperty))];
    
    // emails
    
    ABMultiValueRef emails = ABRecordCopyValue(person, kABPersonEmailProperty);
    
    CFIndex emailCount = ABMultiValueGetCount(emails);
    
    if (emailCount > 0)
        [self setContactMultiStringProperty:contact forProperty:(const uint8_t *) "emails" withValue:emails];
    else
        FRESetObjectProperty(contact, (const uint8_t *) "emails", NULL, NULL);
    
    if (emails)
        CFRelease(emails);
    
    // phones
    
    ABMultiValueRef phones = ABRecordCopyValue(person, kABPersonPhoneProperty);
    
    CFIndex phoneCount = ABMultiValueGetCount(phones);
    
    if (phoneCount > 0)
        [self setContactMultiStringProperty:contact forProperty:(const uint8_t *) "phones" withValue:phones];

    else
        FRESetObjectProperty(contact, (const uint8_t *) "phones", NULL, NULL);
    
    if (phones)
        CFRelease(phones);
    
    // address
    
    ABMultiValueRef address = ABRecordCopyValue(person, kABPersonAddressProperty);
    
    CFIndex addressCount = ABMultiValueGetCount(address);
    
    if (addressCount > 0)
        [self setContactMultiObjectProperty:contact forProperty:(const uint8_t *) "address" withValue:address];
    else
        FRESetObjectProperty(contact, (const uint8_t *) "address", NULL, NULL);
    
    if (address)
        CFRelease(address);
    
    // profiles
    
    ABMultiValueRef profiles = ABRecordCopyValue(person, kABPersonSocialProfileProperty);
    
    CFIndex profileCount = ABMultiValueGetCount(profiles);
    
    if (profileCount > 0)
        [self setContactMultiObjectProperty:contact forProperty:(const uint8_t *) "profiles" withValue:profiles];
    else
        FRESetObjectProperty(contact, (const uint8_t *) "profiles", NULL, NULL);
    
    if (profiles)
        CFRelease(profiles);
    
    // thumbnail
    
    if (ABPersonHasImageData(person))
    {
        [self setContactBitmapDataProperty:contact forProperty:(const uint8_t *) "thumbnail" withValue:CFBridgingRelease(ABPersonCopyImageDataWithFormat(person, kABPersonImageFormatThumbnail))];
    }
    else
    {
        FRESetObjectProperty(contact, (const uint8_t*) "thumbnail", NULL, NULL);
    }
    
    return contact;
}

+(void) setContactIntegerProperty:(FREObject) contact forProperty:(const uint8_t*) propertyName withValue:(int32_t) value
{
    FREObject propertyValue;
    FRENewObjectFromInt32(value, &propertyValue);
    
    FRESetObjectProperty(contact, propertyName, propertyValue, NULL);
}


+(void) setContactStringProperty:(FREObject) contact forProperty:(const uint8_t*) propertyName withValue:(NSString*) value
{
    if (value)
    {
        FREObject propertyValue;
        
        [Contacts_FRETypeConversion Contacts_convertNSStringToFREString:value asString:&propertyValue];
        
        FRESetObjectProperty(contact, propertyName, propertyValue, NULL);
    }
    else
    {
        FRESetObjectProperty(contact, propertyName, NULL, NULL);
    }    
}

+(void) setContactDateProperty:(FREObject) contact forProperty:(const uint8_t*) propertyName withValue:(NSDate*) value
{
    if (value)
    {
        FREObject propertyValue;
        
        [Contacts_FRETypeConversion Contacts_convertNSDateToFREDate:value asDate:&propertyValue];
        
        FRESetObjectProperty(contact, propertyName, propertyValue, NULL);
    }
    else
    {
        FRESetObjectProperty(contact, propertyName, NULL, NULL);
    }
}

+(void) setContactMultiStringProperty:(FREObject) contact forProperty:(const uint8_t*) propertyName withValue:(ABMultiValueRef) valueToInsert
{
    CFIndex n = ABMultiValueGetCount(valueToInsert);
    
    if (n > 0)
    {
        FREObject array;
        FRENewObject((const uint8_t*) "Array", 0, NULL, &array, NULL);
        
        FRESetArrayLength(array, (uint32_t) n);
        
        for (CFIndex i = 0; i < n; i++)
        {
            CFStringRef propertyLabel = ABMultiValueCopyLabelAtIndex(valueToInsert, i);
            CFStringRef propertyValue = ABMultiValueCopyValueAtIndex(valueToInsert, i);
            
            FREObject item;
            FRENewObject((const uint8_t*) "Object", 0, NULL, &item, NULL);
            
            if (propertyLabel)
            {
                FREObject itemLabel;
                
                [Contacts_FRETypeConversion Contacts_convertNSStringToFREString:CFBridgingRelease(propertyLabel) asString:&itemLabel];
                
                FRESetObjectProperty(item, (const uint8_t*) "label", itemLabel, NULL);
            }
            
            if (propertyValue)
            {
                FREObject itemValue;
                
                [Contacts_FRETypeConversion Contacts_convertNSStringToFREString:CFBridgingRelease(propertyValue) asString:&itemValue];
                
                FRESetObjectProperty(item, (const uint8_t*) "value", itemValue, NULL);
            }
            
            FRESetArrayElementAt(array, i, item);
        }
        
        FRESetObjectProperty(contact, propertyName, array, NULL);
    }
    else
    {
        FRESetObjectProperty(contact, propertyName, NULL, NULL);
    }
}

+(void) setContactMultiObjectProperty:(FREObject) contact forProperty:(const uint8_t*) propertyName withValue:(ABMultiValueRef) valueToInsert
{
    CFIndex n = ABMultiValueGetCount(valueToInsert);
    
    if (n > 0)
    {
        
        FREObject array;
        FRENewObject((const uint8_t*) "Array", 0, NULL, &array, NULL);
        
        FRESetArrayLength(array, (uint32_t) n);
        
        for (CFIndex i = 0; i < n; i++)
        {
            FREObject item;
            FRENewObject((const uint8_t*) "Object", 0, NULL, &item, NULL);
            
            CFDictionaryRef dictionary = ABMultiValueCopyValueAtIndex(valueToInsert, i);
            
            CFDictionaryApplyFunction(dictionary, dictionaryApplier, item);
            
            FRESetArrayElementAt(array, i, item);
            
            CFRelease(dictionary);
        }
        
        FRESetObjectProperty(contact, propertyName, array, NULL);
    }
    else
    {
        FRESetObjectProperty(contact, propertyName, NULL, NULL);
    }
}

void dictionaryApplier(const void *key, const void *value, void *context)
{
    FREObject item = context;
    
    NSString* itemKey = (__bridge NSString *)(key);
    
    const char* itemKeyInUTF8 = [itemKey UTF8String];
    
    FREObject itemValue;
    
    [Contacts_FRETypeConversion Contacts_convertNSStringToFREString:(__bridge NSString *)(value) asString:&itemValue];
    
    FRESetObjectProperty(item, (const uint8_t*) itemKeyInUTF8, itemValue, NULL);
}

+(void) setContactBitmapDataProperty:(FREObject) contact forProperty:(const uint8_t*) propertyName withValue:(NSData*) valueToInsert
{
    if (valueToInsert)
    {
        // drawing UIImage to BitmapData http://tyleregeto.com/article/drawing-ios-uiviews-to-as3-bitmapdata-via-air
        
        UIImage* image = [UIImage imageWithData:valueToInsert];
        
        // Now we'll pull the raw pixels values out of the image data
        
        CGImageRef imageRef = [image CGImage];
        
        NSUInteger width = CGImageGetWidth(imageRef);
        NSUInteger height = CGImageGetHeight(imageRef);
        
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        
        // Pixel color values will be written here
        
        unsigned char *rawData = malloc(height * width * 4);
        
        NSUInteger bytesPerPixel = 4;
        
        NSUInteger bytesPerRow = bytesPerPixel * width;
        
        NSUInteger bitsPerComponent = 8;
        
        CGContextRef context = CGBitmapContextCreate(rawData, width, height,
                                                     bitsPerComponent, bytesPerRow, colorSpace,
                                                     kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
        
        CGColorSpaceRelease(colorSpace);
        
        CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
        
        CGContextRelease(context);
        
        // Pixels are now in rawData in the format RGBA8888
        // We'll now loop over each pixel write them into the AS3 bitmapData memory
        
        FREObject bmdWidth;
        FRENewObjectFromUint32((uint32_t) width, &bmdWidth);
        
        FREObject bmdHeight;
        FRENewObjectFromUint32((uint32_t) height, &bmdHeight);
        
        FREObject arguments[] = {bmdWidth, bmdHeight};
        
        FREObject bitmapDataInstance;
        FRENewObject((const uint8_t*) "flash.display.BitmapData", 2, arguments, &bitmapDataInstance, NULL);
        
        FREBitmapData bmd;
        FREAcquireBitmapData(bitmapDataInstance, &bmd);
        
        int x, y;
        
        // There may be extra pixels in each row due to the value of
        // bmd.lineStride32, we'll skip over those as needed
        
        int offset = bmd.lineStride32 - bmd.width;
        
        int offset2 = bytesPerRow - bmd.width*4;
        
        int byteIndex = 0;
        
        uint32_t *bmdPixels = bmd.bits32;
        
        for(y=0; y<bmd.height; y++)
        {
            for(x=0; x<bmd.width; x++, bmdPixels ++, byteIndex += 4)
            {
                // Values are currently in RGBA8888, so each colour
                
                // value is currently a separate number
                
                int red   = (rawData[byteIndex]);
                int green = (rawData[byteIndex + 1]);
                int blue  = (rawData[byteIndex + 2]);
                int alpha = (rawData[byteIndex + 3]);
                
                // Combine values into ARGB32
                
                * bmdPixels = (alpha << 24) | (red << 16) | (green << 8) | blue;
            }
            
            bmdPixels += offset;
            byteIndex += offset2;
        }
        
        free(rawData);
        
        FREInvalidateBitmapDataRect(bitmapDataInstance, 0, 0, bmd.width, bmd.height);
        
        FREReleaseBitmapData(bitmapDataInstance);
        
        // free the the memory we allocated
        
        FRESetObjectProperty(contact, propertyName, bitmapDataInstance, NULL);
    }
    else
    {
        FRESetObjectProperty(contact, propertyName, NULL, NULL);
    }
}

@end

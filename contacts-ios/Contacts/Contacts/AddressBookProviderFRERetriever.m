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
    
    [self setContactStringProperty:contact forProperty:(const uint8_t *) "compositeName" withValue:ABRecordCopyCompositeName(person)];
    
    // firstName
    
    [self setContactStringProperty:contact forProperty:(const uint8_t *) "firstName" withValue:ABRecordCopyValue(person, kABPersonFirstNameProperty)];
    
    // lastName
    
    [self setContactStringProperty:contact forProperty:(const uint8_t *) "lastName" withValue:ABRecordCopyValue(person, kABPersonLastNameProperty)];
    
    // middleName
    
    [self setContactStringProperty:contact forProperty:(const uint8_t *) "lastName" withValue:ABRecordCopyValue(person, kABPersonLastNameProperty)];
    
    // prefix
    
    [self setContactStringProperty:contact forProperty:(const uint8_t *) "middleName" withValue:ABRecordCopyValue(person, kABPersonMiddleNameProperty)];
    
    // suffix
    
    [self setContactStringProperty:contact forProperty:(const uint8_t *) "suffix" withValue:ABRecordCopyValue(person, kABPersonSuffixProperty)];
    
    // nickname
    
    [self setContactStringProperty:contact forProperty:(const uint8_t *) "nickname" withValue:ABRecordCopyValue(person, kABPersonNicknameProperty)];
    
    // firstNamePhonetic
    
    [self setContactStringProperty:contact forProperty:(const uint8_t *) "firstNamePhonetic" withValue:ABRecordCopyValue(person, kABPersonFirstNamePhoneticProperty)];
    
    // lastNamePhonetic
    
    [self setContactStringProperty:contact forProperty:(const uint8_t *) "lastNamePhonetic" withValue:ABRecordCopyValue(person, kABPersonLastNamePhoneticProperty)];
    
    // middleNamePhonetic
    
    [self setContactStringProperty:contact forProperty:(const uint8_t *) "middleNamePhonetic" withValue:ABRecordCopyValue(person, kABPersonMiddleNamePhoneticProperty)];
    
    // organization
    
    [self setContactStringProperty:contact forProperty:(const uint8_t *) "organization" withValue:ABRecordCopyValue(person, kABPersonOrganizationProperty)];
    
    // jobTitle
    
    [self setContactStringProperty:contact forProperty:(const uint8_t *) "jobTitle" withValue:ABRecordCopyValue(person, kABPersonJobTitleProperty)];
    
    // department
    
    [self setContactStringProperty:contact forProperty:(const uint8_t *) "department" withValue:ABRecordCopyValue(person, kABPersonDepartmentProperty)];
    
    // note
    
    [self setContactStringProperty:contact forProperty:(const uint8_t *) "note" withValue:ABRecordCopyValue(person, kABPersonNoteProperty)];
    
    // emails
    
    [self setContactMultiStringProperty:contact forProperty:(const uint8_t *) "emails" withValue:ABRecordCopyValue(person, kABPersonEmailProperty)];
    
    // phones
    
    [self setContactMultiStringProperty:contact forProperty:(const uint8_t *) "phones" withValue:ABRecordCopyValue(person, kABPersonPhoneProperty)];
    
    // birthday
    
    [self setContactDateProperty:contact forProperty:(const uint8_t *) "birthday" withValue:ABRecordCopyValue(person, kABPersonBirthdayProperty)];
    
    // creationDate
    
    [self setContactDateProperty:contact forProperty:(const uint8_t *) "creationDate" withValue:ABRecordCopyValue(person, kABPersonCreationDateProperty)];
    
    // modificationDate
    
    [self setContactDateProperty:contact forProperty:(const uint8_t *) "modificationDate" withValue:ABRecordCopyValue(person, kABPersonModificationDateProperty)];
    
    // address
    
    [self setContactMultiObjectProperty:contact forProperty:(const uint8_t *) "address" withValue:ABRecordCopyValue(person, kABPersonAddressProperty)];
    
    // profiles
    
    [self setContactMultiObjectProperty:contact forProperty:(const uint8_t *) "profiles" withValue:ABRecordCopyValue(person, kABPersonSocialProfileProperty)];
    
    // thumbnail
    
    if (ABPersonHasImageData(person))
    {
        [self setContactBitmapDataProperty:contact forProperty:(const uint8_t *) "thumbnail" withValue:ABPersonCopyImageDataWithFormat(person, kABPersonImageFormatThumbnail)];
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


+(void) setContactStringProperty:(FREObject) contact forProperty:(const uint8_t*) propertyName withValue:(CFStringRef) value
{
    if (value)
    {
        FREObject propertyValue;
        
        [FRETypeConversion convertNSStringToFREString:CFBridgingRelease(value) asString:&propertyValue];
        
        FRESetObjectProperty(contact, propertyName, propertyValue, NULL);
    }
    else
    {
        FRESetObjectProperty(contact, propertyName, NULL, NULL);
    }    
}

+(void) setContactDateProperty:(FREObject) contact forProperty:(const uint8_t*) propertyName withValue:(CFDateRef) value
{
    if (value)
    {
        FREObject propertyValue;
        
        [FRETypeConversion convertNSDateToFREDate:CFBridgingRelease(value) asDate:&propertyValue];
        
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
                
                [FRETypeConversion convertNSStringToFREString:CFBridgingRelease(propertyLabel) asString:&itemLabel];
                
                FRESetObjectProperty(item, (const uint8_t*) "label", itemLabel, NULL);
            }
            
            if (propertyValue)
            {
                FREObject itemValue;
                
                [FRETypeConversion convertNSStringToFREString:CFBridgingRelease(propertyValue) asString:&itemValue];
                
                FRESetObjectProperty(item, (const uint8_t*) "value", itemValue, NULL);
            }
            
            FRESetArrayElementAt(array, i, item);
        }
        
        CFRelease(valueToInsert);
        
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
        
        CFRelease(valueToInsert);
        
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
    
    [FRETypeConversion convertNSStringToFREString:(__bridge NSString *)(value) asString:&itemValue];
    
    FRESetObjectProperty(item, (const uint8_t*) itemKeyInUTF8, itemValue, NULL);
}

+(void) setContactBitmapDataProperty:(FREObject) contact forProperty:(const uint8_t*) propertyName withValue:(CFDataRef) valueToInsert
{
    if (valueToInsert)
    {
        // drawing UIImage to BitmapData http://tyleregeto.com/article/drawing-ios-uiviews-to-as3-bitmapdata-via-air
        
        UIImage* image = [UIImage imageWithData:CFBridgingRelease(valueToInsert)];
        
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

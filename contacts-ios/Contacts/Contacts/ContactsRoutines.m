//
//  ContactsConversionRoutines.m
//  Contacts
//
//  Created by Maxim on 9/11/13.
//  Copyright (c) 2013 Max Rozdobudko. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FlashRuntimeExtensions.h"

#import "ContactsRoutines.h"

@implementation ContactsRoutines

@end

#pragma mark C Interface

#pragma mark Event Dispatching functions

void dispatchErrorEvent(FREContext context, NSString* code)
{
    FREDispatchStatusEventAsync(context, (const uint8_t*) [code UTF8String], (const uint8_t*) "error");
}

void dispatchStatusEvent(FREContext context, NSString* code)
{
    FREDispatchStatusEventAsync(context, (const uint8_t*) [code UTF8String], (const uint8_t*) "status");
}

void dispatchResponseEvent(FREContext context, NSUInteger callId, NSString* status, NSString* method)
{
    NSString* code = [NSString stringWithFormat:@"{\"object\":\"response\", \"callId\":%i, \"method\":\"%@\", \"status\":\"%@\"}", callId, method, status];
    
    FREDispatchStatusEventAsync(context, (const uint8_t*) [code UTF8String], (const uint8_t*) "response");
}

#pragma mark Utility functions

void setStringProperty(FREObject object, const uint8_t* name, NSString* value)
{
    if (value)
    {
        FREObject propertyValue;
        
        const char* valueInUTF8 = [value UTF8String];
        
        FRENewObjectFromUTF8(strlen(valueInUTF8) + 1, (const uint8_t*) valueInUTF8, &propertyValue);
        
        FRESetObjectProperty(object, name, propertyValue, NULL);
    }
    else
    {
        FRESetObjectProperty(object, name, NULL, NULL);
    }
}

void setIntegerProperty(FREObject object, const uint8_t* name, NSInteger value)
{
    FREObject propertyValue;
    
    FRENewObjectFromInt32((int32_t) value, &propertyValue);
    
    FRESetObjectProperty(object, name, propertyValue, NULL);
}

void setDateProperty(FREObject object, const uint8_t* name, NSDate* value)
{
    if (value)
    {
        FREObject propertyValue = NULL;
        FRENewObject((const uint8_t*) "Date", 0, NULL, &propertyValue, NULL);
        
        NSTimeInterval valueSince1970 = [value timeIntervalSince1970] * 1000;
        
        FREObject time;
        FRENewObjectFromDouble(valueSince1970, &time);
        
        FREObject args[] = {time};
        
        FREObject result;
        FRECallObjectMethod(propertyValue, (const uint8_t*) "setTime", 1, args, &result, NULL);
        
        
        FRESetObjectProperty(object, name, propertyValue, NULL);
    }
    else
    {
        FRESetObjectProperty(object, name, NULL, NULL);
    }
}

void setArrayStringsProperty(FREObject object, const uint8_t* name, NSArray* value)
{
    NSUInteger itemCount = [value count];
    
    FREObject array;
    
    FRENewObject((const uint8_t*) "Array", 0, NULL, &array, NULL);
    
    FRESetArrayLength(array, (uint32_t) itemCount);
    
    for (NSUInteger i = 0; i < itemCount; i++)
    {
        NSDictionary* item = [value objectAtIndex:i];
        
        NSString* itemValue = [[item allValues] objectAtIndex:0];
        NSString* itemLabel = [[item allKeys] objectAtIndex:0];
        
        FREObject itemToInsert;
        FRENewObject((const uint8_t*) "Object", 0, NULL, &itemToInsert, NULL);
        
        if (itemValue)
        {
            const char* itemValueInUTF8 = [itemValue UTF8String];
            
            FREObject itemToInsertValue;
            FRENewObjectFromUTF8(strlen(itemValueInUTF8) + 1, (const uint8_t*) itemValueInUTF8, &itemToInsertValue);
            
            FRESetObjectProperty(itemToInsert, (const uint8_t *) "value", itemToInsertValue, NULL);
        }
        
        if (itemLabel)
        {
            const char* itemLabelInUTF8 = [itemLabel UTF8String];
            
            FREObject itemToInsertLabel;
            FRENewObjectFromUTF8(strlen(itemLabelInUTF8) + 1, (const uint8_t*) itemLabelInUTF8, &itemToInsertLabel);
            
            FRESetObjectProperty(itemToInsert, (const uint8_t *) "label", itemToInsertLabel, NULL);
        }
        
        FRESetArrayElementAt(array, (uint32_t) i, itemToInsert);
    }
    
    FRESetObjectProperty(object, name, array, NULL);
}

void setArrayObjectsProperty(FREObject object, const uint8_t* name, NSArray* value)
{
    FREObject array;
    FRENewObject((const uint8_t*) "Array", 0, NULL, &array, NULL);
    
    NSUInteger n = [value count];
    
    FRESetArrayLength(array, (uint32_t) n);
    
    for (NSUInteger i = 0; i < n; i++)
    {
        NSDictionary* item = [value objectAtIndex:i];
        
        FREObject itemToInsert;
        FRENewObject((const uint8_t*) "Object", 0, NULL, &itemToInsert, NULL);
        
        NSArray* allKeys = [item allKeys];
        NSArray* allValues = [item allValues];
        
        NSUInteger m = [allValues count];
        for (NSUInteger j = 0; j < m; j++)
        {
            NSString* itemKey = [allKeys objectAtIndex:j];
            NSString* itemValue = [allValues objectAtIndex:j];
            
            if (itemKey && itemValue)
            {
                const char* itemKeyInUTF8 = [itemKey UTF8String];
                
                setStringProperty(itemToInsert, (const uint8_t*) itemKeyInUTF8, itemValue);
            }
        }
        
        FRESetArrayElementAt(array, (uint32_t) i, itemToInsert);
    }
    
    FRESetObjectProperty(object, name, array, NULL);
}

void setBitmapProperty(FREObject object, const uint8_t* name, NSData* value)
{
    // drawing UIImage to BitmapData http://tyleregeto.com/article/drawing-ios-uiviews-to-as3-bitmapdata-via-air
    
    if (!value)
    {
        FRESetObjectProperty(object, name, NULL, NULL);
        
        return;
    }
    
    UIImage* image = [UIImage imageWithData:value];
    
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
    
    FRESetObjectProperty(object, name, bitmapDataInstance, NULL);
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
    
    // recordId
    
    NSNumber* recordId = [person valueForKey:@"recordId"];
    
    setIntegerProperty(contact, (const uint8_t*) "recordId", [recordId integerValue]);
    
    // compositeName

    NSString* compositeName = [person valueForKey:@"compositeName"];
    
    setStringProperty(contact, (const uint8_t*) "compositeName", compositeName);

    // firstName
    
    NSString* firstName = [person valueForKey:@"firstName"];
    
    setStringProperty(contact, (const uint8_t*) "firstName", firstName);
    
    // lastName
    
    NSString* lastName = [person valueForKey:@"lastName"];
    
    setStringProperty(contact, (const uint8_t*) "lastName", lastName);
    
    // middleName
    
    NSString* middleName = [person valueForKey:@"middleName"];
    
    setStringProperty(contact, (const uint8_t*) "middleName", middleName);

    // prefixProperty
    
    NSString* prefixProperty = [person valueForKey:@"prefixProperty"];
    
    setStringProperty(contact, (const uint8_t*) "prefixProperty", prefixProperty);
    
    // suffixProperty
    
    NSString* suffixProperty = [person valueForKey:@"suffixProperty"];
    
    setStringProperty(contact, (const uint8_t*) "suffixProperty", suffixProperty);
    
    // nickname
    
    NSString* nickname = [person valueForKey:@"nickname"];
    
    setStringProperty(contact, (const uint8_t*) "nickname", nickname);
    
    // firstNamePhonetic
    
    NSString* firstNamePhonetic = [person valueForKey:@"firstNamePhonetic"];
    
    setStringProperty(contact, (const uint8_t*) "firstNamePhonetic", firstNamePhonetic);
    
    // lastNamePhonetic
    
    NSString* lastNamePhonetic = [person valueForKey:@"lastNamePhonetic"];
    
    setStringProperty(contact, (const uint8_t*) "lastNamePhonetic", lastNamePhonetic);
    
    // middleNamePhonetic
    
    NSString* middleNamePhonetic = [person valueForKey:@"middleNamePhonetic"];
    
    setStringProperty(contact, (const uint8_t*) "middleNamePhonetic", middleNamePhonetic);
    
    // birthday
    
    NSDate* birthday = [person valueForKey:@"birthday"];

    setDateProperty(contact, (const uint8_t*) "birthday", birthday);
    
    // organization
    
    NSString* organization = [person valueForKey:@"organization"];
    
    setStringProperty(contact, (const uint8_t*) "organization", organization);
    
    // jobTitle
    
    NSString* jobTitle = [person valueForKey:@"jobTitle"];
    
    setStringProperty(contact, (const uint8_t*) "jobTitle", jobTitle);
    
    // department
    
    NSString* department = [person valueForKey:@"department"];
    
    setStringProperty(contact, (const uint8_t*) "department", department);
    
    // note
    
    NSString* note = [person valueForKey:@"note"];
    
    setStringProperty(contact, (const uint8_t*) "note", note);
    
    // emails

    NSArray* emails = [person valueForKey:@"emails"];
    
    setArrayStringsProperty(contact, (const uint8_t*) "emails", emails);

    // phones
    
    NSArray* phones = [person valueForKey:@"phones"];
    
    setArrayStringsProperty(contact, (const uint8_t*) "phones", phones);
    
    // thumbnail
    
    NSData* thumbnail = [person valueForKey:@"thumbnail"];
    
    setBitmapProperty(contact, (const uint8_t*) "thumbnail", thumbnail);
    
    // profiles
    
    NSArray* profiles = [person valueForKey:@"profiles"];
    
    setArrayObjectsProperty(contact, (const uint8_t*) "profiles", profiles);
    
    // address
    
    NSArray* address = [person valueForKey:@"address"];
    
    setArrayObjectsProperty(contact, (const uint8_t*) "address", address);
    
    // creationDate
    
    NSDate* creationDate = [person valueForKey:@"creationDate"];
    
    setDateProperty(contact, (const uint8_t*) "creationDate", creationDate);
    
    // modificationDate
    
    NSDate* modificationDate = [person valueForKey:@"modificationDate"];
    
    setDateProperty(contact, (const uint8_t*) "modificationDate", modificationDate);
    
    // return contact object
    
    return contact;
}

FREObject peopleToContacts(NSArray* people)
{
    FREObject result = NULL;
    
    if (people)
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

//
//  FRETypeConversion.m
//  Contacts
//
//  Created by Maxim on 9/25/13.
//  Copyright (c) 2013 Max Rozdobudko. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FlashRuntimeExtensions.h"

#import "FRETypeConversion.h"

@implementation FRETypeConversion

+(FREResult) convertFREStringToNSString:(FREObject) string asString:(NSString**) toString
{
    FREResult result;
    
    uint32_t length = 0;
    const uint8_t* tempValue = NULL;
    
    result = FREGetObjectAsUTF8(string, &length, &tempValue);
    
    if(result != FRE_OK) return result;
    
    *toString = [NSString stringWithUTF8String: (char*) tempValue];
    
    return FRE_OK;
}

+(FREResult) convertNSStringToFREString:(NSString*) string asString:(FREObject*) toString
{
    if (string == nil) return FRE_INVALID_ARGUMENT;
    
    const char* utf8String = string.UTF8String;
    
    unsigned long length = strlen( utf8String );
    
    return FRENewObjectFromUTF8(length + 1, (const uint8_t*) utf8String, toString);
}

+(FREResult) convertFREDateToNSDate:(FREObject) date asDate:(NSDate*) toDate
{
    FREResult result;
    
    FREObject time;
    result = FREGetObjectProperty(date, (const uint8_t*) "time", &time, NULL);
    if (result != FRE_OK) return result;
    
    NSTimeInterval interval;
    result = FREGetObjectAsDouble(time, &interval);
    if (result != FRE_OK) return result;
    
    interval = interval / 1000;
    
    toDate = [NSDate dateWithTimeIntervalSince1970:interval];
    
    return result;
}

+(FREResult) convertNSDateToFREDate:(NSDate*) date asDate:(FREObject*) toDate
{
    NSTimeInterval timestamp = date.timeIntervalSince1970 * 1000;
    
    FREResult result;
    FREObject time;
    result = FRENewObjectFromDouble( timestamp, &time );
    
    if( result != FRE_OK ) return result;
    result = FRENewObject( (const uint8_t*) "Date", 0, NULL, toDate, NULL );
    if( result != FRE_OK ) return result;
    result = FRESetObjectProperty( *toDate, (const uint8_t*) "time", time, NULL);
    if( result != FRE_OK ) return result;
    
    return FRE_OK;
}

+(FREResult) convertNSDataToFREBitmapData:(NSData*) data asBitmapData:(FREObject*) toData
{
    FREResult result;
    
    // drawing UIImage to BitmapData http://tyleregeto.com/article/drawing-ios-uiviews-to-as3-bitmapdata-via-air
    
    UIImage* image = [UIImage imageWithData:data];
    
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
    result = FRENewObjectFromUint32((uint32_t) width, &bmdWidth);
    if( result != FRE_OK ) return result;
    
    FREObject bmdHeight;
    result = FRENewObjectFromUint32((uint32_t) height, &bmdHeight);
    if( result != FRE_OK ) return result;
    
    FREObject arguments[] = {bmdWidth, bmdHeight};
    
    result = FRENewObject((const uint8_t*) "flash.display.BitmapData", 2, arguments, toData, NULL);
    if( result != FRE_OK ) return result;
    
    FREBitmapData bmd;
    result = FREAcquireBitmapData(*toData, &bmd);
    if( result != FRE_OK ) return result;
    
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
    
    result = FREInvalidateBitmapDataRect(*toData, 0, 0, bmd.width, bmd.height);
    if( result != FRE_OK ) return result;
    
    // free the the memory we allocated
    
    result = FREReleaseBitmapData(*toData);
    
    return result;
}

@end

//
//  FRETypeConversion.m
//  Contacts
//
//  Created by Maxim on 9/25/13.
//  Copyright (c) 2013 Max Rozdobudko. All rights reserved.
//

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

@end

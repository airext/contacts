//
//  FRETypeConversion.h
//  Contacts
//
//  Created by Maxim on 9/25/13.
//  Copyright (c) 2013 Max Rozdobudko. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FlashRuntimeExtensions.h"

@interface Contacts_FRETypeConversion : NSObject

+(FREResult) Contacts_convertFREStringToNSString:(FREObject) string asString:(NSString**) toString;
+(FREResult) Contacts_convertNSStringToFREString:(NSString*) string asString:(FREObject*) toString;

+(FREResult) Contacts_convertFREDateToNSDate:(FREObject) date asDate:(NSDate**) toDate;
+(FREResult) Contacts_convertNSDateToFREDate:(NSDate*) date asDate:(FREObject*) toDate;

+(FREResult) Contacts_convertNSDataToFREBitmapData:(NSData*) data asBitmapData:(FREObject*) toData;

+(FREResult) Contacts_convertFREObjectToNSRange:(FREObject) object asRange:(NSRange*) toRange;

@end
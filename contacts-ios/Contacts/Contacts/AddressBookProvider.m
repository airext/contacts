//
//  AddressBookProvider.m
//  Contacts
//
//  Created by Maxim on 9/9/13.
//  Copyright (c) 2013 Max Rozdobudko. All rights reserved.
//

#import <mach/mach_time.h>

#import "FlashRuntimeExtensions.h"

#import "AddressBookProviderJSONRetriever.h"
#import "AddressBookProviderFRERetriever.h"
#import "AddressBookProviderUpdateRoutines.h"

#import "AddressBookProvider.h"

@implementation AddressBookProvider

#pragma mark Properties

-(void) setAddressBook:(ABAddressBookRef)value
{
    _addressBook = value;
}

#pragma mark Public API

-(BOOL) isModified:(NSDate *)since
{
    uint64_t start;
    uint64_t end;
    uint64_t elapsed;
    
    start = mach_absolute_time();
    
    BOOL result = FALSE;
    
    CFArrayRef people = ABAddressBookCopyArrayOfAllPeople(_addressBook);
    
    NSLog(@"Since: %@", since);
    
    CFIndex n = CFArrayGetCount(people);
    for (int i = 0; i < n; i++)
    {
        ABRecordRef person = CFArrayGetValueAtIndex(people, i);
        
        CFDateRef creationDate = ABRecordCopyValue(person, kABPersonCreationDateProperty);
        CFDateRef modificationDate = ABRecordCopyValue(person, kABPersonModificationDateProperty);
        
        result = CFDateCompare(creationDate, (__bridge CFDateRef)(since), NULL) == kCFCompareGreaterThan ||
        CFDateCompare(modificationDate, (__bridge CFDateRef)(since), NULL) == kCFCompareGreaterThan;
        
        CFRelease(creationDate);
        CFRelease(modificationDate);
        
        if (result)
        {
            break;
        }
    }
    
    CFRelease(people);
    
    end = mach_absolute_time();
    
    elapsed = end - start;
    
    static mach_timebase_info_data_t info;
    
    mach_timebase_info(&info);
    
    uint64_t nanoseconds = elapsed * info.numer / info.denom;
    
    NSLog(@"isModified: before %llu, after %llu, time elapsed was: %llu", start, end, nanoseconds);
    
    return result;
}

#pragma mark Get Contacts

-(NSString*) getContactsAsJSON:(NSRange)range withOptions:(NSDictionary *)options
{
    uint64_t start;
    uint64_t end;
    uint64_t elapsed;
    
    start = mach_absolute_time();

    NSMutableArray* result = [NSMutableArray array];
    
    CFIndex total = ABAddressBookGetPersonCount(_addressBook);
    
    [self checkRangeBounds:range withMaxValue:total withMinValue:0];
    
    CFArrayRef people = ABAddressBookCopyArrayOfAllPeople(_addressBook);
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd/yyyy hh:mm:ss zzz"];
    
    CFIndex n = NSMaxRange(range);
    for (int i = range.location; i < n; i++)
    {
        ABRecordRef person = CFArrayGetValueAtIndex(people, i);
        
        NSDictionary* contact = [AddressBookProviderJSONRetriever createContactFromPerson:person withDateFormatter:formatter];
        
        [result addObject:contact];
    }
    
    CFRelease(people);
    
    NSData* data = [NSJSONSerialization dataWithJSONObject:result options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString* json = [NSString stringWithUTF8String:[data bytes]];
    
    end = mach_absolute_time();
    
    elapsed = end - start;
    
    static mach_timebase_info_data_t info;
    
    mach_timebase_info(&info);
    
    uint64_t nanoseconds = elapsed * info.numer / info.denom;
    
    NSLog(@"Provider.getContactsAsJSON: before %llu, after %llu, time elapsed was: %llu", start, end, nanoseconds);
    
    return json;
}


-(FREObject) getContactsAsFRE:(NSRange)range withOptions:(NSDictionary *)options
{
    uint64_t start;
    uint64_t end;
    uint64_t elapsed;
    
    start = mach_absolute_time();
    
    CFIndex total = ABAddressBookGetPersonCount(_addressBook);
    
    [self checkRangeBounds:range withMaxValue:total withMinValue:0];
    
    FREObject contacts;
    FRENewObject((const uint8_t*) "Array", 0, NULL, &contacts, NULL);
    
    FRESetArrayLength(contacts, (uint32_t) range.length);
    
    CFArrayRef people = ABAddressBookCopyArrayOfAllPeople(_addressBook);
    
    CFIndex n = NSMaxRange(range);
    for (int i = range.location; i < n; i++)
    {
        ABRecordRef person = CFArrayGetValueAtIndex(people, i);
        
        FREObject contact = [AddressBookProviderFRERetriever createContactFromPerson:person];
        
        FRESetArrayElementAt(contacts, (uint32_t) (i - range.location), contact);
    }
    
    CFRelease(people);
    
    end = mach_absolute_time();
    
    elapsed = end - start;
    
    static mach_timebase_info_data_t info;
    
    mach_timebase_info(&info);
    
    uint64_t nanoseconds = elapsed * info.numer / info.denom;
    
    NSLog(@"Provider.getContacts: before %llu, after %llu, time elapsed was: %llu", start, end, nanoseconds);
    
    return contacts;
}

#pragma mark Get Contact Count

-(NSString*) getContactCountAsString
{
    NSNumber* result = [NSNumber numberWithLong:ABAddressBookGetPersonCount(_addressBook)];
    
    return [result stringValue];
}

-(FREObject) getContactCountAsFRE
{
    FREObject result;
    
    int32_t count = (int32_t) ABAddressBookGetPersonCount(_addressBook);
    
    NSLog(@"getContactCount:%i", count);
    
    FRENewObjectFromInt32(count, &result);
    
    return result;
}

#pragma mark Get Thumbnail

-(NSData*) getPersonThumbnail:(NSInteger) recordId
{
    ABRecordRef person = ABAddressBookGetPersonWithRecordID(_addressBook, (ABRecordID) recordId);
    
    return [AddressBookProviderJSONRetriever getContactThumbnail:person];
}

#pragma mark Update Contact

-(BOOL) updateContactWithOptions:(FREObject) contact withOptions:(FREObject) options
{
    return [AddressBookProviderUpdateRoutines updateContactWithOptions:contact withOptions:options];
}

#pragma mark Utilities

-(void) checkRangeBounds: (NSRange) range withMaxValue: (NSInteger) maxValue withMinValue:(NSInteger) minValue
{
    if (range.location == NSNotFound)
        range.location = minValue;
    else
        range.location = MIN(range.location, maxValue);
    
    if (range.length == NSNotFound)
        range.length = maxValue - range.location;
    else
        range.length = MIN(range.length, maxValue - range.location);
}

@end

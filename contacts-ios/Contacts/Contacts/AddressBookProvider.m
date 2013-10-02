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

#pragma mark Main methods

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

-(NSString*) getContactsAsJSON:(NSRange)range withOptions:(NSDictionary *)options
{
    uint64_t start;
    uint64_t end;
    uint64_t elapsed;
    
    start = mach_absolute_time();

    NSMutableArray* result = [NSMutableArray array];
    
    CFIndex total = ABAddressBookGetPersonCount(_addressBook);
    
    if (range.location == NSNotFound)
        range.location = 0;
    
    if (range.length == NSNotFound)
        range.length = total - range.location;
    else
        range.length = MIN(range.length, total - range.location);
    
    CFArrayRef people = ABAddressBookCopyArrayOfAllPeople(_addressBook);
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd/yyyy hh:mm:ss zzz"];
    
    CFIndex n = NSMaxRange(range);
    for (int i = range.location; i < n; i++)
    {
        ABRecordRef person = CFArrayGetValueAtIndex(people, i);
        
        NSDictionary* contact = [AddressBookProviderJSONRetriever createContact:person withDateFormatter:formatter];
        
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

-(NSString*) getContactCountAsString
{
    NSNumber* result = [NSNumber numberWithLong:ABAddressBookGetPersonCount(_addressBook)];
    
    return [result stringValue];
}

-(NSData*) getPersonThumbnail:(NSInteger) recordId
{
    ABRecordRef person = ABAddressBookGetPersonWithRecordID(_addressBook, (ABRecordID) recordId);
    
    return [AddressBookProviderJSONRetriever getContactThumbnail:person];
}

-(BOOL) updateContactWithOptions:(FREObject) contact withOptions:(FREObject) options
{
    return [AddressBookProviderUpdateRoutines updateContactWithOptions:contact withOptions:options];
}

-(FREObject) getContactCountAsFRE
{
    FREObject result;
    FRENewObjectFromInt32(ABAddressBookGetPersonCount(_addressBook), &result);
    
    return result;
}

-(FREObject) getContactsAsFRE:(NSRange)range withOptions:(NSDictionary *)options
{
    uint64_t start;
    uint64_t end;
    uint64_t elapsed;
    
    start = mach_absolute_time();
    
    CFIndex total = ABAddressBookGetPersonCount(_addressBook);
    
    if (range.location == NSNotFound)
        range.location = 0;
    
    if (range.length == NSNotFound)
        range.length = total - range.location;
    else
        range.length = MIN(range.length, total - range.location);
    
    FREObject contacts;
    FRENewObject((const uint8_t*) "Array", 0, NULL, &contacts, NULL);
    
    FRESetArrayLength(contacts, (uint32_t) range.length);
    
    CFArrayRef people = ABAddressBookCopyArrayOfAllPeople(_addressBook);
    
    CFIndex n = NSMaxRange(range);
    for (int i = range.location; i < n; i++)
    {
        ABRecordRef person = CFArrayGetValueAtIndex(people, i);
        
        FREObject contact = [AddressBookProviderFRERetriever createContactFromPerson:person];
        
        FRESetArrayElementAt(contacts, (uint32_t) i, contact);
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

@end

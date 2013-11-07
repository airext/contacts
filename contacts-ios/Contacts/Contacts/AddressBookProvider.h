//
//  AddressBookProvider.h
//  Contacts
//
//  Created by Maxim on 9/9/13.
//  Copyright (c) 2013 Max Rozdobudko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>
#import "FlashRuntimeExtensions.h"

@interface AddressBookProvider : NSObject
{
    @private ABAddressBookRef _addressBook;
}

#pragma mark Properties

-(void) setAddressBook:(ABAddressBookRef) value;

#pragma mark Public API

-(BOOL) isModified:(NSDate*) since;

-(NSString*) getContactCountAsString;

-(FREObject) getContactCountAsFRE;

-(NSString*) getContactsAsJSON:(NSRange) range withOptions:(NSDictionary*) options;

-(FREObject) getContactsAsFRE:(NSRange) range withOptions:(NSDictionary*) options;

-(NSData*) getPersonThumbnail:(NSInteger) recordId;

-(BOOL) updateContactWithOptions:(FREObject) contact withOptions:(FREObject) options;

@end

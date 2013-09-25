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


#pragma mark Methods

-(BOOL) isModified:(NSDate*) since;

//
//-(BOOL) getRecords;

-(NSInteger) getPersonCount;
-(NSArray*) getPeople:(NSRange) range withOptions:(NSDictionary*) options;

//-(BOOL) getGroups;
//
//-(BOOL) updateRecord;

-(BOOL) updateContactWithOptions:(FREObject) contact withOptions:(FREObject) options;

@end

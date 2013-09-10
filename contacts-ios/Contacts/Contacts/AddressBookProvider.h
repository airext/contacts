//
//  AddressBookProvider.h
//  Contacts
//
//  Created by Maxim on 9/9/13.
//  Copyright (c) 2013 Max Rozdobudko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>

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

-(NSArray*) getPeople:(NSRange) range withOptions:(NSDictionary*) options;

//-(BOOL) getGroups;
//
//-(BOOL) updateRecord;

@end

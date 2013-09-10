//
//  AddressBookProviderRoutines.h
//  Contacts
//
//  Created by Maxim on 9/10/13.
//  Copyright (c) 2013 Max Rozdobudko. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <AddressBook/AddressBook.h>

@interface AddressBookProviderRoutines : NSObject

+(NSDictionary*) createContact:(ABRecordRef) person;

@end

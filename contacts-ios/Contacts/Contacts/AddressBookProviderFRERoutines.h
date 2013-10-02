//
//  AddressBookProviderFRERoutines.h
//  Contacts
//
//  Created by Maxim on 10/2/13.
//  Copyright (c) 2013 Max Rozdobudko. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

#import <AddressBook/AddressBook.h>

#import "FlashRuntimeExtensions.h"

#import "FRETypeConversion.h"

@interface AddressBookProviderFRERoutines : NSObject

+(FREObject) createContactFromPerson:(ABRecordRef) person;

@end

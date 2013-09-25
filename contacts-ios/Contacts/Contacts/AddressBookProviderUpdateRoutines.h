//
//  ContactsUpdateRoutines.h
//  Contacts
//
//  Created by Maxim on 9/23/13.
//  Copyright (c) 2013 Max Rozdobudko. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FlashRuntimeExtensions.h"

#import "AddressBookAccessor.h"

@interface AddressBookProviderUpdateRoutines : NSObject

+(BOOL) updateContactWithOptions:(FREObject) contact withOptions:(FREObject) options;

@end

//
//  AddressBookAccessManager.h
//  Contacts
//
//  Created by Maxim on 9/9/13.
//  Copyright (c) 2013 Max Rozdobudko. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

#import <AddressBook/AddressBook.h>

typedef void (^AddressBookRequestHandler) (ABAddressBookRef addressBook, BOOL available);

@interface AddressBookAccessor : NSObject

#pragma mark Shared Instance

+(AddressBookAccessor*) sharedInstance;

-(BOOL) isAvailable:(ABAuthorizationStatus)status;

-(void) request:(AddressBookRequestHandler) handler;

-(BOOL) isIOS6;

@end

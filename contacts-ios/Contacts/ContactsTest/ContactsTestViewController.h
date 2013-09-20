//
//  ContactsTestViewController.h
//  ContactsTest
//
//  Created by Maxim on 9/9/13.
//  Copyright (c) 2013 Max Rozdobudko. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Contacts.h"

@interface ContactsTestViewController : UIViewController

- (IBAction)isModifiedAction:(id)sender;
- (IBAction)getContacts:(id)sender;
- (IBAction)getContactCountAction:(id)sender;
- (IBAction)getContactsAsync:(id)sender;
- (IBAction)pickGetContactsAction:(id)sender;
- (IBAction)getContactCountAsyncAction:(id)sender;
- (IBAction)isModifiedAsyncAction:(id)sender;

@end

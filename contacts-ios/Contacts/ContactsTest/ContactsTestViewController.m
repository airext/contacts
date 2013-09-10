//
//  ContactsTestViewController.m
//  ContactsTest
//
//  Created by Maxim on 9/9/13.
//  Copyright (c) 2013 Max Rozdobudko. All rights reserved.
//

#import "Contacts.h"

#import "ContactsTestViewController.h"

@interface ContactsTestViewController ()

@end

@implementation ContactsTestViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)isModifiedAction:(id)sender
{
    Contacts* contacts = [[Contacts alloc] init];
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMdd"];
    
    NSString* lastSyncString = @"20100312";
    
    NSDate* since = [formatter dateFromString:lastSyncString];
    
    BOOL result = [contacts isModified:since];
    
    NSLog(@"isModified: %i", result);
}

- (IBAction)getContacts:(id)sender
{
    Contacts* contacts = [[Contacts alloc] init];
    
    NSRange range = NSMakeRange(0, 1000);
    
    NSArray* result = [contacts getContacts:range];
    
    NSLog(@"There are %i contacts", [result count]);
}

@end

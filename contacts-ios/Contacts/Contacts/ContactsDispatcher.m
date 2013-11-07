//
//  ContactsConversionRoutines.m
//  Contacts
//
//  Created by Maxim on 9/11/13.
//  Copyright (c) 2013 Max Rozdobudko. All rights reserved.
//

#import <mach/mach_time.h>

#import <UIKit/UIKit.h>

#import "FlashRuntimeExtensions.h"

#import "Contacts_FRETypeConversion.h"

#import "ContactsDispatcher.h"

@implementation ContactsDispatcher

@end

#pragma mark C Interface

#pragma mark Event Dispatching functions

void Contacts_dispatchErrorEvent(FREContext context, NSString* code)
{
    FREDispatchStatusEventAsync(context, (const uint8_t*) [code UTF8String], (const uint8_t*) "error");
}

void Contacts_dispatchStatusEvent(FREContext context, NSString* code)
{
    FREDispatchStatusEventAsync(context, (const uint8_t*) [code UTF8String], (const uint8_t*) "status");
}

void Contacts_dispatchResponseEvent(FREContext context, NSUInteger callId, NSString* status, NSString* method, NSString* data)
{
    NSString* code = [NSString stringWithFormat:@"{\"object\":\"response\", \"callId\":%i, \"method\":\"%@\", \"status\":\"%@\", \"data\":%@}", callId, method, status, data];
    
    FREDispatchStatusEventAsync(context, (const uint8_t*) [code UTF8String], (const uint8_t*) "response");
}
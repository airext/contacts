//
//  ContactsFacade.h
//  Contacts
//
//  Created by Maxim on 10/24/13.
//  Copyright (c) 2013 Max Rozdobudko. All rights reserved.
//

#import <mach/mach_time.h>

#import <Foundation/Foundation.h>

#import "FlashRuntimeExtensions.h"

#import "Contacts.h"

#import "Contacts_FRETypeConversion.h"

#pragma mark Sync API

FREObject Contacts_isModified(FREContext context, void* functionData, uint32_t argc, FREObject argv[]);

FREObject Contacts_getContactCount(FREContext context, void* functionData, uint32_t argc, FREObject argv[]);

FREObject Contacts_getContacts(FREContext context, void* functionData, uint32_t argc, FREObject argv[]);

FREObject Contacts_updateContact(FREContext context, void* functionData, uint32_t argc, FREObject argv[]);

FREObject Contacts_getContactThumbnail(FREContext context, void* functionData, uint32_t argc, FREObject argv[]);

#pragma mark Async API

FREObject Contacts_isModifiedAsync(FREContext context, void* functionData, uint32_t argc, FREObject argv[]);

FREObject Contacts_getContactCountAsync(FREContext context, void* functionData, uint32_t argc, FREObject argv[]);

FREObject Contacts_getContactsAsync(FREContext context, void* functionData, uint32_t argc, FREObject argv[]);

#pragma mark FRE ContextInitializer/ContextFinalizer

void ContactsContextInitializer(void* extData, const uint8_t* ctxType, FREContext ctx, uint32_t* numFunctionsToTest, const FRENamedFunction** functionsToSet);

void ContactsContextFinalizer(FREContext ctx);

#pragma mark FRE Initializer/Finalizer

void ContactsInitializer(void** extDataToSet, FREContextInitializer* ctxInitializerToSet, FREContextFinalizer* ctxFinalizerToSet);

void ContactsFinalizer(void* extData);

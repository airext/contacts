//
//  Contacts.h
//  Contacts
//
//  Created by Maxim on 9/9/13.
//  Copyright (c) 2013 Max Rozdobudko. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FlashRuntimeExtensions.h"

#import "AddressBookAccessor.h"
#import "AddressBookProvider.h"

@interface Contacts : NSObject

#pragma mark Shared Instance

+(Contacts*) sharedInstance;

#pragma mark Properties

@property FREContext context;

@property BOOL isModifiedResult;

@property NSInteger getContactCountResult;

@property NSArray* getContactsResult;

#pragma mark ANE methods

-(BOOL) isSupported;

#pragma mark Asyncronous wrappers

-(void) isModifiedAsync:(NSDate*) since;
-(BOOL) pickIsModifiedResult;

-(void) getContactCountAsync;
-(void) getContactsAsync:(NSRange) range;
-(NSInteger) pickGetContactCountResult;

-(void) getContactsAsync:(NSRange) range withOptions:(NSDictionary*) options;
-(NSArray*) pickGetContactsResult;

-(void) updateContactAsync:(NSDictionary*) contact;

#pragma mark AddressBook methods

-(BOOL) isModified:(NSDate*) since;
-(NSInteger) getContactCount;
-(NSArray*) getContacts:(NSRange) range;
-(NSArray*) getContacts:(NSRange) range withOptions:(NSDictionary*) options;
-(BOOL) updateContact:(NSDictionary*) contact;

#pragma mark C Interface

#pragma mark FRE Functions

FREObject isModified(FREContext context, void* functionData, uint32_t argc, FREObject argv[]);
FREObject getContactCount(FREContext context, void* functionData, uint32_t argc, FREObject argv[]);
FREObject getContacts(FREContext context, void* functionData, uint32_t argc, FREObject argv[]);

FREObject isModifiedAsync(FREContext context, void* functionData, uint32_t argc, FREObject argv[]);
FREObject pickIsModifiedResult(FREContext context, void* functionData, uint32_t argc, FREObject argv[]);

FREObject getContactCountAsync(FREContext context, void* functionData, uint32_t argc, FREObject argv[]);
FREObject pickGetContactCountResult(FREContext context, void* functionData, uint32_t argc, FREObject argv[]);

FREObject getContactsAsync(FREContext context, void* functionData, uint32_t argc, FREObject argv[]);
FREObject pickGetContactsResult(FREContext context, void* functionData, uint32_t argc, FREObject argv[]);

#pragma mark FRE ContextInitializer/ContextFinalizer

void ContactsContextInitializer(void* extData, const uint8_t* ctxType, FREContext ctx, uint32_t* numFunctionsToTest, const FRENamedFunction** functionsToSet);
void ContactsContextFinalizer(FREContext ctx);

#pragma mark FRE Initializer/Finalizer

void ContactsInitializer(void** extDataToSet, FREContextInitializer* ctxInitializerToSet, FREContextFinalizer* ctxFinalizerToSet);
void ContactsFinalizer(void* extData);

@end

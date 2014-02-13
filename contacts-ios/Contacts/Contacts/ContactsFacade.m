//
//  ContactsFacade.m
//  Contacts
//
//  Created by Maxim on 10/24/13.
//  Copyright (c) 2013 Max Rozdobudko. All rights reserved.
//

#import "ContactsFacade.h"


#pragma mark Sync API

FREObject isSupported(FREContext context, void* functionData, uint32_t argc, FREObject argv[])
{
    FREObject result = NULL;
    
    FRENewObjectFromBool([[Contacts sharedInstance] isSupported], &result);
    
    return result;
}

FREObject Contacts_isModified(FREContext context, void* functionData, uint32_t argc, FREObject argv[])
{
    FREObject result = NULL;
    
    double time = 0;
    
    if (FREGetObjectAsDouble(argv[0], &time) == FRE_OK)
    {
        NSDate* since = [NSDate dateWithTimeIntervalSince1970:(NSTimeInterval)time];
        
        FRENewObjectFromBool([[Contacts sharedInstance] isModified:since], &result);
    }
    
    return result;
}

FREObject Contacts_getContacts(FREContext context, void* functionData, uint32_t argc, FREObject argv[])
{
    NSRange range;
    [Contacts_FRETypeConversion Contacts_convertFREObjectToNSRange:argv[0] asRange:&range];
    
    return [[Contacts sharedInstance] getContacts:range];
}

FREObject Contacts_getContactCount(FREContext context, void* functionData, uint32_t argc, FREObject argv[])
{
    return [[Contacts sharedInstance] getContactCount];
}

FREObject Contacts_updateContact(FREContext context, void* functionData, uint32_t argc, FREObject argv[])
{
    FREObject result = NULL;
    
    FRENewObjectFromBool([[Contacts sharedInstance] updateContact:argv[0]], &result);
    
    return result;
}

FREObject Contacts_getContactThumbnail(FREContext context, void* functionData, uint32_t argc, FREObject argv[])
{
    FREObject result = NULL;
    
    int32_t recordId;
    
    FREGetObjectAsInt32(argv[0], &recordId);
    
    NSData* data = [[Contacts sharedInstance] getContactThumbnail:recordId];
    
    if (data != NULL)
    {
        [Contacts_FRETypeConversion Contacts_convertNSDataToFREBitmapData:data asBitmapData:&result];
    }
    
    return result;
}

#pragma mark Async API

FREObject Contacts_isModifiedAsync(FREContext context, void* functionData, uint32_t argc, FREObject argv[])
{
    FREObject result;
    
    double time = 0;
    
    FREGetObjectAsDouble(argv[0], &time);
    
    NSDate* since = [NSDate dateWithTimeIntervalSince1970:(NSTimeInterval)time];
    
    FRENewObjectFromUint32((uint32_t) [[Contacts sharedInstance] isModifiedAsync:since], &result);
    
    return result;
}

FREObject Contacts_getContactCountAsync(FREContext context, void* functionData, uint32_t argc, FREObject argv[])
{
    FREObject result;
    
    FRENewObjectFromUint32((uint32_t) [[Contacts sharedInstance] getContactCountAsync], &result);
    
    return result;
}

FREObject Contacts_getContactsAsync(FREContext context, void* functionData, uint32_t argc, FREObject argv[])
{
    FREObject result;
    
    NSRange range;
    [Contacts_FRETypeConversion Contacts_convertFREObjectToNSRange:argv[0] asRange:&range];
    
    if (argc == 1)
    {
        FRENewObjectFromUint32((uint32_t) [[Contacts sharedInstance] getContactsAsync:range], &result);
    }
    else
    {
        FRENewObjectFromUint32((uint32_t) [[Contacts sharedInstance] getContactsAsync:range withOptions:nil], &result);
    }
    
    return result;
}

#pragma mark ContextInitialize/ContextFinalizer

void ContactsContextInitializer(void* extData, const uint8_t* ctxType, FREContext ctx, uint32_t* numFunctionsToTest, const FRENamedFunction** functionsToSet)
{
    *numFunctionsToTest = 9;
    
    FRENamedFunction* func = (FRENamedFunction*) malloc(sizeof(FRENamedFunction) * (*numFunctionsToTest));
    
    func[0].name = (const uint8_t*) "isSupported";
    func[0].functionData = NULL;
    func[0].function = &isSupported;
    
    func[1].name = (const uint8_t*) "isModified";
    func[1].functionData = NULL;
    func[1].function = &Contacts_isModified;
    
    func[2].name = (const uint8_t*) "getContacts";
    func[2].functionData = NULL;
    func[2].function = &Contacts_getContacts;
    
    func[3].name = (const uint8_t*) "getContactCount";
    func[3].functionData = NULL;
    func[3].function = &Contacts_getContactCount;
    
    func[4].name = (const uint8_t*) "isModifiedAsync";
    func[4].functionData = NULL;
    func[4].function = &Contacts_isModifiedAsync;
    
    func[5].name = (const uint8_t*) "getContactsAsync";
    func[5].functionData = NULL;
    func[5].function = &Contacts_getContactsAsync;
    
    func[6].name = (const uint8_t*) "getContactCountAsync";
    func[6].functionData = NULL;
    func[6].function = &Contacts_getContactCountAsync;
    
    func[7].name = (const uint8_t*) "updateContact";
    func[7].functionData = NULL;
    func[7].function = &Contacts_updateContact;
    
    func[8].name = (const uint8_t*) "getContactThumbnail";
    func[8].functionData = NULL;
    func[8].function = &Contacts_getContactThumbnail;
    
    *functionsToSet = func;
    
    [Contacts sharedInstance].context = ctx;
    
    [[Contacts sharedInstance] registerChangeCallback];
}

void ContactsContextFinalizer(FREContext ctx)
{
    [[Contacts sharedInstance] unregisterChangeCallback];
    
    [Contacts sharedInstance].context = nil;
}

#pragma mark Initializer/Finalizer

void ContactsInitializer(void** extDataToSet, FREContextInitializer* ctxInitializerToSet, FREContextFinalizer* ctxFinalizerToSet)
{
    NSLog(@"ContactsInitializer");
    
    *extDataToSet = NULL;
    
    *ctxInitializerToSet = &ContactsContextInitializer;
	*ctxFinalizerToSet = &ContactsContextFinalizer;
}

void ContactsFinalizer(void* extData)
{
    NSLog(@"ContactsFinalizer");
}

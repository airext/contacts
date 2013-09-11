//
//  ContactsConversionRoutines.h
//  Contacts
//
//  Created by Maxim on 9/11/13.
//  Copyright (c) 2013 Max Rozdobudko. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FlashRuntimeExtensions.h"

@interface ContactsRoutines : NSObject

+(FREObject*) personConvertToContact:(NSDictionary*) person;

@end

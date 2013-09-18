# contacts

AIR Native Extension for work with Contacts/AddressBook.

## Features

* Works in Syncronous and Asyncronous modes
* Provides almost all properties defined in iOS' AddressBook ([List of supported properties](https://github.com/rozd/contacts/wiki/Supported-Contact-Properrties)) 

## Requirements

* Adobe AIR 3.6
* iOS 6.1

## Code Example
    
    // checks if AddressBook is modified in sync mode
    
    var isAddressBookChanged:Boolean = Contacts.getInstance().isModified(new Date());
    
    ...
    
    // request first 100 or all contacts in async mode
  
    Contacts.getInstance().getContactsAsync(new Range(0, 100), null,
      new Response(
        function(contacts:Array):void
        {
          trace("contacts from 0 to 100:", contacts);
        },
        function (info:Object):void
        {
          trace(info)
        })
    );

## Deploying

TBD

## Roadmap

* Port to Android
* Support all properties for iOS
* TBD

## Contacts API

The contacts extension could operate with Address Book in *syncronous* and *asyncronous* mode. 
Each syncronous method has asyncronous counterpart with name that end on _Async_ string. 
For detailed description see API reference.

[API Reference](https://github.com/rozd/contacts/wiki/API-Reference/)

## Related Projects

Some techniques and code has been borrowed from Memler's [ContactEditor](https://github.com/memeller/ContactEditor) and its FreshPlanet [fork](https://github.com/freshplanet/ContactEditor)

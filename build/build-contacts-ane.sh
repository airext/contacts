#!/bin/bash

unzip contacts.swc -o
adt -package -storetype pkcs12 -keystore ~/certs/rozd.p12 -storepass vopli -target ane contacts.ane extension.xml -swc contacts.swc -platform iPhone-ARM library.swf libContacts.a -platformoptions platform.xml
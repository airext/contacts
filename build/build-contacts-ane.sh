#!/bin/bash

unzip -o contacts.swc

adt -package -storetype pkcs12 -keystore ~/certs/rozd.p12 -storepass vopli -target ane contacts.ane extension.xml -swc contacts.swc -platform iPhone-ARM library.swf libContacts.a -platformoptions platform.xml

cp -R contacts.ane ../contacts-air/contacts-debug/ane/contacts.ane

cp -R contacts.ane ../bin/contacts.ane
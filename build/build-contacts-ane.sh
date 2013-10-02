#!/bin/bash

unzip -o contacts.swc

unzip -o default/contacts-default.swc -d default

adt -package -storetype pkcs12 -keystore ~/certs/rozd.p12 -storepass vopli -target ane contacts.ane extension.xml -swc contacts.swc -platform iPhone-ARM library.swf libContacts.a -platformoptions platform.xml -platform default -C default library.swf

cp -R contacts.ane ../contacts-air/contacts-debug/ane/contacts.ane

cp -R contacts.ane ../bin/contacts.ane

mkdir launch/ext
cp -R contacts.ane launch/ext/contacts.ane
unzip -o launch/ext/contacts.ane -d launch/ext

rm library.swf
rm catalog.xml

rm default/library.swf
rm default/catalog.xml
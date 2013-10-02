#!/bin/bash

cp -R ../contacts-air/contacts-debug/bin-debug/ContactsDebug-app.xml launch/ContactsDebug-app.xml
cp -R ../contacts-air/contacts-debug/bin-debug/ContactsDebug.swf launch/ContactsDebug.swf

adt -package -target ipa-debug-interpreter -provisioning-profile $IOS_PROVISION -storetype pkcs12 -keystore $IOS_CERTIFICATE -storepass $IOS_CERTIFICATE_STOREPASS launch/ContactsDebug.ipa launch/ContactsDebug-app.xml -C launch ContactsDebug.swf -extdir launch/ext -platformsdk /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS6.1.sdk/
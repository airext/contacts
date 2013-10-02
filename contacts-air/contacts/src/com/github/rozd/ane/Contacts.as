/**
 * Created with IntelliJ IDEA.
 * User: mobitile
 * Date: 9/10/13
 * Time: 3:24 PM
 * To change this template use File | Settings | File Templates.
 */
package com.github.rozd.ane
{
import com.github.rozd.ane.core.Response;
import com.github.rozd.ane.core.contacts;
import com.github.rozd.ane.data.IRange;
import com.github.rozd.ane.events.ResponseEvent;
import com.github.rozd.ane.utils.Base64;

import flash.display.BitmapData;

import flash.events.EventDispatcher;
import flash.events.StatusEvent;
import flash.external.ExtensionContext;
import flash.geom.Rectangle;
import flash.system.Worker;
import flash.utils.ByteArray;
import flash.utils.getTimer;

[Event(name="error", type="flash.events.ErrorEvent")]

[Event(name="status", type="flash.events.StatusEvent")]

[Event(name="response", type="com.github.rozd.ane.events.ResponseEvent")]

use namespace contacts;

public class Contacts extends EventDispatcher
{
    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------

    contacts static const EXTENSION_ID:String = "com.github.rozd.ane.Contacts";

    //--------------------------------------------------------------------------
    //
    //  Class properties
    //
    //--------------------------------------------------------------------------

    private static var _context:ExtensionContext;

    private static function get context():ExtensionContext
    {
        if (_context == null)
        {
            _context = ExtensionContext.createExtensionContext(EXTENSION_ID, null);
        }

        return _context;
    }

    //--------------------------------------------------------------------------
    //
    //  Class methods
    //
    //--------------------------------------------------------------------------

    public static function isSupported():Boolean
    {
        return context != null && context.call("isSupported");
    }

    private static var instance:Contacts;

    public static function getInstance():Contacts
    {
        if (instance == null)
        {
            instance = new Contacts();
        }

        return instance;
    }

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    public function Contacts()
    {
        super();

        context.addEventListener(StatusEvent.STATUS, statusHandler);
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    //-------------------------------------
    //  Methods: Synchronous
    //-------------------------------------

    public function isModified(since:Date):Boolean
    {
        return context.call("isModified", since.time);
    }

    public function getContacts(range:IRange, options:Object=null):Array
    {
        var rangeArray:Array = range ? range.toArray() : [0, uint.MAX_VALUE];

        if (options == null)
            return context.call("getContacts", rangeArray) as Array;
        else
            return context.call("getContacts", rangeArray, options) as Array;
    }

    public function getContactCount():int
    {
        return context.call("getContactCount") as int;
    }

    public function updateContact(contact:Object, options:Object=null):Boolean
    {
        return context.call("updateContact", contact, options);
    }

    public function getContactThumbnail(recordId:Object):BitmapData
    {
        return context.call("getContactThumbnail", recordId as int) as BitmapData;
    }

    //-------------------------------------
    //  Methods: Asynchronous
    //-------------------------------------

    public function isModifiedAsync(since:Date, response:Response=null):void
    {
        var callId:uint = context.call("isModifiedAsync", since.time) as uint;

        function handler(event:ResponseEvent):void
        {
            if (event.info.callId == callId)
            {
                removeEventListener(ResponseEvent.RESPONSE, handler);

                if (event.info.status == "result")
                {
                    try
                    {
                        response.result(pickIsModifiedResult(callId));
                    }
                    catch (error:Error)
                    {
                        response.error(error);
                    }
                }
                else
                {
                    response.error(new Error(event.info.detail));
                }
            }
        }

        if (response != null)
        {
            addEventListener(ResponseEvent.RESPONSE, handler);
        }
    }

    public function getContactsAsync(range:IRange, options:Object=null, response:Response=null):void
    {
        var callId:uint;

        var rangeArray:Array = range ? range.toArray() : [0, uint.MAX_VALUE];

        if (options == null)
            callId = context.call("getContactsAsync", rangeArray) as uint;
        else
            callId = context.call("getContactsAsync", rangeArray, options) as uint;

        function handler(event:ResponseEvent):void
        {
            if (event.info.callId == callId)
            {
                addEventListener(ResponseEvent.RESPONSE, handler);

                if (event.info.status == "result")
                {
                    try
                    {
                        var contacts:Array = event.info.data;

                        for each (var contact:Object in contacts)
                        {
                            if (contact.hasThumbnail)
                                contact.thumbnail = getContactThumbnail(contact.recordId);
                        }

                        response.result(contacts);
                    }
                    catch (error:Error)
                    {
                        response.error(error);
                    }
                }
                else // event.info.status == error
                {
                    response.error(new Error(event.info.detail));
                }
            }
        }

        if (response != null)
        {
            addEventListener(ResponseEvent.RESPONSE, handler);
        }
    }

    public function getContactCountAsync(response:Response=null):void
    {
        var callId:uint = context.call("getContactCountAsync") as uint;

        function handler(event:ResponseEvent):void
        {
            if (event.info.callId == callId)
            {
                removeEventListener(ResponseEvent.RESPONSE, handler);

                if (event.info.status == "result")
                {
                    try
                    {
                        response.result(pickGetContactCountResult(callId));
                    }
                    catch (error:Error)
                    {
                        response.error(error);
                    }
                }
                else // event.info.status == "error"
                {
                    response.error(new Error(event.info.detail));
                }
            }
        }

        if (response != null)
        {
            addEventListener(ResponseEvent.RESPONSE, handler);
        }
    }

    //-------------------------------------
    //  Methods: Asynchronous Result
    //-------------------------------------

    contacts function pickIsModifiedResult(callId:uint):Boolean
    {
        return context.call("pickIsModifiedResult", callId) as Boolean;
    }

    contacts function pickGetContactsResult(callId:uint):Object
    {
        return context.call("pickGetContactsResult", callId);
    }

    contacts function pickGetContactCountResult(callId:uint):int
    {
        return context.call("pickGetContactCountResult", callId) as int;
    }

    //--------------------------------------------------------------------------
    //
    //  Handlers
    //
    //--------------------------------------------------------------------------

    private function statusHandler(event:StatusEvent):void
    {
        if (event.level == "response")
        {
            var e:ResponseEvent = ResponseEvent.create(event.code, event.level);

            var t:Number = getTimer();

            e.info = JSON.parse(event.code);

            trace("JSON decoding takes: ", getTimer() - t);

            dispatchEvent(e);
        }
        else
        {
            dispatchEvent(event.clone());
        }
    }
}
}

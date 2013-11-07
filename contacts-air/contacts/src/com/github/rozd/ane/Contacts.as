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
import com.github.rozd.ane.data.Page;
import com.github.rozd.ane.events.ResponseEvent;

import flash.display.BitmapData;
import flash.events.ErrorEvent;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.StatusEvent;
import flash.external.ExtensionContext;

import skein.async.Queue;

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
    //  Class variables
    //
    //--------------------------------------------------------------------------

    contacts static var BUNCH_SIZE:uint = 5;

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

    private var getContactsAsyncQueue:Queue;

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
        var rangeArray:Array = range ? range.toArray() : [0, uint.MAX_VALUE];

        var offset:uint = Math.max(0, rangeArray[0]);

        if (offset == uint.MAX_VALUE)
            offset = getContactCount();

        var limit:uint = Math.max(0, rangeArray[1]);

        if (limit == uint.MAX_VALUE)
            limit = getContactCount();

        var contacts:Array = [];

        var functions:Array = [];

        var total:uint = offset + limit;

        for (var i:uint = offset; i < total; i += BUNCH_SIZE)
        {
            var closure:Function = function(i:int):Function
            {
                var f:Function = function (callback:Function):void
                {
                    try
                    {
                        contacts = contacts.concat(getContacts(new Page(i, BUNCH_SIZE), options));

                        callback(true);
                    }
                    catch (error:Error)
                    {
                        callback(error);
                    }
                }

                return f;
            };

            functions.push(closure(i));
        }

        function errorHandler(event:ErrorEvent):void
        {
            queue.removeEventListener(ErrorEvent.ERROR, errorHandler);
            queue.removeEventListener(Event.COMPLETE, completeHandler);

            response.error(event);
        }

        function completeHandler(event:Event):void
        {
            queue.removeEventListener(ErrorEvent.ERROR, errorHandler);
            queue.removeEventListener(Event.COMPLETE, completeHandler);

            response.result(contacts);
        }

        var queue:Queue = new Queue(functions);
        queue.addEventListener(ErrorEvent.ERROR, errorHandler);
        queue.addEventListener(Event.COMPLETE, completeHandler);

        if (getContactsAsyncQueue == null)
        {
            var queueCompleteHandler:Function = function(event:Event):void
            {
                getContactsAsyncQueue.removeEventListener(Event.COMPLETE, queueCompleteHandler);
                getContactsAsyncQueue.removeEventListener(ErrorEvent.ERROR, queueErrorHandler);

                getContactsAsyncQueue = null;
            }

            var queueErrorHandler:Function = function(event:ErrorEvent):void
            {
                getContactsAsyncQueue.removeEventListener(Event.COMPLETE, queueCompleteHandler);
                getContactsAsyncQueue.removeEventListener(ErrorEvent.ERROR, queueErrorHandler);

                getContactsAsyncQueue = null;
            }

            getContactsAsyncQueue = new Queue();
            getContactsAsyncQueue.addEventListener(Event.COMPLETE, queueCompleteHandler);
            getContactsAsyncQueue.addEventListener(ErrorEvent.ERROR, queueErrorHandler);
        }

        getContactsAsyncQueue.add([queue]);

        getContactsAsyncQueue.start();
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
                        response.result(event.info.data);
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

            e.info = JSON.parse(event.code);

            dispatchEvent(e);
        }
        else
        {
            dispatchEvent(event.clone());
        }
    }
}
}

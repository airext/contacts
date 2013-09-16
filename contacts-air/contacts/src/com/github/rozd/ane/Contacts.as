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

import flash.events.EventDispatcher;
import flash.events.StatusEvent;
import flash.external.ExtensionContext;

[Event(name="error", type="flash.events.ErrorEvent")]

[Event(name="status", type="flash.events.StatusEvent")]

use namespace contacts;

public class Contacts extends EventDispatcher
{
    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------

    contacts static const EXTENSION_ID:String = "com.github.rozd.ane.Contacts";

    private static var _context:ExtensionContext;

    //--------------------------------------------------------------------------
    //
    //  Class properties
    //
    //--------------------------------------------------------------------------

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

    private var isModifiedQueue:Array = [];

    private var getContactsQueue:Array = [];

    private var getContactCountQueue:Array = [];

    //--------------------------------------------------------------------------
    //
    //  Getters
    //
    //--------------------------------------------------------------------------

    //-------------------------------------
    //  Getters: Call Id
    //-------------------------------------

    private var callId:uint = 0;

    private function getNextCallId():uint
    {
        if (callId == uint.MAX_VALUE)
            callId = 0;
        else
            callId++;

        return callId;
    }

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

    //-------------------------------------
    //  Methods: Asynchronous
    //-------------------------------------

    public function isModifiedAsync(since:Date, response:Response=null):void
    {
        var callId:uint = getNextCallId();

        isModifiedQueue.push(callId);

        function handler(event:StatusEvent):void
        {
            if (isModifiedQueue[0] != callId)
                return;

            switch (event.code)
            {
                case "Contacts.IsModified.Result" :

                        removeEventListener(StatusEvent.STATUS, handler);

                        try
                        {
                            var result:Object = pickIsModifiedResult();
                        }
                        catch (error:Error)
                        {
                            response.error(error);
                        }

                        response.result(result);

                    break;

                case "Contacts.IsModified.Failed" :

                        removeEventListener(StatusEvent.STATUS, handler);

                        response.error(new Error(event.code));

                    break;
            }
        }

        if (response != null)
        {
            addEventListener(StatusEvent.STATUS, handler);
        }

        context.call("isModifiedAsync", since.time);
    }

    public function getContactsAsync(range:IRange, options:Object=null, response:Response=null):void
    {
        var callId:uint = getNextCallId();

        getContactsQueue.push(callId);

        function handler(event:StatusEvent):void
        {
            if (getContactsQueue[0] != callId)
                return;

            switch (event.code)
            {
                case "Contacts.GetContacts.Result" :

                    removeEventListener(StatusEvent.STATUS, handler);

                    try
                    {
                        var result:Object = pickGetContactsResult();
                    }
                    catch (error:Error)
                    {
                        response.error(error);
                    }

                    response.result(result);

                    break;

                case "Contacts.GetContacts.Failed" :

                    removeEventListener(StatusEvent.STATUS, handler);

                    response.error(new Error(event.code));

                    break;
            }
        }

        if (response != null)
        {
            addEventListener(StatusEvent.STATUS, handler);
        }

        var rangeArray:Array = range ? range.toArray() : [0, uint.MAX_VALUE];

        if (options == null)
            context.call("getContactsAsync", rangeArray);
        else
            context.call("getContactsAsync", rangeArray, options);
    }

    public function getContactCountAsync(response:Response=null):void
    {
        var callId:uint = getNextCallId();

        function handler(event:StatusEvent):void
        {
            if (getContactCountQueue[0] != callId)
                return;

            switch (event.code)
            {
                case "Contacts.GetContactCount.Result" :

                    removeEventListener(StatusEvent.STATUS, handler);

                    try
                    {
                        var result:Object = pickGetContactCountResult();
                    }
                    catch (error:Error)
                    {
                        response.error(error);
                    }

                    response.result(result);

                    break;

                case "Contacts.GetContactCount.Failed" :

                    removeEventListener(StatusEvent.STATUS, handler);

                    response.error(new Error(event.code));

                    break;
            }
        }

        if (response != null)
        {
            addEventListener(StatusEvent.STATUS, handler);
        }

        context.call("getContactCountAsync");
    }

    //-------------------------------------
    //  Methods: Asynchronous Result
    //-------------------------------------

    contacts function pickIsModifiedResult():Boolean
    {
        return context.call("pickIsModifiedResult") as Boolean;
    }

    contacts function pickGetContactsResult():Array
    {
        return context.call("pickGetContactsResult") as Array;
    }

    contacts function pickGetContactCountResult():int
    {
        return context.call("pickGetContactCountResult") as int;
    }

    //--------------------------------------------------------------------------
    //
    //  Handlers
    //
    //--------------------------------------------------------------------------

    private function statusHandler(event:StatusEvent):void
    {
        dispatchEvent(event.clone());

        switch (event.code)
        {
            case "Contacts.IsModified.Result" :
            case "Contacts.IsModified.Failed" :

                    if (isModifiedQueue.length > 0)
                        isModifiedQueue.shift();

                break;

            case "Contacts.GetContacts.Result" :
            case "Contacts.GetContacts.Failed" :

                    if (getContactsQueue.length > 0)
                        getContactsQueue.shift();

                break;

            case "Contacts.GetContactCount.Result" :
            case "Contacts.GetContactCount.Failed" :

                    if (getContactCountQueue.length > 0)
                        getContactCountQueue.shift();

                break;
        }
    }
}
}

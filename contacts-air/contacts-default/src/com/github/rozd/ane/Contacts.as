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

import flash.display.BitmapData;

import flash.events.EventDispatcher;
import flash.events.StatusEvent;
import flash.system.Capabilities;

[Event(name="error", type="flash.events.ErrorEvent")]

[Event(name="status", type="flash.events.StatusEvent")]

[Event(name="response", type="com.github.rozd.ane.events.ResponseEvent")]

use namespace contacts;

public class Contacts extends EventDispatcher
{
    //--------------------------------------------------------------------------
    //
    //  Class methods
    //
    //--------------------------------------------------------------------------

    public static function isSupported():Boolean
    {
        return false;
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
        trace("Contacts is not supported for " + Capabilities.os);

        return false;
    }

    public function getContacts(range:IRange, options:Object=null):Array
    {
        trace("Contacts is not supported for " + Capabilities.os);

        return null;
    }

    public function getContactCount():int
    {
        trace("Contacts is not supported for " + Capabilities.os);

        return -1;
    }

    public function updateContact(contact:Object, options:Object=null):Boolean
    {
        trace("Contacts is not supported for " + Capabilities.os);

        return false;
    }

    public function getContactThumbnail(recordId:Object):BitmapData
    {
        trace("Contacts is not supported for " + Capabilities.os);

        return null;
    }

    //-------------------------------------
    //  Methods: Asynchronous
    //-------------------------------------

    public function isModifiedAsync(since:Date, response:Response=null):void
    {
        trace("Contacts is not supported for " + Capabilities.os);
    }

    public function getContactsAsync(range:IRange, options:Object=null, response:Response=null):void
    {
        trace("Contacts is not supported for " + Capabilities.os);
    }

    public function getContactCountAsync(response:Response=null):void
    {
        trace("Contacts is not supported for " + Capabilities.os);
    }
}
}

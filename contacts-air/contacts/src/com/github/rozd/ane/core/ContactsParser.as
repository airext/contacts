/**
 * Created with IntelliJ IDEA.
 * User: mobitile
 * Date: 10/1/13
 * Time: 6:16 PM
 * To change this template use File | Settings | File Templates.
 */
package com.github.rozd.ane.core
{
import com.github.rozd.ane.utils.Base64;

import flash.display.BitmapData;

import flash.events.EventDispatcher;
import flash.geom.Rectangle;
import flash.utils.ByteArray;

[Event(name="complete", type="flash.events.Event")]
[Event(name="error", type="flash.events.ErrorEvent")]
public class ContactsParser extends EventDispatcher implements Parser
{
    public function ContactsParser()
    {
        super();
    }

    public function parse(json:String):void
    {
        var contacts:Object = JSON.parse(json) as Array;

        for each (var contact:Object in contacts)
        {
            var thumbnail:Object = contact.thumbnail;

            if (thumbnail)
            {
                var bytes:ByteArray = Base64.decode(thumbnail.pixels);

                var bmd:BitmapData = new BitmapData(thumbnail.width, thumbnail.height);

                bmd.setPixels(new Rectangle(0, 0, thumbnail.width, thumbnail.height), bytes);
            }
        }
    }
}
}

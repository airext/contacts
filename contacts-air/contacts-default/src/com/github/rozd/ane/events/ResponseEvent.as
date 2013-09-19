/**
 * Created with IntelliJ IDEA.
 * User: mobitile
 * Date: 9/17/13
 * Time: 2:24 PM
 * To change this template use File | Settings | File Templates.
 */
package com.github.rozd.ane.events
{
import flash.events.StatusEvent;

public class ResponseEvent extends StatusEvent
{
    public static const RESPONSE:String = "response";

    public static function create(code:String = "", level:String = "", info:Object = null):ResponseEvent
    {
        return new ResponseEvent(RESPONSE, false, false, code, level, info);
    }

    public function ResponseEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, code:String = "", level:String = "", info:Object = null)
    {
        super(type, bubbles, cancelable, code, level);

        this.info = info;
    }

    public var info:Object;
}
}

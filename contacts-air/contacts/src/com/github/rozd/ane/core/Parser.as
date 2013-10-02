/**
 * Created with IntelliJ IDEA.
 * User: mobitile
 * Date: 10/1/13
 * Time: 4:44 PM
 * To change this template use File | Settings | File Templates.
 */
package com.github.rozd.ane.core
{
[Event(name="complete", type="flash.events.Event")]
[Event(name="error", type="flash.events.ErrorEvent")]
public interface Parser
{
    function parse(json:String):void;
}
}

/**
 * Created with IntelliJ IDEA.
 * User: mobitile
 * Date: 10/2/13
 * Time: 3:08 PM
 * To change this template use File | Settings | File Templates.
 */
package com.github.rozd.ane.core.queue
{
public interface Task
{
    function perform(result:Function, error:Function=null):void;
}
}

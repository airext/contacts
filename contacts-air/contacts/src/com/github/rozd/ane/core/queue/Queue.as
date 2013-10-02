/**
 * Created with IntelliJ IDEA.
 * User: mobitile
 * Date: 10/2/13
 * Time: 3:06 PM
 * To change this template use File | Settings | File Templates.
 */
package com.github.rozd.ane.core.queue
{
import flash.display.Sprite;
import flash.events.ErrorEvent;
import flash.events.Event;
import flash.events.EventDispatcher;

[Event(name="complete", type="flash.events.Event")]
[Event(name="error", type="flash.events.ErrorEvent")]
public class Queue extends EventDispatcher
{
    public function Queue(tasks:Array)
    {
        super();

        this.tasks = tasks;
    }

    private var enterFrameDispatcher:Sprite;

    private var busy:Boolean = false;
    private var ready:Boolean = false;

    private var tasks:Array;

    public function start():void
    {
        enterFrameDispatcher = new Sprite();
        enterFrameDispatcher.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
    }

    public function stop():void
    {
        enterFrameDispatcher.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
        enterFrameDispatcher = null;

        busy = false;
        ready = false;
    }

    public function complete():void
    {
        stop();

        dispatchEvent(new Event(Event.COMPLETE));
    }

    protected function tick():void
    {
        if (busy) return;

        var task:Task = tasks.shift();

        task.perform(resultCallback, errorCallback);
    }

    protected function resultCallback(data:Object):void
    {
        if (tasks.length == 0)
        {
            complete();
        }
        else
        {
            busy = false;
        }
    }

    protected function errorCallback(errorMessage:String):void
    {
        stop();

        dispatchEvent(new ErrorEvent(ErrorEvent.ERROR, false, false, errorMessage));
    }

    private function enterFrameHandler(event:Event):void
    {
        if (busy) return;

        if (ready)
        {
            ready = false;

            tick();
        }
        else
        {
            ready = true;
        }
    }
}
}

/**
 * Created with IntelliJ IDEA.
 * User: mobitile
 * Date: 10/10/13
 * Time: 7:53 PM
 * To change this template use File | Settings | File Templates.
 */
package com.github.rozd.ane.utils
{
import flash.debugger.enterDebugger;
import flash.display.Sprite;
import flash.events.ErrorEvent;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.utils.getTimer;

[Event(name="complete", type="flash.events.Event")]
[Event(name="error", type="flash.events.ErrorEvent")]
public class Queue extends EventDispatcher
{
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    public function Queue(tasks:Array=null)
    {
        super();

        this.tasks = tasks || [];
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    //-------------------------------------
    //  Variables: Tasks
    //-------------------------------------

    private var tasks:Array;

    //-------------------------------------
    //  Variables: Flags
    //-------------------------------------

    private var ready:Boolean = false;

    private var currentActiveTasks:uint = 0;

    //-------------------------------------
    //  Variables: Sprite dispatcher
    //-------------------------------------

    private var enterFrameDispatcher:Sprite;

    //-------------------------------------
    //  Variables: Frame
    //-------------------------------------

    private var frameCurrentThread:uint = 0;

    private var frameStartTime:int = -1;

    private var frameElapsedTime:int = 0;

    //--------------------------------------------------------------------------
    //
    //  Setters
    //
    //--------------------------------------------------------------------------

    //-------------------------------------
    //  busy
    //-------------------------------------

    public function get busy():Boolean
    {
        return currentActiveTasks > 0;
    }

    //-------------------------------------
    //  maxThreadsForFrame
    //-------------------------------------

    private var maxThreadForFrame:uint = 4;

    public function setMaxThreadsForFrame(value:uint):void
    {
        this.maxThreadForFrame = value;
    }

    //-------------------------------------
    //  maxTimePerFrame
    //-------------------------------------

    private var maxTimeForFrame:uint = 50;

    public function setMaxTimeForFrame(value:uint):void
    {
        this.maxTimeForFrame = value;
    }

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    //-------------------------------------
    //  Methods: Public API
    //-------------------------------------

    public function add(tasks:Array):void
    {
        if (tasks != null)
        {
            this.tasks = this.tasks.concat(tasks);
        }
    }

    public function start():void
    {
        if (enterFrameDispatcher == null)
        {
            enterFrameDispatcher = new Sprite();
            enterFrameDispatcher.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
        }
    }

    public function stop():void
    {
        if (enterFrameDispatcher != null)
        {
            enterFrameDispatcher.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
            enterFrameDispatcher = null;
        }

        currentActiveTasks = 0;
        ready = false;
    }

    //-------------------------------------
    //  Methods: Public API
    //-------------------------------------

    protected function tick():void
    {
        var task:Object = tasks.shift();

        if (task is Function)
        {
            currentActiveTasks++;

            task.apply(null, [callback]);
        }
        else if (task is Queue)
        {
            currentActiveTasks++;

            function errorHandler(event:ErrorEvent):void
            {
                queue.removeEventListener(Event.COMPLETE, completeHandler);
                queue.removeEventListener(ErrorEvent.ERROR, errorHandler);

                callback(event);
            }

            function completeHandler(event:Event):void
            {
                queue.removeEventListener(Event.COMPLETE, completeHandler);
                queue.removeEventListener(ErrorEvent.ERROR, errorHandler);

                callback(true);
            }

            var queue:Queue = task as Queue;
            queue.addEventListener(Event.COMPLETE, completeHandler);
            queue.addEventListener(ErrorEvent.ERROR, errorHandler);
            queue.start();

        }
        else if (task.hasOwnProperty("perform"))
        {
            currentActiveTasks++;

            if (task.hasOwnProperty("callback"))
            {
                task.callback = callback;
                task.perform();
            }
            else
            {
                try
                {
                    callback(task.perform());
                }
                catch (error:Error)
                {
                    callback(error);
                }
            }
        }
        else
        {
            enterDebugger();
        }
    }

    protected function callback(info:Object):void
    {
        if (info is Error || info is ErrorEvent)
        {
            stop();

            if (info is ErrorEvent)
                dispatchEvent(ErrorEvent(info).clone());
            else
                dispatchEvent(new ErrorEvent(ErrorEvent.ERROR, false, false, Error(info).message));
        }
        else if (tasks.length == 0)
        {
            stop();

            dispatchEvent(new Event(Event.COMPLETE));
        }
        else
        {
            currentActiveTasks--;

            frameCurrentThread++;

            frameElapsedTime += (getTimer() - frameStartTime);

            if (frameCurrentThread == maxThreadForFrame || frameElapsedTime >= maxTimeForFrame)
            {
                frameCurrentThread = 0;
                frameElapsedTime = 0;
                // wait for next frame
            }
            else
            {
                tick();
            }
        }
    }

    //--------------------------------------------------------------------------
    //
    //  Event handlers
    //
    //--------------------------------------------------------------------------

    private function enterFrameHandler(event:Event):void
    {
        if (busy) return;

        if (ready)
        {
            ready = false;

            frameCurrentThread = 0;

            frameStartTime = getTimer();

            tick();
        }
        else
        {
            ready = true;
        }
    }
}
}

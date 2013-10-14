/**
 * Created with IntelliJ IDEA.
 * User: mobitile
 * Date: 10/10/13
 * Time: 7:53 PM
 * To change this template use File | Settings | File Templates.
 */
package skein.async
{
import flash.display.Sprite;
import flash.events.ErrorEvent;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.utils.getTimer;

[Event(name="complete", type="flash.events.Event")]
[Event(name="error", type="flash.events.ErrorEvent")]
public class Async extends EventDispatcher
{
    //--------------------------------------------------------------------------
    //
    //  Class methods
    //
    //--------------------------------------------------------------------------

    public static function queue(tasks:Array, callback:Function=null):void
    {

    }

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    public function Async(tasks:Array)
    {
        super();

        this.tasks = tasks;
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
    //  Variables: Settings
    //-------------------------------------

    private var maxThreadPerFrame:uint = 4;

    private var maxTimePerFrame:uint = 200;

    //-------------------------------------
    //  Variables: Flags
    //-------------------------------------

    private var busy:Boolean = false;
    private var ready:Boolean = false;

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
    //  Methods
    //
    //--------------------------------------------------------------------------

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

    protected function tick():void
    {
        if (busy) return;

        var task:Object = tasks.shift();

        if (task is Function)
        {
            task.apply(null, [callback]);
        }
    }

    protected function callback(info:Object):void
    {
        if (info is Error)
        {
            stop();

            dispatchEvent(new ErrorEvent(ErrorEvent.ERROR, false, false, Error(info).message));
        }
        else if (tasks.length == 0)
        {
            stop();

            dispatchEvent(new Event(Event.COMPLETE));
        }
        else
        {
            busy = false;

            frameCurrentThread++;

            frameElapsedTime += (getTimer() - frameStartTime);

            if (frameCurrentThread == maxThreadPerFrame || frameElapsedTime >= maxTimePerFrame)
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

    protected function errorCallback(errorMessage:String):void
    {
        stop();

        dispatchEvent(new ErrorEvent(ErrorEvent.ERROR, false, false, errorMessage));
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

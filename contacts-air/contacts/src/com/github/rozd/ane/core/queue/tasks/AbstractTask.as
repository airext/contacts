/**
 * Created with IntelliJ IDEA.
 * User: mobitile
 * Date: 10/2/13
 * Time: 3:46 PM
 * To change this template use File | Settings | File Templates.
 */
package com.github.rozd.ane.core.queue.tasks
{
import com.github.rozd.ane.core.queue.Task;

import flash.events.TimerEvent;

import flash.utils.Timer;

public class AbstractTask implements Task
{
    public function AbstractTask()
    {
        super();
    }

    private var resultCallback:Function;
    private var errorCallback:Function;

    public function perform(result:Function, error:Function=null):void
    {
        resultCallback = result;
        errorCallback = error;
    }

    protected function notifyResult(data:Object, delay:uint=0):void
    {
        if (delay > 0)
        {
            var timer:Timer = new Timer(delay, 1);
            timer.addEventListener(TimerEvent.TIMER_COMPLETE,
                function completeHandler(event:TimerEvent):void
                {
                    timer.removeEventListener(TimerEvent.TIMER_COMPLETE, completeHandler);

                    resultCallback(data);
                }
            );
        }
        else
        {
            resultCallback(data);
        }
    }

    protected function notifyError(message:String, delay:uint=0):void
    {
        if (errorCallback == null)
            return;

        if (delay > 0)
        {
            var timer:Timer = new Timer(delay, 1);
            timer.addEventListener(TimerEvent.TIMER_COMPLETE,
                function completeHandler(event:TimerEvent):void
                {
                    timer.removeEventListener(TimerEvent.TIMER_COMPLETE, completeHandler);

                    errorCallback(message);
                }
            );
        }
        else
        {
            errorCallback(message);
        }
    }
}
}

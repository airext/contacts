/**
 * Created with IntelliJ IDEA.
 * User: mobitile
 * Date: 10/2/13
 * Time: 3:41 PM
 * To change this template use File | Settings | File Templates.
 */
package com.github.rozd.ane.core.queue.tasks
{
import com.github.rozd.ane.core.queue.Task;

import flash.events.TimerEvent;

import flash.external.ExtensionContext;
import flash.utils.Timer;

public class ContactFillThumbnailTask extends AbstractTask
{
    public function ContactFillThumbnailTask(context:ExtensionContext, contact:Object)
    {
        super();

        this.context = context;
        this.contact = contact;
    }

    private var context:ExtensionContext;
    private var contact:Object;

    override public function perform(result:Function, error:Function=null):void
    {
        super.perform(result, error);

        try
        {
            contact.thumbnail = context.call("getContactThumbnail", contact.recordId);

            notifyResult(contact.thumbnail);
        }
        catch (error:Error)
        {
            notifyError(error.message);
        }
    }
}
}

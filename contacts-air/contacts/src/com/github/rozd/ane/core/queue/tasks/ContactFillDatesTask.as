/**
 * Created with IntelliJ IDEA.
 * User: mobitile
 * Date: 10/3/13
 * Time: 11:02 AM
 * To change this template use File | Settings | File Templates.
 */
package com.github.rozd.ane.core.queue.tasks
{
import flash.external.ExtensionContext;

public class ContactFillDatesTask extends AbstractTask
{
    public function ContactFillDatesTask(context:ExtensionContext, contact:Object)
    {
        super();

        this.context = context;
        this.contact = contact;
    }

    private var context:ExtensionContext;
    private var contact:Object;

    override public function perform(result:Function, error:Function = null):void
    {
        super.perform(result, error);

        try
        {
            if (!isNaN(contact.birthday))
                contact.birthday = new Date(contact.birthday);

            if (!isNaN(contact.creationDate))
                contact.creationDate = new Date(contact.creationDate);

            if (!isNaN(contact.modificationDate))
                contact.modificationDate = new Date(contact.modificationDate);

            notifyResult(null);
        }
        catch (error:Error)
        {
            notifyError(error.message);
        }
    }
}
}

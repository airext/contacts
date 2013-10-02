/**
 * Created with IntelliJ IDEA.
 * User: mobitile
 * Date: 10/2/13
 * Time: 3:29 PM
 * To change this template use File | Settings | File Templates.
 */
package
{
import flash.events.Event;
import flash.events.EventDispatcher;

public class Test extends EventDispatcher
{
    public function Test()
    {
        addEventListener(Event.ACTIVATE, activateHandler);
    }

    private function activateHandler(event:Event):void
    {
        trace(event);
    }
}
}

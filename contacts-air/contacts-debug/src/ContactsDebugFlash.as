/**
 * Created with IntelliJ IDEA.
 * User: mobitile
 * Date: 10/2/13
 * Time: 11:06 PM
 * To change this template use File | Settings | File Templates.
 */
package
{
import com.github.rozd.ane.Contacts;
import com.github.rozd.ane.core.Response;
import com.github.rozd.ane.data.Page;

import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.ErrorEvent;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.utils.getTimer;

import mx.charts.BubbleChart;

import skein.async.Queue;

import skein.async.Queue2;

public class ContactsDebugFlash extends Sprite
{
    public function ContactsDebugFlash()
    {
        super();

        mouseChildren = mouseEnabled = true;


        new PlainButton(this, "getContactsAsync", 0xFF0000, 0xFFFF00, {x: 100, y: 0, width : 200, height : 60},
            function clickHandler(event:MouseEvent):void
            {
                var t:Number = getTimer();

                var size:int = 10;

                var n:int = Contacts.getInstance().getContactCount();

                for (var i:int = 0; i < int(n / size); i+=size)
                {
                    Contacts.getInstance().getContactsAsync(new Page(i, size), null,
                        new Response(
                            function(data:Object):void
                            {
                                trace("getContactsAsync: elapsed:", getTimer() - t);
                            },
                            function(info:Object):void
                            {
                                trace("getContactsAsync:", info);
                            }
                        )
                    );
                }

            }
        );

        new PlainButton(this, "TEST", 0x234858, 0xF48E21, {x: 100, y: 80, width : 200, height : 60},
            function(event:MouseEvent):void
            {
                if (range == null)
                    range = new Page(0, 100);
                else
                    range = new Page(range.offset + 100, 100);

                var rangeArray:Array = range ? range.toArray() : [0, uint.MAX_VALUE];

                var offset:uint = rangeArray[0];
                var limit:uint = rangeArray[1] == uint.MAX_VALUE ? Contacts.getInstance().getContactCount() - offset : rangeArray[1];

                var contacts:Array = [];

                var functions:Array = [];

                var size:uint = 8;

                var n:uint = offset + limit;
                for (var i:uint = offset; i < n; i += size)
                {
                    var closure:Function = function(i:int):Function
                    {
                        var f:Function = function (callback:Function):void
                        {
                            try
                            {
                                var result:Array;

                                var t:Number = getTimer();

                                result = Contacts.getInstance().getContacts(new Page(i, size));

                                trace("Contacts.getContacts() takes:", getTimer() - t);

                                contacts = contacts.concat(result);

                                callback(true);
                            }
                            catch (error:Error)
                            {
                                callback(error);
                            }
                        }

                        return f;
                    };

                    functions.push(closure(i));
                }

                function errorHandler(event:ErrorEvent):void
                {
                    queue.removeEventListener(ErrorEvent.ERROR, errorHandler);
                    queue.removeEventListener(Event.COMPLETE, completeHandler);
                }

                function completeHandler(event:Event):void
                {
                    queue.removeEventListener(ErrorEvent.ERROR, errorHandler);
                    queue.removeEventListener(Event.COMPLETE, completeHandler);

                    trace(getTimer(), i, contacts);
                }

                var queue:Queue2 = new Queue2(functions);
                queue.addEventListener(ErrorEvent.ERROR, errorHandler);
                queue.addEventListener(Event.COMPLETE, completeHandler);

                var queueCompleteHandler:Function = function(event:Event):void
                {
                    getContactsAsyncQueue.removeEventListener(Event.COMPLETE, queueCompleteHandler);
                    getContactsAsyncQueue.removeEventListener(ErrorEvent.ERROR, queueErrorHandler);

                    getContactsAsyncQueue = null;
                }

                var queueErrorHandler:Function = function(event:ErrorEvent):void
                {
                    getContactsAsyncQueue.removeEventListener(Event.COMPLETE, queueCompleteHandler);
                    getContactsAsyncQueue.removeEventListener(ErrorEvent.ERROR, queueErrorHandler);

                    getContactsAsyncQueue = null;
                }

                if (getContactsAsyncQueue == null)
                {
                    getContactsAsyncQueue = new Queue2();
                    getContactsAsyncQueue.addEventListener(Event.COMPLETE, queueCompleteHandler);
                    getContactsAsyncQueue.addEventListener(ErrorEvent.ERROR, queueErrorHandler);
                }

                getContactsAsyncQueue.add([queue]);

                getContactsAsyncQueue.start();
            }
        );

        new PlainButton(this, "2", 0x234858, 0xF48E21, {x: 100, y: 160, width : 200, height : 60},
            function(event:MouseEvent):void
            {
                new Queue2();
            }
        );

        new PlainButton(this, "new Test()", 0x234858, 0xF48E21, {x: 100, y: 220, width : 200, height : 60},
            function(event:MouseEvent):void
            {
                new Test();
            }
        );

        addEventListener(Event.ADDED_TO_STAGE,
            function addedToStageHandler(event:Event):void
            {
                stage.scaleMode = StageScaleMode.NO_SCALE;
                stage.align = StageAlign.TOP_LEFT;
            }
        );
    }

    private var getContactsAsyncQueue:Queue2;

    private var range:Page;
}
}

import flash.display.DisplayObjectContainer;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;

class PlainButton extends Sprite
{
    function PlainButton(parent:DisplayObjectContainer=null, label:String="", color:uint=0, textColor:uint=0xFFFFFF, properties:Object=null, clickHandler:Function=null)
    {
        super();

        _label = label;
        _color = color;
        _props = properties;

        textDisplay = new TextField();
        textDisplay.defaultTextFormat = new TextFormat("_sans", 24, textColor, null, null, null, null, null, TextFormatAlign.CENTER);
        textDisplay.selectable = false;
        textDisplay.autoSize = "center";
        addChild(textDisplay);

        x = _props.x || 0;
        y = _props.y || 0;

        if (parent)
            parent.addChild(this);

        if (clickHandler != null)
            addEventListener(MouseEvent.CLICK, clickHandler);

        sizeInvalid = true;
        labelInvalid = true;

        addEventListener(Event.ENTER_FRAME, renderHandler);
    }

    private var sizeInvalid:Boolean;
    private var labelInvalid:Boolean;

    private var _label:String;
    private var _color:uint;
    private var _props:Object;

    private var textDisplay:TextField;

    private function renderHandler(event:Event):void
    {
        if (labelInvalid)
        {
            labelInvalid = false;

            textDisplay.text = _label;
        }

        if (sizeInvalid)
        {
            sizeInvalid = false;

            var w:Number = _props.width || 0;
            var h:Number = _props.height || 0;

            graphics.clear();
            graphics.beginFill(_color);
            graphics.drawRect(0, 0, w, h);
            graphics.endFill();

            textDisplay.x = 0;
            textDisplay.width = w;
            textDisplay.y = (h - textDisplay.height) / 2;
        }
    }
}

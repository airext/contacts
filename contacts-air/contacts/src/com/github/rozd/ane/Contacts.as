/**
 * Created with IntelliJ IDEA.
 * User: mobitile
 * Date: 9/10/13
 * Time: 3:24 PM
 * To change this template use File | Settings | File Templates.
 */
package com.github.rozd.ane
{
import flash.external.ExtensionContext;

public class Contacts
{
    public static const EXTENSION_ID:String = "com.github.rozd.ane.Contacts";

    private static var _context:ExtensionContext;

    private static function get context():ExtensionContext
    {
        if (_context == null)
        {
            _context = ExtensionContext.createExtensionContext(EXTENSION_ID, null);
        }

        return _context;
    }

    public static function isSupported():Boolean
    {
        return context != null;
    }

    private static var instance:Contacts;

    public static function getInstance():Contacts
    {
        if (instance == null)
        {
            instance = new Contacts();
        }

        return instance;
    }

    public function Contacts()
    {
        super();
    }

    public function isModified(since:Date):Boolean
    {
        return context.call("isModified", since.time);
    }
}
}

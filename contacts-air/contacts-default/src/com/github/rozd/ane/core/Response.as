/**
 * Created with IntelliJ IDEA.
 * User: mobitile
 * Date: 9/11/13
 * Time: 11:01 PM
 * To change this template use File | Settings | File Templates.
 */
package com.github.rozd.ane.core
{
public class Response
{
    public function Response(result:Function, error:Function)
    {
        super();

        _result = result;
        _error = error;
    }

    private var _result:Function;

    public function result(data:Object):void
    {
        if (_result != null)
            _result(data);
    }

    private var _error:Function;

    public function error(info:Object):void
    {
        if (_error != null)
            _error(info);
    }
}
}

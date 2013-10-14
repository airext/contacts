/**
 * Created with IntelliJ IDEA.
 * User: mobitile
 * Date: 9/11/13
 * Time: 1:54 PM
 * To change this template use File | Settings | File Templates.
 */
package com.github.rozd.ane.data
{
public class Range implements IRange
{
    public function Range(offset:uint=0, limit:uint=uint.MAX_VALUE)
    {
        super();

        this.offset = offset;
        this.limit = limit;
    }

    public var offset:uint;

    public var limit:uint;

    public function toArray():Array
    {
        return [offset, limit];
    }
}
}

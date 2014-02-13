/**
 * Created with IntelliJ IDEA.
 * User: mobitile
 * Date: 9/11/13
 * Time: 1:54 PM
 * To change this template use File | Settings | File Templates.
 */
package com.github.rozd.ane.data
{
public class Page implements IRange
{
    public function Page(offset:uint=0, size:uint=uint.MAX_VALUE)
    {
        super();

        this.offset = offset;
        this.size = size;
    }

    public var offset:uint;

    public var size:uint;

    public function toArray():Array
    {
        return [offset, size];
    }
}
}

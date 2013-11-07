/**
 * Created with IntelliJ IDEA.
 * User: mobitile
 * Date: 11/7/13
 * Time: 2:37 PM
 * To change this template use File | Settings | File Templates.
 */
package com.github.rozd.ane.data
{
public class Segment implements IRange
{
    public function Segment(start:uint=0, end:uint=uint.MAX_VALUE)
    {
        super();

        this.start = start;
        this.end = end;
    }

    public var start:uint;
    public var end:uint;

    public function toArray():Array
    {
        return [start, end - start];
    }
}
}

package {

import flash.display.Sprite;
import flash.text.TextField;

public class ContactsDebug extends Sprite
{
    public function ContactsDebug()
    {
        var textField:TextField = new TextField();
        textField.text = "Hello, World";
        addChild(textField);
    }
}
}

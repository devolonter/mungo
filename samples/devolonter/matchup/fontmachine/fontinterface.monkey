#rem
summary:This is the base font interface. Any font should implement this interface.
This is just an interface provided for easy integration with other font libraries.
The real bitmapfont objects used by this module are defined as [b]BitmapFont[/b] class objects.
[a ../.docs/bitmapfont.monkey.html]See the documentation here.[/a]
#end
Interface Font 
	'summary: This is the method to draw text on the canvas.
	Method DrawText(text:String, x#,y#) 

	'summary: This method returns the width in pixels (or graphic units) of the given string
	Method GetTxtWidth:Float(text:String) 

	'summary: This method returns the height in pixels (or graphic units) of the given string
	Method GetFontHeight:Int() 
End interface

#rem
footer:This FontMachine library is released under the MIT license:
[quote]Copyright (c) 2011 Manel Ibanez

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
[/quote]
#end
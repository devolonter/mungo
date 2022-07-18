#TEXT_FILES="*.txt|*.xml|*.json|*.fnt"

Strict

Import harmony.mojo

Import char
Import kernpair

Import config	'thanks to skn3 - you can find the latest version of this file in bananas/skn3/config folder.

'Bitmap font tools:
'PC: http://www.angelcode.com/products/bmfont/
'Mac/PC: http://slick.cokeandcode.com/demos/hiero.jnlp
'Mac (paid): http://www.bmglyph.com/ - cheapest
'Mac (paid): http://glyphdesigner.71squared.com/ - best

'For more information about AngelFont look here: http://www.monkeycoder.co.nz/Community/posts.php?topic=141


Class AngelFont
	Private
	
	Global _list:StringMap<AngelFont> = New StringMap<AngelFont>
	
	Field image:Image[] = New Image[1]	
'	Field blockSize:Int
	Field chars:Char[256]
	
'	Field kernPairs:StringMap<KernPair> = New StringMap<KernPair>
	Field kernPairs:IntMap<IntMap<KernPair>> = New IntMap<IntMap<KernPair>>
	Global firstKp:IntMap<KernPair>
	Global secondKp:KernPair
	
'	Field section:String
	Field iniText:String

	Field xOffset:Int
	Field yOffset:Int
	
	Field prevMouseDown:Bool = False

	Public
	Const ALIGN_LEFT:Int = 0
	Const ALIGN_CENTER:Int = 1
	Const ALIGN_RIGHT:Int = 2
	Const ALIGN_FULL:Int = 3
	
	Global current:AngelFont
	Global err:String
	
	Field name:String
	Field useKerning:Bool = True

	Field lineGap:Int = 5
	Field height:Int = 0
	Field heightOffset:Int = 9999
	Field scrollY:Int = 0
	
	Field italicSkew:Float = 0.25
	
	Method New(url:String="")
		If url <> ""
			Self.LoadFont(url)
			Self.name = url
			_list.Insert(url,Self)
		Endif
	End Method
	
	Method GetChars:Char[]()
		Return chars
	End

	Method LoadFont:Void(url:String)			'deprecated
		
		err = ""
		current = Self
		iniText = LoadString(url+".fnt")
		Local lines := iniText.Split(String.FromChar(10))
		Local data := New AngelFontData()
		
		For Local line := Eachin lines
			line = line.Trim()
			
			If (line.StartsWith("info") Or line.StartsWith("common"))
				If (Not data.info) data.info = New AngelFontInfo()
				Local info := line.Split(" ")
				
				For Local i := EachIn info
					Local key_value := i.Split("=")
					If (key_value.Length <> 2) Continue
					
					Select key_value[0]
						Case "face"
							data.info.face = key_value[1]
						Case "size"
							data.info.size = Int(key_value[1])
						Case "bold"
							data.info.bold = Bool(Int(key_value[1]))
						Case "italic"
							data.info.italic = Bool(Int(key_value[1]))
						Case "unicode"
							data.info.unicode = Bool(Int(key_value[1]))
						Case "smooth"
							data.info.smooth = Bool(Int(key_value[1]))
						Case "aa"
							data.info.aa = Bool(Int(key_value[1]))
						Case "charset"
							data.info.charset = key_value[1]
						Case "stretchH"
							data.info.stretchH = Int(key_value[1])
						Case "padding"
							Local p := key_value[1].Split(",")
							data.info.padding = New AngelFontPadding(Int(p[0]), Int(p[1]), Int(p[2]), Int(p[3]))
						Case "spacing"
							Local s := key_value[1].Split(",")
							data.info.spacing = New AngelFontSpacing(Int(s[0]), Int(s[1]))
						Case "lineHeight"
							height = Int(key_value[1])
						Case "base"
							data.info.base = Int(key_value[1])
						Case "scaleW"
							data.info.scaleW = Int(key_value[1])
						Case "scaleH"
							data.info.scaleH = Int(key_value[1])
						Case "packed"
							data.info.packed = Bool(Int(key_value[1]))
						Case "pages"
							If (image.Length < Int(key_value[1])) image = image.Resize(Int(key_value[1]))
					End
				Next
			ElseIf (line.StartsWith("page"))
				Local info := line.Split(" ")
				Local page:Int
				
				For Local i := EachIn info
					Local key_value := i.Split("=")
					If (key_value.Length <> 2) Continue
					
					Select key_value[0]
						Case "id"
							page = Int(key_value[1])
						Case "file"
							'image[page] = LoadImage(key_value[1])
							'TODO
					End
							
				Next
			ElseIf (line.StartsWith("char "))
				Local preInfo := line.Split(" ")
				Local info:String[11]
				Local i:Int
				
				For Local pi := Eachin preInfo
					If (Not pi) Continue
					info[i] = pi
					i += 1
				Next
				
				Local char := Int(info[1].Split("=")[1])
				
				chars[char] = New Char(
					Int(info[2].Split("=")[1]), Int(info[3].Split("=")[1]), Int(info[4].Split("=")[1]), Int(info[5].Split("=")[1]),
					Int(info[6].Split("=")[1]), Int(info[7].Split("=")[1]), Int(info[8].Split("=")[1]), Int(info[9].Split("=")[1]))
				Local ch := chars[char]
				If ch.yOffset < Self.heightOffset Self.heightOffset = ch.yOffset
					
			ElseIf (line.StartsWith("kerning "))
				Local info := line.Split(" ")
				
				Local first:Int = Int(info[1].Split("=")[1])
				firstKp = kernPairs.Get(first)
				If firstKp = Null
					kernPairs.Add(first, New IntMap<KernPair>)
					firstKp = kernPairs.Get(first)
				End
				
				Local second:Int = Int(info[2].Split("=")[1])
				
				firstKp.Add(second, New KernPair(first, second, Int(info[3].Split("=")[1])))
			End
		End

		image[0] = LoadImage(url+".png")
		SetImageFilter(image[0], TEXTURE_FILTER_NEAREST)
	End Method
	
	Method LoadFontXml:Void(url:String)
		current = Self
		
		iniText = LoadString(url+".fnt")
		Local lines:String[] = iniText.Split(String.FromChar(10))
		Local firstLine:String = lines[0]
'		Print "lines count="+lines.Length
		If firstLine.Contains("<?xml")
			Local lineList:List<String> = New List<String>(lines)
			lineList.RemoveFirst()
			lines = lineList.ToArray()
			iniText = "~n".Join(lines)
		End	
		
		
		Local pageCount:Int = 0
		
		Local config:= LoadConfig(iniText)
		
		Local nodes := config.FindNodesByPath("font/chars/char")
		For Local node := Eachin nodes
'			Print " -> "+node.GetName()+"(id="+node.GetAttribute("id")+" x="+node.GetAttribute("x")+" y="+node.GetAttribute("y")+" width="+node.GetAttribute("width")+" height="+node.GetAttribute("height")+" )"
			'Print " -> "+node.GetName()+" = "+node.GetValue()
			Local id:Int = Int(node.GetAttribute("id"))
			Local page:Int = Int(node.GetAttribute("page"))
			If pageCount < page pageCount = page
			chars[id] = New Char(Int(node.GetAttribute("x")), Int(node.GetAttribute("y")), Int(node.GetAttribute("width")), Int(node.GetAttribute("height")),  Int(node.GetAttribute("xoffset")),  Int(node.GetAttribute("yoffset")),  Int(node.GetAttribute("xadvance")), page)
			Local ch := chars[id]
			If ch.height > Self.height Self.height = ch.height
			If ch.yOffset < Self.heightOffset Self.heightOffset = ch.yOffset
		Next
		
		nodes = config.FindNodesByPath("font/kernings/kerning")
		For Local node := Eachin nodes
'			Local first:String = String.FromChar(Int(node.GetAttribute("first")))
'			Local second:String = String.FromChar(Int(node.GetAttribute("second")))
			Local first:Int = Int(node.GetAttribute("first")) '* 10000
			firstKp = kernPairs.Get(first)
			If firstKp = Null
				kernPairs.Add(first, New IntMap<KernPair>)
				firstKp = kernPairs.Get(first)
			End
			
			Local second:Int = Int(node.GetAttribute("second"))
			
'			kernPairs.Add(first+"_"+second, New KernPair(Int(first), Int(second), Int(node.GetAttribute("amount"))))
'			kernPairs.Add(first+second, New KernPair(first, second, Int(node.GetAttribute("amount"))))
			firstKp.Add(second, New KernPair(first, second, Int(node.GetAttribute("amount"))))
			'Print "adding kerning "+ String.FromChar(first)+" "+String.FromChar(second)
		End
		
		If pageCount = 0
			image[0] = LoadImage(url+".png")
			If image[0] = Null image[0] = LoadImage(url+"_0.png")
		Else
			For Local page:= 0 To pageCount
				If image.Length < page+1 image = image.Resize(page+1)
				image[page] = LoadImage(url+"_"+page+".png")
			End
		End					
'		Print iniText
	End
	
	
	Method Use:Void()
		current = Self
	End Method
	
	Function GetCurrent:AngelFont()
		Return current
	End
	
#Rem	
	Function Use:AngelFont(name:String)
		For Local af := Eachin _list
			If af.name = name
				current = af
				Return af
			End
		Next
		Return Null
	End
#End
	
	Method DrawItalic:Void(txt$,x#,y#)
		Local th#=TextHeight(txt)
		
		PushMatrix
			Transform 1,0,-italicSkew,1, x+th*italicSkew,y
			DrawText txt,0,0
		PopMatrix		
	End 
	
	Method DrawBold:Void(txt:String, x:Int, y:Int)
		DrawText(txt, x,y)
		DrawText(txt, x+1,y)
	End
	
	
	Method DrawText:Void(txt:String, x:Int, y:Int)
'		Local prevChar:String = ""
		Local prevChar:Int = 0
		xOffset = 0
		
		For Local i:= 0 Until txt.Length
			Local asc:Int = txt[i]
			Local ac:Char = chars[asc]
'			Local thisChar:String = String.FromChar(asc)
			Local thisChar:Int = asc
			If ac  <> Null
				If useKerning
					firstKp = kernPairs.Get(prevChar)
					If firstKp <> Null
						secondKp = firstKp.Get(thisChar)
						If secondKp <> Null
							xOffset += secondKp.amount
'							Print prevChar+","+thisChar
						End
					Endif
				Endif
				ac.Draw(image[ac.page], x+xOffset,y)
				xOffset += ac.xAdvance
				prevChar = thisChar
			Endif
		Next
	End Method
	
	Method DrawText:Void(txt:String, x:Int, y:Int, align:Int)
		xOffset = 0
		Select align
			Case ALIGN_CENTER
				DrawText(txt, x-(TextWidth(txt)/2), y)
			Case ALIGN_RIGHT
				DrawText(txt, x-TextWidth(txt), y)
			Case ALIGN_LEFT
				DrawText(txt,x,y)
		End Select
	End Method

	Method DrawHTML:Void(txt:String, x:Int, y:Int)
'		Local prevChar:String = ""
		Local prevChar:Int = 0
		xOffset = 0
		Local italic:Bool = False
		Local bold:Bool = False
		Local th#=TextHeight(txt)
		
		For Local i:= 0 Until txt.Length
			'err += txt[i..i+1]
			
			While txt[i..i+1] = "<"
				Select txt[i+1..i+3]
					Case "i>"
						italic = True
						i += 3
					Case "b>"
						bold = True
						i += 3
					Default
						Select txt[i+1..i+4]
							Case "/i>"
								italic = False
								i += 4
							Case "/b>"
								bold = False
								i += 4
							Default
								i += 1
						End
				End
				If i >= txt.Length
					Return
				End
			Wend
			Local asc:Int = txt[i]
			Local ac:Char = chars[asc]
'			Local thisChar:String = String.FromChar(asc)
			Local thisChar:Int = asc
			If ac  <> Null
				If useKerning
					firstKp = kernPairs.Get(prevChar)
					If firstKp <> Null
						secondKp = firstKp.Get(thisChar)
						If secondKp <> Null
							xOffset += secondKp.amount
'							Print prevChar+","+thisChar+"  "+String.FromChar(prevChar)+","+String.FromChar(thisChar)
						End							
					Endif
				Endif
				If italic = False
					ac.Draw(image[ac.page], x+xOffset,y)
					If bold
						ac.Draw(image[ac.page], x+xOffset+1,y)
					End
				Else
					PushMatrix
						Transform 1,0,-italicSkew,1, (x+xOffset)+th*italicSkew,y
						ac.Draw(image[ac.page], 0,0)
						If bold
							ac.Draw(image[ac.page], 1,0)
						Endif					
					PopMatrix		
				End	
				xOffset += ac.xAdvance
				prevChar = thisChar
			Endif
		Next
	End Method
	
	Method DrawHTML:Void(txt:String, x:Int, y:Int, align:Int)
		xOffset = 0
		Select align
			Case ALIGN_CENTER
				DrawHTML(txt,x-(TextWidth(StripHTML(txt))/2),y)
			Case ALIGN_RIGHT
				DrawHTML(txt,x-TextWidth(StripHTML(txt)),y)
			Case ALIGN_LEFT
				DrawHTML(txt,x,y)
		End Select
	End Method
	
	Function StripHTML:String(txt:String)
		Local plainText:String = txt.Replace("</","<")
		plainText = plainText.Replace("<b>","")
		Return plainText.Replace("<i>","")
	End

	Method TextWidth:Int(txt:String)
'		Local prevChar:String = ""
		Local prevChar:Int = 0
		Local width:Int = 0
		For Local i:= 0 Until txt.Length
			Local asc:Int = txt[i]
			Local ac:Char = chars[asc]
'			Local thisChar:String = String.FromChar(asc)
			Local thisChar:Int = asc
			If ac  <> Null
				If useKerning
					Local firstKp:= kernPairs.Get(prevChar)
					If firstKp <> Null
						Local secondKp:= firstKp.Get(thisChar)
						If secondKp <> Null
							xOffset += secondKp.amount
						End							
					Endif
				Endif
				'ch.Draw(image, x+xOffset,y)
				width += ac.xAdvance
				prevChar = thisChar
			Endif
		Next
		Return width
	End Method
	
	Method TextHeight:Int(txt:String)
		Local h:Int = 0
		For Local i:= 0 Until txt.Length
			Local asc:Int = txt[i]
			Local ac:Char = chars[asc]
			If ac.height+ac.yOffset > h h = ac.height+ac.yOffset
		Next
		Return h
	End

End Class

Class AngelFontData
	
	Field info:AngelFontInfo
	
End

Class AngelFontInfo
	
	Field face:String
	Field size:Int
	Field bold:Bool
	Field italic:Bool
	Field charset:String
	Field unicode:Bool
	Field stretchH:Int
	Field smooth:Bool
	Field aa:Bool
	Field padding:AngelFontPadding
	Field spacing:AngelFontSpacing
	
	Field base:Int
	Field scaleW:Int
	Field scaleH:Int
	Field packed:Bool
	
End

Class AngelFontPadding
	
	Field top:Int
	Field right:Int
	Field bottom:Int
	Field left:Int
	
	Method New(top:Int, right:Int, bottom:Int, left:Int)
		Self.top = top
		Self.right = right
		Self.bottom = bottom
		Self.left = left
	End
	
End

Class AngelFontSpacing
	
	Field x:Int
	Field y:Int
	
	Method New(x:Int, y:Int)
		Self.x = x
		Self.y = y
	End
	
End

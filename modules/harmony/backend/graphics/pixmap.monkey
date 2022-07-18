Strict

Friend harmony.backend.graphics.texture
Friend harmony.backend.graphics.framebuffer

Import texture
Import brl.databuffer

Private

Import gl
Import harmony.backend.utils

Public

Class Pixmap

	Method New(width:Int, height:Int, textureFormat:TextureFormat = TEXTURE_FORMAT_RGBA)
		Init(width, height, textureFormat)
	End Method

	Method Discard:Void()
		data.Discard()
	End Method
	
	Method GetPixel:Int(x:Int, y:Int)
		Local offset:Int = (y * width + x) * pixelSize
		If (offset < 0 Or offset >= data.Length) Return 0
		
		Return glPixmapGetPixel(data, offset, pixelFormat.format, pixelFormat.type)
	End Method
	
	Method GetPixel:Int(offset:Int)
		offset *= pixelSize
		If (offset < 0 Or offset >= data.Length) Return 0
		
		Return glPixmapGetPixel(data, offset, pixelFormat.format, pixelFormat.type)
	End Method
	
	Method GetPixel32:Int(x:Int, y:Int)
		Local offset:Int = (y * width + x) * pixelSize
		If (offset < 0 Or offset >= data.Length) Return 0
		Return glPixmapGetPixel32(data, offset, pixelFormat.format, pixelFormat.type)
	End Method
	
	Method GetPixel32:Int(offset:Int)
		offset *= pixelSize
		If (offset < 0 Or offset >= data.Length) Return 0
		
		Return glPixmapGetPixel32(data, offset, pixelFormat.format, pixelFormat.type)
	End Method
	
	Method GetPixels:Void(pixels:Int[], x:Int, y:Int, width:Int, height:Int, offset:Int = 0)
		If (width * height > pixels.Length()) Return
		If (x < 0 Or y < 0 Or x + width > Self.width Or y + height > Self.height) Return
		
		Local pixelsOffset:Int = (y * Self.width + x) * pixelSize
		If (pixelsOffset < 0 Or pixelsOffset > data.Length) Return
		
		glPixmapGetPixels(data, pixelsOffset, Self.width * pixelSize, width, height, pixelFormat.format, pixelFormat.type, pixels, offset)
	End Method
	
	Method GetPixels32:Void(pixels:Int[], x:Int, y:Int, width:Int, height:Int, offset:Int = 0)
		If (width * height > pixels.Length()) Return
		If (x < 0 Or y < 0 Or x + width > Self.width Or y + height > Self.height) Return
		
		Local pixelsOffset:Int = (y * Self.width + x) * pixelSize
		If (pixelsOffset < 0 Or pixelsOffset >= data.Length) Return
		
		glPixmapGetPixels32(data, pixelsOffset, Self.width * pixelSize, width, height, pixelFormat.format, pixelFormat.type, pixels, offset)
	End Method
	
	Method SetPixel:Void(color:Int, x:Int, y:Int)
		If (x < 0 Or y < 0 Or x + width > Self.width Or y + height > Self.height) Return
		
		Local pixelsOffset:Int = (y * Self.width + x) * pixelSize
		If (pixelsOffset < 0 Or pixelsOffset >= data.Length) Return
		
		glPixmapSetPixel(color, data, pixelsOffset, pixelFormat.format, pixelFormat.type)
	End Method
	
	Method SetPixel:Void(color:Int, offset:Int)
		offset *= pixelSize
		If (offset < 0 Or offset >= data.Length) Return
		
		glPixmapSetPixel(color, data, offset, pixelFormat.format, pixelFormat.type)
	End Method
	
	Method SetPixel32:Void(color:Int, x:Int, y:Int)
		Local offset:Int = (y * width + x) * pixelSize
		If (offset < 0 Or offset >= data.Length) Return

		glPixmapSetPixel32(color, data, offset, pixelFormat.format, pixelFormat.type)
	End Method
	
	Method SetPixel32:Void(color:Int, offset:Int)
		offset *= pixelSize
		If (offset < 0 Or offset >= data.Length) Return
		
		glPixmapSetPixel32(color, data, offset, pixelFormat.format, pixelFormat.type)
	End Method
	
	Method SetPixels:Void(pixels:Int[], x:Int, y:Int, width:Int, height:Int, offset:Int = 0)
		If (x < 0) Then
			width += x
			x = 0
		End If
		
		If (x + width > Self.width)
			width -= (x + width) - Self.width
		End If
		
		If (width <= 0 Or width > Self.width) Return
		
		If (y < 0) Then
			height += y
			y = 0
		End If
		
		If (y + height > Self.height)
			height -= (y + height) - Self.height
		End If
		
		If (height <= 0 Or height > Self.height) Return
		
		Local pixelsOffset:Int = (y * Self.width + x) * pixelSize
		If (pixelsOffset < 0 Or pixelsOffset >= data.Length) Return
		
		glPixmapSetPixels(pixels, offset, data, pixelsOffset, Self.width * pixelSize, width, height, pixelFormat.format, pixelFormat.type)
	End Method
	
	Method SetPixels32:Void(pixels:Int[], x:Int, y:Int, width:Int, height:Int, offset:Int = 0)
		If (x < 0) Then
			width += x
			x = 0
		End If
		
		If (x + width > Self.width)
			width -= (x + width) - Self.width
		End If
		
		If (width <= 0 Or width > Self.width) Return
		
		If (y < 0) Then
			height += y
			y = 0
		End If
		
		If (y + height > Self.height)
			height -= (y + height) - Self.height
		End If
		
		If (height <= 0 Or height > Self.height) Return
		
		Local pixelsOffset:Int = (y * Self.width + x) * pixelSize
		If (pixelsOffset < 0 Or pixelsOffset >= data.Length) Return
		
		glPixmapSetPixels32(pixels, offset, data, pixelsOffset, Self.width * pixelSize, width, height, pixelFormat.format, pixelFormat.type)
	End Method
	
	Method Copy:Void(src:Pixmap)
		If (src.pixelFormat <> pixelFormat) Return
		CopyDataBufferByteToByte(src.data, data, 0, 0, data.Length)
	End Method
	
	Method ClearPixels:Void(color:Int)
		glPixmapClearPixels(data, color, pixelFormat.format, pixelFormat.type)
	End Method
	
	Method ClearPixels32:Void(color:Int)
		glPixmapClearPixels32(data, color, pixelFormat.format, pixelFormat.type)
	End Method
	
	Method Width:Int() Property
		Return width
	End Method
	
	Method Height:Int() Property
		Return height
	End Method

	Private

	Field data:DataBuffer

	Field width:Int
	
	Field height:Int
	
	Field pixelFormat:TextureFormat
	
	Field pixelSize:Int

	Method Init:Void(width:Int, height:Int, textureFormat:TextureFormat, container:Bool = False)
		pixelSize = 4
		pixelFormat = textureFormat
	
		Select textureFormat.type
			Case GL_UNSIGNED_BYTE
				Select textureFormat.format
					Case GL_RGB
						pixelSize = 3
					Case GL_LUMINANCE_ALPHA
						pixelSize = 2
					Case GL_LUMINANCE, GL_ALPHA
						pixelSize = 1
				End Select
			
			Case GL_UNSIGNED_SHORT_4_4_4_4, GL_UNSIGNED_SHORT_5_5_5_1, GL_UNSIGNED_SHORT_5_6_5
				pixelSize = 2
		End Select
	
		If (Not container) data = New DataBuffer(width*height*pixelSize, True)
		
		If (data Or container)
			Self.width = width
			Self.height = height
		End If
	End Method

End Class

Class PixmapContainer Extends Pixmap
	
	Method New(width:Int, height:Int, textureFormat:TextureFormat = TEXTURE_FORMAT_RGBA)
		Init(width, height, textureFormat, True)
	End Method
	
	Method Discard:Void()
	End Method
	
	Method SetData:Void(data:DataBuffer)
		Self.data = data
	End
	
	Method GetPixel:Int(x:Int, y:Int)
		Return 0
	End Method
	
	Method GetPixel:Int(offset:Int)
		Return 0
	End Method
	
	Method GetPixel32:Int(x:Int, y:Int)
		Return 0
	End Method
	
	Method GetPixel32:Int(offset:Int)
		Return 0
	End Method
	
	Method GetPixels:Void(pixels:Int[], x:Int, y:Int, width:Int, height:Int, offset:Int = 0)
	End Method
	
	Method GetPixels32:Void(pixels:Int[], x:Int, y:Int, width:Int, height:Int, offset:Int = 0)
	End Method
		
	Method SetPixel:Void(color:Int, x:Int, y:Int)
	End Method
	
	Method SetPixel:Void(color:Int, offset:Int)
	End Method
	
	Method SetPixel32:Void(color:Int, x:Int, y:Int)
	End Method
		
	Method SetPixel32:Void(color:Int, offset:Int)
	End Method
	
	Method SetPixels:Void(pixels:Int[], x:Int, y:Int, width:Int, height:Int, offset:Int = 0)
	End Method
		
	Method SetPixels32:Void(pixels:Int[], x:Int, y:Int, width:Int, height:Int, offset:Int = 0)
	End
	
	Method Copy:Void(src:Pixmap)
	End Method
	
	Method ClearPixels:Void(color:Int)
	End Method
	
	Method ClearPixels32:Void(color:Int)
	End Method
	
End
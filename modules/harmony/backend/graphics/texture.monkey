Strict

Friend harmony.backend.graphics.pixmap
Friend harmony.backend.graphics.framebuffer

Import shaderprogram
Import pixmap
Import brl.databuffer

Private

Import gl
Import harmony.backend.utils
Import harmony.backend.restorable
Import mojo.data

Public

Interface IOnLoadTextureComplete
	
	Method OnLoadTextureComplete:Void(texture:Texture)

End Interface

Global TEXTURE_FORMAT_RGBA:TextureFormat = New TextureFormat(GL_RGBA, GL_UNSIGNED_BYTE)
Global TEXTURE_FORMAT_RGB:TextureFormat = New TextureFormat(GL_RGB, GL_UNSIGNED_BYTE)
Global TEXTURE_FORMAT_RGBA4444:TextureFormat = New TextureFormat(GL_RGBA, GL_UNSIGNED_SHORT_4_4_4_4)
Global TEXTURE_FORMAT_RGBA5551:TextureFormat = New TextureFormat(GL_RGBA, GL_UNSIGNED_SHORT_5_5_5_1)
Global TEXTURE_FORMAT_RGB565:TextureFormat = New TextureFormat(GL_RGB, GL_UNSIGNED_SHORT_5_6_5)
Global TEXTURE_FORMAT_LUMINANCE:TextureFormat = New TextureFormat(GL_LUMINANCE, GL_UNSIGNED_BYTE)
Global TEXTURE_FORMAT_LUMINANCE_ALPHA:TextureFormat = New TextureFormat(GL_LUMINANCE_ALPHA, GL_UNSIGNED_BYTE)
Global TEXTURE_FORMAT_ALPHA:TextureFormat = New TextureFormat(GL_ALPHA, GL_UNSIGNED_BYTE)

Const TEXTURE_FILTER_NEAREST:Int = GL_NEAREST
Const TEXTURE_FILTER_LINEAR:Int = GL_LINEAR
Const TEXTURE_FILTER_DISABLED:Int = GL_FALSE

Const TEXTURE_WRAP_CLAMP_TO_EDGE:Int = GL_CLAMP_TO_EDGE
Const TEXTURE_WRAP_REPEAT:Int = GL_REPEAT

Const TEXTURE_NPOT_SUPPORT_NONE:Int = 0
Const TEXTURE_NPOT_SUPPORT_PARTIAL:Int = 1
Const TEXTURE_NPOT_SUPPORT_FULL:Int = 2

Class TextureOptions
	
	Field wrap:Int = -1
	
	Field filter:Int = -1
	
	Field padded:Bool
	
	Field writeable:Bool
	
	Field readable:Bool
	
	Method New(options:TextureOptions)
		If (options)
			wrap = options.wrap
			filter = options.filter
			padded = options.padded
			writeable = options.writeable
			readable = options.readable
		End If
	End Method
	
End Class

Class ReadableTexture2D Extends Texture2D

	Method New(filename:String, listener:IOnLoadTextureComplete, textureFormat:TextureFormat = TEXTURE_FORMAT_RGBA, textureOptions:TextureOptions = Null)
		If (Not textureOptions) textureOptions = New TextureOptions()

		textureOptions.writeable = False
		textureOptions.readable = True
		CreateTextureFromFile(filename, False, listener, textureFormat, textureOptions)
	End Method

	Method New(twidth:Int, theight:Int, textureFormat:TextureFormat = TEXTURE_FORMAT_RGBA, textureOptions:TextureOptions = Null)
		If (Not textureOptions) textureOptions = New TextureOptions()

		textureOptions.writeable = False
		textureOptions.readable = True
		CreateEmptyTexture(GL_TEXTURE_2D, twidth, theight, False, textureFormat, textureOptions)
	End Method

End Class

Class WriteableTexture2D Extends Texture2D

	Method New(filename:String, listener:IOnLoadTextureComplete, textureFormat:TextureFormat = TEXTURE_FORMAT_RGBA, textureOptions:TextureOptions = Null)
		If (Not textureOptions) textureOptions = New TextureOptions()

		textureOptions.writeable = True
		textureOptions.readable = False
		CreateTextureFromFile(filename, False, listener, textureFormat, textureOptions)
	End Method

	Method New(twidth:Int, theight:Int, textureFormat:TextureFormat = TEXTURE_FORMAT_RGBA, textureOptions:TextureOptions = Null)
		If (Not textureOptions) textureOptions = New TextureOptions()

		textureOptions.writeable = True
		textureOptions.readable = False
		CreateEmptyTexture(GL_TEXTURE_2D, twidth, theight, False, textureFormat, textureOptions)
	End Method

End Class


Class DynamicTexture2D Extends Texture2D

	Method New(filename:String, listener:IOnLoadTextureComplete, textureFormat:TextureFormat = TEXTURE_FORMAT_RGBA, textureOptions:TextureOptions = Null)
		If (Not textureOptions) textureOptions = New TextureOptions()

		textureOptions.writeable = True
		textureOptions.readable = True
		CreateTextureFromFile(filename, False, listener, textureFormat, textureOptions)
	End Method

	Method New(twidth:Int, theight:Int, textureFormat:TextureFormat = TEXTURE_FORMAT_RGBA, textureOptions:TextureOptions = Null)
		If (Not textureOptions) textureOptions = New TextureOptions()

		textureOptions.writeable = True
		textureOptions.readable = True
		CreateEmptyTexture(GL_TEXTURE_2D, twidth, theight, False, textureFormat, textureOptions)
	End Method

End Class

Class StaticTexture2D Extends Texture2D

	Method New(filename:String, listener:IOnLoadTextureComplete, textureFormat:TextureFormat = TEXTURE_FORMAT_RGBA, textureOptions:TextureOptions = Null)
		If (Not textureOptions) textureOptions = New TextureOptions()

		textureOptions.writeable = False
		textureOptions.readable = False
		CreateTextureFromFile(filename, False, listener, textureFormat, textureOptions)
	End Method

	Method New(twidth:Int, theight:Int, textureFormat:TextureFormat = TEXTURE_FORMAT_RGBA, textureOptions:TextureOptions = Null)
		If (Not textureOptions) textureOptions = New TextureOptions()

		textureOptions.writeable = False
		textureOptions.readable = False
		CreateEmptyTexture(GL_TEXTURE_2D, twidth, theight, False, textureFormat, textureOptions)
	End Method

End Class

Class Texture2D Extends Texture

	Method New(filename:String, listener:IOnLoadTextureComplete, textureFormat:TextureFormat = TEXTURE_FORMAT_RGBA)
		CreateTextureFromFile(filename, False, listener, textureFormat)
	End Method
	
	Method New(filename:String, listener:IOnLoadTextureComplete, textureFormat:TextureFormat, textureOptions:TextureOptions)
		CreateTextureFromFile(filename, False, listener, textureFormat, textureOptions)
	End Method
	
	Method New(filename:String, useMipMap:Bool = False, listener:IOnLoadTextureComplete = Null, textureFormat:TextureFormat = TEXTURE_FORMAT_RGBA)
		CreateTextureFromFile(filename, useMipMap, listener, textureFormat)
	End Method
	
	Method New(filename:String, useMipMap:Bool = False, listener:IOnLoadTextureComplete = Null, textureFormat:TextureFormat, textureOptions:TextureOptions)
		CreateTextureFromFile(filename, useMipMap, listener, textureFormat, textureOptions)
	End Method
	
	Method New(twidth:Int, theight:Int, useMipMap:Bool = False, textureFormat:TextureFormat = TEXTURE_FORMAT_RGBA)
		CreateEmptyTexture(GL_TEXTURE_2D, twidth, theight, useMipMap, textureFormat)
	End Method
	
	Method New(twidth:Int, theight:Int, useMipMap:Bool = False, textureFormat:TextureFormat, textureOptions:TextureOptions)
		CreateEmptyTexture(GL_TEXTURE_2D, twidth, theight, useMipMap, textureFormat, textureOptions)
	End Method
	
Private

End Class

Class TextureWrap
	
	Method S:Int() Property
		Return s
	End Method
	
	Method T:Int() Property
		Return t
	End Method

Private
	Field s:Int = TEXTURE_WRAP_CLAMP_TO_EDGE
	
	Field t:Int = TEXTURE_WRAP_CLAMP_TO_EDGE

End Class

Class TextureFilter

	Method Mag:Int() Property
		Return mag
	End Method
	
	Method Min:Int() Property
		Return min
	End Method
	
	Method Mip:Int() Property
		Return mip
	End Method

Private
	Field mag:Int = TEXTURE_FILTER_LINEAR
	
	Field min:Int = TEXTURE_FILTER_LINEAR
	
	Field mip:Int = TEXTURE_FILTER_DISABLED

End Class

Class TextureGroup

	Method New()
		If (MAX_UNITS < 0) Then
			Local maxUnits:Int[1]
			glGetIntegerv(GL_MAX_COMBINED_TEXTURE_IMAGE_UNITS, maxUnits)
			
			MAX_UNITS = maxUnits[0] - 1
		End If
		
		textures = New Texture[MAX_UNITS]
	End Method
	
	Method Bind:Void()
		For Local i:Int = start To stop
			If (textures[i] And Not textures[i].isBound) textures[i].Bind(i)
		Next
	End Method
	
	Method Activate:Void(index:Int)
		If (index > MAX_UNITS) Return
	
		If (Texture.LastActiveIndex = index) Return
		If (Not textures[index]) Return
		
		glActiveTexture(GL_TEXTURE0+index)
		Texture.LastActiveIndex = index
	End Method
	
	Method AddTexture:Bool(index:Int, texture:Texture)
		If (index > MAX_UNITS) Return False		
		If (Not texture.isBound Or texture.index <> index) texture.Bind(index)
		
		textures[index] = texture
		ValidateRange()
		
		Return True
	End Method
	
	Method RemoveTexture:Void(index:Int = 0)
		If (index > MAX_UNITS) Return
		textures[index] = Null
		
		ValidateRange()
	End Method
	
	Method MaxLayers:Int() Property
		Return MAX_UNITS
	End Method

Private

	Field textures:Texture[]
	
	Field start:Int
	
	Field stop:Int

	Global MAX_UNITS:Int = -1
	
	Method ValidateRange:Void()
		start = MAX_UNITS
		stop = 0
	
		For Local i:Int = 0 Until MAX_UNITS
			If (textures[i]) Then
				start = Min(i, start)
				stop = Max(i, stop)
			End If
		Next
	End Method

End Class

Class Texture Implements RestorableResource

	Function NearestPOT:Int(value:Int)		
		Local i:Int = 1
		
		value -= 1
		While (i < 32)
			value = value | value Shr i
			i Shl= 1
		Wend
		
		Return value + 1
	End Function
	
	Function NPOTSupport:Int()
#If TARGET = "html5"
		Return TEXTURE_NPOT_SUPPORT_PARTIAL
#ElseIf TARGET = "ios" Or TARGET = "android"
		'note: TODO check extension
		Return TEXTURE_NPOT_SUPPORT_PARTIAL
#Else
		'note: TODO check extension?
		Return TEXTURE_NPOT_SUPPORT_FULL
#End
	End Function
	
	Method New()
		'note: TODO Error
	End Method
	
	Method Discard:Void()
		Dispose()
		If (pixmap) pixmap.Discard()
		
		If (managed) Then
			RestorableResources.RemoveResource(Self)
			managed = False
		End If
	End Method
	
	Method Bind:Void()
		Bind(index)
	End Method
	
	Method Bind:Void(index:Int)		
		If (Not loaded) Return
	
		If (LastActiveIndex <> index) Then
			glActiveTexture(GL_TEXTURE0 + index)
			LastActiveIndex = index
		End If
		
		If (BoundedTextures[index] = Self) Return
		If (BoundedTextures[index]) BoundedTextures[index].isBound = False
		
		glBindTexture(target, handle)
		
		Self.index = index
		isBound = True
		
		LastActiveTexture = Self
		BoundedTextures[index] = Self
		
		UpdateTexture()
	End Method
	
	Method Unbind:Void()	
		If (Not isBound) Return
		
		If (LastActiveTexture = Self) Then
			glBindTexture(target, 0)
			LastActiveTexture = Null
		ElseIf (LastActiveTexture And LastActiveTexture.index <> index)
			glActiveTexture(GL_TEXTURE0 + index)
			glBindTexture(target, 0)
			glActiveTexture(GL_TEXTURE0 + LastActiveIndex)
			glBindTexture(LastActiveTexture.target, LastActiveTexture.handle)
		End If
				
		isBound = False
		BoundedTextures[index] = Null
		index = 0
	End Method
	
	Method Activate:Void()
		If isBound Then
			If (LastActiveIndex = index) Return
			
			glActiveTexture(GL_TEXTURE0 + index)
			LastActiveIndex = index
			
			Return
		End If
	
		Bind(index)		
	End Method
	
	Method Draw:Void(pixmap:Pixmap, x:Int, y:Int)
		If (pixmap.pixelFormat.format <> textureFormat.format) Return
	
		If (LastActiveTexture <> Self) Then
			Local prevTexture:Texture = LastActiveTexture
			
			Bind(index)
			glTexSubImage2D(target, 0, x, y, pixmap.width, pixmap.height, textureFormat.format, textureFormat.type, pixmap.data)
			Unbind()
			If (prevTexture) prevTexture.Bind(prevTexture.index)
		Else
			glTexSubImage2D(target, 0, x, y, pixmap.width, pixmap.height, textureFormat.format, textureFormat.type, pixmap.data)
		End If
	End Method

	Method Draw:Void(pixmap:Pixmap, x:Int, y:Int, sizex:Int, sizey:Int)
		If (pixmap.pixelFormat.format <> textureFormat.format) Return
	
		If (LastActiveTexture <> Self) Then
			Local prevTexture:Texture = LastActiveTexture
			
			Bind(index)
			DrawSubImage(pixmap, x, y, x, y, sizex, sizey)
			Unbind()
			If (prevTexture) prevTexture.Bind(prevTexture.index)
		Else
			DrawSubImage(pixmap, x, y, x, y, sizex, sizey)
		End If
	End Method
	
	Method Draw:Void(pixmap:Pixmap, x:Int, y:Int, srcx:Int, srcy:Int, srcw:Int, srch:Int)
		If (pixmap.pixelFormat.format <> textureFormat.format) Return
	
		If (LastActiveTexture <> Self) Then
			Local prevTexture:Texture = LastActiveTexture
			
			Bind(index)
			DrawSubImage(pixmap, x, y, srcx, srcy, srcw, srch)
			Unbind()
			If (prevTexture) prevTexture.Bind(prevTexture.index)
		Else
			DrawSubImage(pixmap, x, y, srcx, srcy, srcw, srch)
		End If
	End Method
	
	Method Draw:Void(texture:Texture2D, x:Int, y:Int)
		If (Not texture.loaded Or Not texture.pixmap) Return
		Draw(texture.pixmap, x, y)
	End Method
	
	Method Draw:Void(texture:Texture2D, x:Int, y:Int, sizex:Int, sizey:Int)
		If (Not texture.loaded Or Not texture.pixmap) Return
		Draw(texture.pixmap, x, y, sizex, sizey)
	End Method
	
	Method Draw:Void(texture:Texture2D, x:Int, y:Int, srcx:Int, srcy:Int, srcw:Int, srch:Int)
		If (Not texture.loaded Or Not texture.pixmap) Return
		Draw(texture.pixmap, x, y, srcx, srcy, srcw, srch)
	End Method
	
	Method Stream:Void(any:Object)
		If (LastActiveTexture <> Self) Then
			Local prevTexture:Texture = LastActiveTexture
			
			Bind(index)
			'glTexSubImage2D(target, 0, x, y, pixmap.width, pixmap.height, textureFormat.format, textureFormat.type, pixmap.data)
			Unbind()
			If (prevTexture) prevTexture.Bind(prevTexture.index)
		Else
			'glTexSubImage2D(target, 0, x, y, pixmap.width, pixmap.height, textureFormat.format, textureFormat.type, pixmap.data)
		End If
	End Method
	
	Method GetWrap:TextureWrap()
		Return wrap
	End Method
	
	Method SetWrap:Void(wrap:Int)
		If (Self.wrap.s <> wrap Or Self.wrap.t <> wrap)
			Self.wrap.s = wrap
			Self.wrap.t = wrap
			dirty |= DIRTY_WRAP
			UpdateTexture()
		End If
	End Method
	
	Method SetWrap:Void(s:Int, t:Int)
		If (wrap.s <> s Or wrap.t <> t)
			wrap.s = s
			wrap.t = t
			dirty |= DIRTY_WRAP
			UpdateTexture()
		End If
	End Method
	
	Method SetFilter:Void(filter:Int)
		If (Self.filter.mag <> filter Or Self.filter.min <> filter)
			Self.filter.mag = filter
			Self.filter.min = filter
			dirty |= DIRTY_FILTER
		End If
		
		UpdateTexture()
	End Method
	
	Method SetFilter:Void(mag:Int, min:Int, mip:Int = TEXTURE_FILTER_DISABLED)
		If (filter.mag <> mag Or filter.min <> min)
			filter.mag = mag
			filter.min = min
			dirty |= DIRTY_FILTER
		End If
		
		If (Not options.readable And Not options.writeable And filter.mip <> mip)
			filter.mip = mip
			dirty |= DIRTY_MIPMAP
		End If
		
		UpdateTexture()
	End Method
	
	Method SetPixel:Void(color:Int, x:Int, y:Int)
		If (Not options.writeable) Return
		
		pixmap.SetPixel(color, x, y)
		
		dirty |= DIRTY_PIXMAP
		UpdateTexture()
	End Method
	
	Method SetPixels:Void(pixels:Int[], x:Int, y:Int, width:Int, height:Int, offset:Int = 0)
		If (Not options.writeable) Return
		
		pixmap.SetPixels(pixels, x, y, width, height, offset)
		
		dirty |= DIRTY_PIXMAP
		UpdateTexture()
	End Method
	
	Method GetPixel:Int(x:Int, y:Int)
		If (Not options.readable) Return 0		
		Return pixmap.GetPixel(x, y)
	End Method
	
	Method GetPixels:Void(pixels:Int[], x:Int, y:Int, width:Int, height:Int, offset:Int = 0)
		If (Not options.readable) Return
		pixmap.GetPixels(pixels, x ,y, width, height, offset)
	End Method
	
	Method SetPixel32:Void(color:Int, x:Int, y:Int)
		If (Not options.writeable) Return
		
		pixmap.SetPixel32(color, x, y)
		
		dirty |= DIRTY_PIXMAP
		UpdateTexture()
	End Method
	
	Method SetPixels32:Void(pixels:Int[], x:Int, y:Int, width:Int, height:Int, offset:Int = 0)
		If (Not options.writeable) Return
		
		pixmap.SetPixels32(pixels, x, y, width, height, offset)
		
		dirty |= DIRTY_PIXMAP
		UpdateTexture()
	End Method
	
	Method GetPixel32:Int(x:Int, y:Int)
		If (Not options.readable) Return 0
		Return pixmap.GetPixel32(x, y)
	End Method
	
	Method GetPixels32:Void(pixels:Int[], x:Int, y:Int, width:Int, height:Int, offset:Int = 0)
		If (Not options.readable) Return
		pixmap.GetPixels32(pixels, x ,y, width, height, offset)
	End Method
	
	Method ClearPixels:Void(color:Int)
		If (Not options.writeable) Return
		
		pixmap.ClearPixels(color)
		
		dirty |= DIRTY_PIXMAP
		UpdateTexture()
	End Method
	
	Method ClearPixels32:Void(color:Int)
		If (Not options.writeable) Return
		
		pixmap.ClearPixels32(color)
		
		dirty |= DIRTY_PIXMAP
		UpdateTexture()
	End Method
	
	Method Resize:Void(width:Int, height:Int)
		If (width = Self.width And height = Self.height) Return
		
		Self.width = width
		Self.height = height
		realWidth = width
		realHeight = height
		
		If (options.padded) Then
			realWidth = NearestPOT(width)
			realHeight = NearestPOT(height)
		End If
		
		glTexImage2D(target, 0, textureFormat.format, realWidth, realHeight, 0, textureFormat.format, textureFormat.type, Null)
		Complete(filter.mip <> TEXTURE_FILTER_DISABLED)
	End Method
	
	Method IsPowerOfTwo:Bool()
		Return (((realWidth - 1) & realWidth) = 0) And (((realHeight - 1) & realHeight) = 0)
	End Method

	Method Width:Int() Property
		Return width
	End Method
	
	Method Height:Int() Property
		Return height
	End Method
	
	Method RealWidth:Int() Property
		Return realWidth
	End Method
	
	Method RealHeight:Int() Property
		Return realHeight
	End Method
	
	Method UScale:Float() Property
		Return uScale
	End Method
	
	Method VScale:Float() Property
		Return vScale
	End Method
	
	Method ID:Int() Property
		Return handle
	End Method
	
	Method InternalID:Int() Property
		Return internalId
	End Method
	
	Method Renderable:Bool() Property
		Return Not options.readable
	End Method
	
	Method Loaded:Bool() Property
		Return loaded
	End Method
	
	Method Name:String() Property
		Return name
	End Method

Private

	Const DIRTY_NONE:Int = 0
	Const DIRTY_WRAP:Int = 1
	Const DIRTY_FILTER:Int = 2
	Const DIRTY_MIPMAP:Int = 4
	Const DIRTY_PIXMAP:Int = 8
	Const DIRTY_ALL:Int = DIRTY_WRAP | DIRTY_FILTER | DIRTY_MIPMAP | DIRTY_PIXMAP

	Global LastActiveIndex:Int	
	Global LastActiveTexture:Texture
	Global BoundedTextures:Texture[]
	Global TexturesCounter:Int = 1
	
	Field handle:Int = 0
	Field internalId:Int = 0
	Field target:Int
	Field pixmap:Pixmap
	
	Field width:Int
	Field height:Int
	Field realWidth:Int
	Field realHeight:Int
	Field uScale:Float
	Field vScale:Float
	Field textureFormat:TextureFormat
	Field options:TextureOptions

	Field dirty:Int	
	Field isBound:Bool
	Field index:Int
	Field loaded:Bool
	
	Field wrap:TextureWrap
	Field filter:TextureFilter
	Field hasMipMap:Bool

	Field name:String	
	Field managed:Bool
	
	Method CreateTextureFromFile:Void(filename:String, useMipMap:Bool, listener:IOnLoadTextureComplete, textureFormat:TextureFormat, textureOptions:TextureOptions = Null)
		Init(GL_TEXTURE_2D, textureFormat, textureOptions)
		name = filename
		
		Local result:Int[]
		Local padded:Bool = False
		Local data:DataBuffer
		
		If (options) Then
			padded = options.padded
			
			If (options.readable) Then
				pixmap = New Pixmap(0, 0, textureFormat)
				If (pixmap)
					data = pixmap.data
					data.Discard()
				End If
			End If
		End If

#If TARGET = "html5"
		Local l:= New ImageLoadListener(Self, listener)
		result = l.textureInfo
		glTexUploadImage2D(FixDataPath(filename), handle, data, target, textureFormat.format, textureFormat.type, padded, l, result)
#Else
		result = New Int[4]
		glTexUploadImage2D(FixDataPath(filename), handle, data, target, textureFormat.format, textureFormat.type, padded, Null, result)
		loaded = True
#End		
		
		width = result[0]
		height = result[1]
		realWidth = result[2]
		realHeight = result[3]
		
		If (pixmap) Then
			pixmap.width = width
			pixmap.height = height
		End If
		
		'note: TODO OnLoadTextureFailed
		If (width = 0 Or height = 0) Return

		Complete(useMipMap)
		
#If TARGET <> "html5"			
		If (listener) listener.OnLoadTextureComplete(Self)
		Unbind()
#End
	End Method	
	
	Method CreateEmptyTexture:Void(target:Int, twidth:Int, theight:Int, useMipMap:Bool, textureFormat:TextureFormat, textureOptions:TextureOptions = Null)
		loaded = True
		Init(target, textureFormat, textureOptions)
		
		width = twidth
		realWidth = twidth
		height = theight
		realHeight = theight
		
		If (options.padded) Then
			realWidth = NearestPOT(width)
			realHeight = NearestPOT(height)
		End If
			
		If (options.readable Or options.writeable) Then
			pixmap = New Pixmap(width, height, textureFormat)
		End If
		
		glTexImage2D(target, 0, textureFormat.format, realWidth, realHeight, 0, textureFormat.format, textureFormat.type, Null)
		Complete(useMipMap)
	End Method
	
	Method Init:Void(target:Int, textureFormat:TextureFormat, textureOptions:TextureOptions = Null)
		If (Not managed) Then
			RestorableResources.AddResource(Self)
			managed = True
		End If
	
		index = 0	
		If (Not BoundedTextures) Then
			Local maxUnits:Int[1]
			glGetIntegerv(GL_MAX_COMBINED_TEXTURE_IMAGE_UNITS, maxUnits)			
			BoundedTextures = BoundedTextures.Resize(maxUnits[0])
		End If		
		
		If (Not Self.textureFormat) Self.textureFormat = New TextureFormat(textureFormat)
		If (Not options) Then
			If (textureOptions) Then
				options = New TextureOptions(textureOptions)
			Else
				options = New TextureOptions()
			End If
		End If
		
		If (Not wrap) wrap = New TextureWrap()
		If (Not filter) filter = New TextureFilter()		
		
		If (options) Then
			If (options.wrap <> -1) SetWrap(options.wrap)
			If (options.filter <> -1) SetFilter(options.filter)
		End If
	
		Self.target = target
		handle = glCreateTexture()
		internalId = TexturesCounter
		TexturesCounter += 1
		
		Bind()
	End Method
	
	Method Complete:Void(useMipMap:Bool)
		If (options) Then
			If (options.readable Or options.writeable) Then
				useMipMap = False
			End If
		Else
			options = New TextureOptions()
		End If
		
		If useMipMap
			SetFilter(filter.min, filter.mag, filter.min)
		End If
		
		uScale = width / Float(realWidth)
		vScale = height / Float(realHeight)
	
		Invalidate()
		UpdateTexture()
	End Method
	
	Method Dispose:Void()
		If (LastActiveTexture = Self) Then
			LastActiveTexture = Null
		End If
		
		If (BoundedTextures[index] = Self) Then
			BoundedTextures[index] = Null
		End If
	
		If handle
			glDeleteTexture(handle)
			handle = 0
			isBound = False
		Endif
	End Method
	
	Method DrawSubImage:Void(pixmap:Pixmap, x:Int, y:Int, srcx:Int, srcy:Int, srcw:Int, srch:Int)
		If (srcx = 0 And srcy = 0 And pixmap.width = srcw And pixmap.height = srch) Then
			glTexSubImage2D(target, 0, x, y, srcw, srch, textureFormat.format, textureFormat.type, pixmap.data)
		Else
			Local format:Int = textureFormat.format
			Local type:Int = textureFormat.type
			Local pitch:Int = pixmap.width * pixmap.pixelSize
			Local offset:Int = srcx * pixmap.pixelSize + srcy * pitch
			
			For Local iy:Int = 0 Until srch
				glTexSubImage2D(target, 0, x, y + iy, srcw, 1, format, type, offset + iy * pitch, pixmap.data)
			Next
		End If
	End Method
	
	Method UpdateTexture:Void()
		If LastActiveTexture <> Self Or Not dirty Return
		
		If (dirty & DIRTY_WRAP)
			glTexParameteri(target, GL_TEXTURE_WRAP_S, wrap.s)	
			glTexParameteri(target, GL_TEXTURE_WRAP_T, wrap.t)
		End If
		
		If (dirty & DIRTY_FILTER)
			glTexParameteri(target, GL_TEXTURE_MIN_FILTER, filter.min)
			glTexParameteri(target, GL_TEXTURE_MAG_FILTER, filter.mag)
		End If
		
		If (dirty & DIRTY_MIPMAP)
			If (filter.mip <> TEXTURE_FILTER_DISABLED)				
				If (filter.mip = TEXTURE_FILTER_NEAREST)
					glTexParameteri(target, GL_TEXTURE_MIN_FILTER, GL_NEAREST_MIPMAP_NEAREST)
				Else
					glTexParameteri(target, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_LINEAR)
				End If
				
				If Not hasMipMap
					glGenerateMipmap(target)
					hasMipMap = True
				End If
			Else
				glTexParameteri(target, GL_TEXTURE_MIN_FILTER, filter.min)
			End If
		End If
		
		If (pixmap And dirty & DIRTY_PIXMAP) Then
			glTexSubImage2D(target, 0, 0, 0, width, height, textureFormat.format, textureFormat.type, pixmap.data)
		End If
		
		dirty = DIRTY_NONE
	End Method
	
	Method Invalidate:Void()
		dirty |= DIRTY_ALL
	End Method
	
	Method Store:Void()
	End Method
	
	Method Restore:Void()
		Dispose()
		Invalidate()
		
		If (pixmap) Then
			Init(target, textureFormat, options)
			glTexImage2D(target, 0, textureFormat.format, realWidth, realHeight, 0, textureFormat.format, textureFormat.type, Null)
			Complete(filter.mip <> TEXTURE_FILTER_DISABLED)			
			Return
		End If
	
		If (name) Then
			CreateTextureFromFile(name, filter.mip <> TEXTURE_FILTER_DISABLED, Null, textureFormat, options)
		Else
			CreateEmptyTexture(target, width, height, filter.mip <> TEXTURE_FILTER_DISABLED, textureFormat, options)
		End If
	End Method
	
End Class

Class TextureFormat Final

	Method New()
		Error "TextureFormat is internal struct"
	End Method

Private

	Field format:Int
	Field type:Int
	
	Method New(format:Int, type:Int)
		Init(format, type)
	End Method
	
	Method New(f:TextureFormat)
		Init(f.format, f.type)
	End Method
	
	Method Init:Void(format:Int, type:Int)
		Self.format = format
		Self.type = type
	End Method

End Class

Private

#If TARGET = "html5"

Class ImageLoadListener Extends EventListener
	
	Field texture:Texture
	
	Field textureInfo:Int[4]
	
	Field listener:IOnLoadTextureComplete
	
	Method New(texture:Texture, listener:IOnLoadTextureComplete)
		Self.texture = texture
		Self.listener = listener
	End Method

	Method handleEvent:Int(event:Event)
		'double init
		texture.width = textureInfo[0]
		texture.height = textureInfo[1]
		texture.realWidth = textureInfo[2]
		texture.realHeight = textureInfo[3]
		texture.uScale = texture.width / Float(texture.realWidth)
		texture.vScale = texture.height / Float(texture.realHeight)
	
		texture.loaded = True	
		If (listener) listener.OnLoadTextureComplete(texture)	
		Return 0
	End Method

End Class

#End
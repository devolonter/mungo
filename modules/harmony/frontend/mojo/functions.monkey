
Private

Import graphicsdevice
Import shader
Import mojo.graphics
Import harmony.backend
Import mojo.data

Public

Const OpaqueBlend=-1
Const MultiplyBlend=2
Const ScreenBlend=3

Const NearestImageFilter:Int = TEXTURE_FILTER_NEAREST
Const LinearImageFilter:Int = TEXTURE_FILTER_LINEAR

Const ClampToEdgeImageWrap:Int = TEXTURE_WRAP_CLAMP_TO_EDGE
Const RepeatImageWrap:Int = TEXTURE_WRAP_REPEAT

Const RgbaImageFormat:Int = 0
Const RgbImageFormat:Int = 1
Const Rgba4444ImageFormat:Int = 2
Const Rgba5551ImageFormat:Int = 3
Const Rgb565ImageFormat:Int = 4
Const LuminanceImageFormat:Int = 5
Const LuminanceAlphaImageFormat:Int = 6
Const AlphaImageFormat:Int = 7

Function SuspendMojoRender:Void()
	device.Suspend()
End Function

Function ResumeMojoRender:Void()
	device.Resume()
End Function

Function FlushGraphicsDevice:Void()
	device.Flush()
End Function

Function SetRenderer:Void(renderer:Renderer)
	device.SetRenderer(renderer)
End Function

Function SetShader:Void(shader:Shader)
	device.SetShader(shader)
End Function

Function RestoreDefaultBuffers:Void()
	device.currentRenderer.GetVertexBuffer().Bind(Null)
End

Function SetRenderTarget:Void(image:Image)
	If (image) Then
		device.SetRenderTarget(image.surface)
	Else
		device.SetRenderTarget(Null)
	End If
End Function

Function HasRenderTarget:Bool()
	Return device.HasRenderTarget()
End Function

Function PushFilter:Void(filter:Filter)
	device.PushFilter(filter)
End Function

Function PushFilter:Void(filter:Stack<Filter>)
	device.PushFilter(filter)
End Function

Function PopFilter:Void()
	device.PopFilter()
End Function

Function CreateRenderTarget:Image(width,height,frameCount=1,flags=Image.DefaultFlags)
	Local surf:=device.CreateSurface( width*frameCount,height, True )
	If surf Return (New Image).Init( surf,frameCount,flags )
End Function

Function SetImageFilter:Void(image:Image, filter:Int)
	image.surface.texture.SetFilter(filter)
End Function

Function SetImageWrap:Void(image:Image, wrap:Int)
	image.surface.texture.SetWrap(wrap)
End Function

Function GetImageTexture:Texture2D(image:Image)
	Return image.surface.texture
End Function

Function GetImageSurface:Surface(image:Image)
	Return image.surface
End Function

Function LoadImageRgba:Image(path$,frameCount=1,flags=Image.DefaultFlags)
	Local surf:=device.LoadSurface( FixDataPath(path), TEXTURE_FORMAT_RGBA )
	If surf Return (New Image).Init( surf, frameCount, flags )
End Function

Function LoadImageRgb:Image(path$,frameCount=1,flags=Image.DefaultFlags)
	Local surf:=device.LoadSurface( FixDataPath(path), TEXTURE_FORMAT_RGB )
	If surf Return (New Image).Init( surf,frameCount,flags )
End Function

Function LoadImageRgba4444:Image(path$,frameCount=1,flags=Image.DefaultFlags)
	Local surf:=device.LoadSurface( FixDataPath(path), TEXTURE_FORMAT_RGBA4444 )
	If surf Return (New Image).Init( surf,frameCount,flags )
End Function

Function LoadImageRgba5551:Image(path$,frameCount=1,flags=Image.DefaultFlags)
	Local surf:=device.LoadSurface( FixDataPath(path), TEXTURE_FORMAT_RGBA5551 )
	If surf Return (New Image).Init( surf,frameCount,flags )
End Function

Function LoadImageRgb565:Image(path$,frameCount=1,flags=Image.DefaultFlags)
	Local surf:=device.LoadSurface( FixDataPath(path), TEXTURE_FORMAT_RGB565 )
	If surf Return (New Image).Init( surf,frameCount,flags )
End Function

Function LoadImageLuminance:Image(path$,frameCount=1,flags=Image.DefaultFlags)
	Local surf:=device.LoadSurface( FixDataPath(path), TEXTURE_FORMAT_LUMINANCE )
	If surf Return (New Image).Init( surf,frameCount,flags )
End Function

Function LoadImageLuminanceAlpha:Image(path$,frameCount=1,flags=Image.DefaultFlags)
	Local surf:=device.LoadSurface( FixDataPath(path), TEXTURE_FORMAT_LUMINANCE_ALPHA )
	If surf Return (New Image).Init( surf,frameCount,flags )
End Function

Function LoadImageAlpha:Image(path$,frameCount=1,flags=Image.DefaultFlags)
	Local surf:=device.LoadSurface( FixDataPath(path), TEXTURE_FORMAT_ALPHA )
	If surf Return (New Image).Init( surf,frameCount,flags )
End Function

Function LoadImageRgba:Image(path:String, frameWidth, frameHeight, frameCount, flags = Image.DefaultFlags)
	Local surf := device.LoadSurface( FixDataPath(path), TEXTURE_FORMAT_RGBA )
	If surf Return (New Image).Init( surf, 0, 0, frameWidth, frameHeight, frameCount, flags, Null, 0, 0, surf.Width, surf.Height )
End Function

Function LoadImageRgb:Image(path:String, frameWidth, frameHeight, frameCount, flags = Image.DefaultFlags)
	Local surf:=device.LoadSurface( FixDataPath(path), TEXTURE_FORMAT_RGB )
	If surf Return (New Image).Init( surf,0,0,frameWidth,frameHeight,frameCount,flags,Null,0,0,surf.Width,surf.Height )
End Function

Function LoadImageRgba4444:Image(path$,frameWidth,frameHeight,frameCount,flags=Image.DefaultFlags)
	Local surf:=device.LoadSurface( FixDataPath(path), TEXTURE_FORMAT_RGBA4444 )
	If surf Return (New Image).Init( surf,0,0,frameWidth,frameHeight,frameCount,flags,Null,0,0,surf.Width,surf.Height )
End Function

Function LoadImageRgba5551:Image(path$,frameWidth,frameHeight,frameCount,flags=Image.DefaultFlags)
	Local surf:=device.LoadSurface( FixDataPath(path), TEXTURE_FORMAT_RGBA5551 )
	If surf Return (New Image).Init( surf,0,0,frameWidth,frameHeight,frameCount,flags,Null,0,0,surf.Width,surf.Height )
End Function

Function LoadImageRgb565:Image(path$,frameWidth,frameHeight,frameCount,flags=Image.DefaultFlags)
	Local surf:=device.LoadSurface( FixDataPath(path), TEXTURE_FORMAT_RGB565 )
	If surf Return (New Image).Init( surf,0,0,frameWidth,frameHeight,frameCount,flags,Null,0,0,surf.Width,surf.Height )
End Function

Function LoadImageLuminance:Image(path$,frameWidth,frameHeight,frameCount,flags=Image.DefaultFlags)
	Local surf:=device.LoadSurface( FixDataPath(path), TEXTURE_FORMAT_LUMINANCE )
	If surf Return (New Image).Init( surf,0,0,frameWidth,frameHeight,frameCount,flags,Null,0,0,surf.Width,surf.Height )
End Function

Function LoadImageLuminanceAlpha:Image(path$,frameWidth,frameHeight,frameCount,flags=Image.DefaultFlags)
	Local surf:=device.LoadSurface( FixDataPath(path), TEXTURE_FORMAT_LUMINANCE_ALPHA )
	If surf Return (New Image).Init( surf,0,0,frameWidth,frameHeight,frameCount,flags,Null,0,0,surf.Width,surf.Height )
End Function

Function LoadImageAlpha:Image(path$,frameWidth,frameHeight,frameCount,flags=Image.DefaultFlags)
	Local surf:=device.LoadSurface( FixDataPath(path), TEXTURE_FORMAT_ALPHA )
	If surf Return (New Image).Init( surf,0,0,frameWidth,frameHeight,frameCount,flags,Null,0,0,surf.Width,surf.Height )
End Function

Function LoadImageFormat:Image(path$,format,frameCount=1,flags=Image.DefaultFlags)
	Select format	
		Case RgbImageFormat
			Return LoadImageRgb(path, frameCount, flags)		
		Case Rgba4444ImageFormat
			Return LoadImageRgba4444(path, frameCount, flags)		
		Case Rgba5551ImageFormat
			Return LoadImageRgba5551(path, frameCount, flags)		
		Case Rgb565ImageFormat
			Return LoadImageRgb565(path, frameCount, flags)		
		Case LuminanceAlphaImageFormat
			Return LoadImageLuminanceAlpha(path, frameCount, flags)		
		Case LuminanceImageFormat
			Return LoadImageLuminance(path, frameCount, flags)		
		Case AlphaImageFormat
			Return LoadImageAlpha(path, frameCount, flags)		
		Default
			Return LoadImageRgba(path, frameCount, flags)
	End Select
End Function

Function LoadImageFormat:Image(path$,format,frameWidth,frameHeight,frameCount,flags=Image.DefaultFlags)
	Select format
		Case RgbImageFormat
			Return LoadImageRgb(path, frameWidth, frameHeight, frameCount, flags)
		Case Rgba4444ImageFormat
			Return LoadImageRgba4444(path, frameWidth, frameHeight, frameCount, flags)
		Case Rgba5551ImageFormat
			Return LoadImageRgba5551(path, frameWidth, frameHeight, frameCount, flags)
		Case Rgb565ImageFormat
			Return LoadImageRgb565(path, frameWidth, frameHeight, frameCount, flags)
		Case LuminanceAlphaImageFormat
			Return LoadImageLuminanceAlpha(path, frameWidth, frameHeight, frameCount, flags)
		Case LuminanceImageFormat
			Return LoadImageLuminance(path, frameWidth, frameHeight, frameCount, flags)
		Case AlphaImageFormat
			Return LoadImageAlpha(path, frameWidth, frameHeight, frameCount, flags)
		Default
			Return LoadImageRgba(path, frameWidth, frameHeight, frameCount, flags)
	End Select
End Function

Function DrawImageCrop( image:Image, x:Float, y:Float, t_r:Float, t_sx:Float, t_sy:Float, frame = 0 )

#If CONFIG="debug"
	DebugRenderDevice
	If frame < 0 Or frame >= image.frames.Length Error "Invalid image frame"
#End

	Local f:Frame = image.frames[frame]

	context.Validate
	
	If image.flags & Image.FullFrame
		renderDevice.DrawSurfaceTransform image.surface, x-image.tx, y-image.ty, t_r, t_sx, t_sy
	Else
		renderDevice.DrawSurface2Transform image.surface, x-image.tx, y-image.ty, f.x, f.y, image.width, image.height, t_r, t_sx, t_sy
	Endif
End

Function DrawImageCrop( image:Image, x:Float, y:Float, rotation:Float, scaleX:Float, scaleY:Float, t_r:Float, t_sx:Float, t_sy:Float, frame = 0 )

#If CONFIG="debug"
	DebugRenderDevice
	If frame < 0 Or frame >= image.frames.Length Error "Invalid image frame"
#End

	Local f:Frame = image.frames[frame]

	PushMatrix

	Translate x, y
	Rotate rotation
	Scale scaleX, scaleY

	Translate -image.tx, -image.ty

	context.Validate
	
	If image.flags & Image.FullFrame
		renderDevice.DrawSurfaceTransform image.surface, 0, 0, t_r, t_sx, t_sy
	Else
		renderDevice.DrawSurface2Transform image.surface, 0, 0, f.x, f.y, image.width, image.height, t_r, t_sx, t_sy
	Endif

	PopMatrix
End

Function DrawImageCropRect( image:Image, x:Float, y:Float, srcX, srcY, srcWidth, srcHeight, t_r:Float, t_sx:Float, t_sy:Float, frame = 0 )

#If CONFIG="debug"
	DebugRenderDevice
	If frame < 0 Or frame >= image.frames.Length Error "Invalid image frame"
	If srcX < 0 Or srcY < 0 Or srcX+srcWidth > image.width Or srcY+srcHeight > image.height Error "Invalid image rectangle"
#End

	Local f:Frame = image.frames[frame]

	context.Validate
	
	renderDevice.DrawSurface2Transform image.surface, -image.tx+x, -image.ty+y, srcX+f.x, srcY+f.y, srcWidth, srcHeight, t_r, t_sx, t_sy
End

Function DrawImageCropRect(image:Image, x:Float, y:Float, srcX, srcY, srcWidth, srcHeight, rotation:Float, scaleX:Float, scaleY:Float, t_r:Float, t_sx:Float, t_sy:Float, frame = 0)
#If CONFIG="debug"
	DebugRenderDevice
	If frame < 0 Or frame >= image.frames.Length Error "Invalid image frame"
	If srcX < 0 Or srcY < 0 Or srcX+srcWidth > image.width Or srcY+srcHeight > image.height Error "Invalid image rectangle"
#End

	Local f:Frame = image.frames[frame]
	
	PushMatrix

	Translate x, y
	Rotate rotation
	Scale scaleX, scaleY
	Translate -image.tx,-image.ty

	context.Validate
	
	renderDevice.DrawSurface2Transform image.surface, 0, 0, srcX+f.x, srcY+f.y, srcWidth, srcHeight, t_r, t_sx, t_sy

	PopMatrix
End

Function GetSoundDuration:Int(sound:Sound)
	'Local b := sound.Buffer
	'If (Not b) Return -1
	Return Ceil(sound.Buffer.Duration*1000.0)
End
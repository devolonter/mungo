
Friend harmony.frontend.mojo.renderers
Friend harmony.frontend.mojo.functions
Friend harmony.frontend.mojo.shader
Friend harmony.frontend.mojo.filters
Friend harmony.frontend.mojo.video

Import renderers

Private

Import harmony.backend.graphics
Import harmony.backend.graphics.gl

Import mojo.data
Import utils

Public

Class GraphicsDevice Implements BatchStreamListener<Renderer>

	Method New()	
		renderers = New BatchStream<Renderer>(Self)		
		emptyRenderer = New EmptyRenderer()
		
		resized = True
	End Method
	
	Method Suspend:Void()
		If (suspended) Return		
		
		FinishRenderer()
		SetRenderer(emptyRenderer)
		
		blend = -1
		scissorX = 0
		scissorY = 0
		scissorWidth = 0
		scissorHeight = 0
		
		suspended = True
	End Method
	
	Method Resume:Void()
		If (Not suspended) Return
		suspended = False
		
		SetRenderer(Null)
		StartRenderer()
		
		If (blend >= 0) Then
			SetBlend(blend)
		End If
		
		If (scissorWidth <> 0 Or scissorHeight <> 0) Then
			SetScissor(scissorX, scissorY, scissorWidth, scissorHeight)
		End If
	End Method
	
	Method Flush:Void()
		renderers.Flush()
	End Method
	
	Method PushFilter:Void(filter:Filter)
		If (Not filterManager) filterManager = New FilterManager()
		FilterArray[0] = filter
		filterManager.PushFilter(Self, FilterArray)
	End Method
	
	Method PushFilter:Void(filters:Stack<Filter>)
		If (Not filterManager) filterManager = New FilterManager()
		
		If (FilterArray.Length() < filters.Length) Then
			FilterArray = FilterArray.Resize(filters.Length)
		End If
		
		Local l:Int = filters.Length
		For Local i:Int = 0 Until l
			FilterArray[i] = filters.Get(i)
		Next
		
		filterManager.PushFilter(Self, FilterArray)
	End Method
	
	Method PopFilter:Void()
		filterManager.PopFilter(Self)
	End Method
	
	Method SetRenderer:Void(renderer:Renderer)
		ResetRenderers()
		
		If (renderer) Then
			If (renderer.Capabilities() & Renderer.DRAW_GRAPHICS) Then
				graphicsRenderer = renderer
			End If
			
			If (renderer.Capabilities() & Renderer.DRAW_SURFACE) Then
				surfaceRenderer = renderer
			End If
			
			If (renderer.Capabilities() & Renderer.DRAW_SURFACE_POLY) Then
				surfacedPolyRenderer = renderer
			End If
			
			CheckRenderers()
			
			If (currentRenderer <> renderer) Then				
				currentRenderer = renderer
				If (renderer.GetDefaultShader() Or renderer.Shader) StartRenderer()
			End If
		Else
			CheckRenderers()
			currentRenderer = Null
			StartRenderer()
		End If
	End Method
	
	Method SetShader:Void(shader:Shader)
		If Self.shader = shader Return
		
		If (currentRenderer) Then
			If (shader) Then
				shader.Apply(currentRenderer)
			ElseIf (Self.shader)
				Self.shader.Apply(Null)
			End If
			
			If (renderTarget) Then
				currentRenderer.SetDeviceProjection(0, 0, renderTarget.Width, renderTarget.Height, flip)
			Else
				currentRenderer.SetDeviceProjection(0, 0, width, height, flip)
			End If
			
			currentRenderer.dirty |= Renderer.DIRTY_DEVICE_PROJECTION
		End If
		
		Self.shader = shader
	End Method
	
	Method SetRenderTarget:Void(surface:Surface)
		If renderTarget = surface Return
		
		renderers.Flush()
				
		If (Not surface) Then
			RenderTargetBuffer.Finish()
			flip = Not flip
				
			If (currentRenderer) Then
				currentRenderer.SetDeviceProjection(0, 0, width, height, flip)
				currentRenderer.dirty |= Renderer.DIRTY_DEVICE_PROJECTION
			End If
			
			If (filterManager) filterManager.Validate()
		Else			
			If (Not RenderTargetBuffer) RenderTargetBuffer = New FrameBuffer()			
			If (renderTarget) RenderTargetBuffer.Finish()
			
			RenderTargetBuffer.SetColorTarget(surface.texture)
			RenderTargetBuffer.Start()
			flip = Not flip
			
			RenderTargetBuffer.Clear()
			
			If (currentRenderer) Then
				currentRenderer.SetDeviceProjection(0, 0, surface.Width, surface.Height, flip)
				currentRenderer.dirty |= Renderer.DIRTY_DEVICE_PROJECTION
			End If
		End If
		
		renderTarget = surface
	End Method
	
	Method HasRenderTarget:Bool()
		Return renderTarget <> Null
	End Method

	Method Width:Int()
		Return width
	End Method
	
	Method Height:Int()
		Return height
	End Method
	
	Method LoadSurface:Surface(path:String, format:TextureFormat = TEXTURE_FORMAT_RGBA)
		If (Not IsMojoAssetExists(FixDataPath(path))) Return Null
		
		Local surface:Surface = New Surface()
		LoadSurface__UNSAFE__(surface, path, format)
		Return surface
	End Method
	
	Method CreateSurface:Surface(width:Int, height:Int, isRenderTarget:Bool = False)
		Local surface:Surface = New Surface()
		
		Local options:TextureOptions = New TextureOptions(Surface.DefaultOptions)
		If (Texture.NPOTSupport() = TEXTURE_NPOT_SUPPORT_PARTIAL) options.padded = True
		
		If (Not isRenderTarget) Then
			surface.texture = New WriteableTexture2D(width, height, TEXTURE_FORMAT_RGBA, options)
		Else
			surface.texture = New StaticTexture2D(width, height, TEXTURE_FORMAT_RGBA, options)
		End If

		Return surface
	End Method
	
	Method WritePixels2:Int(surface:Surface, pixels:Int[], x:Int, y:Int, width:Int, height:Int, offset:Int, pitch:Int)
		If (pitch = width) Then
			surface.texture.SetPixels32(pixels, x, y, width, height, offset)
		Else
			surface.texture.Unbind()
			
			For Local i:Int = 0 Until height
				surface.texture.SetPixels32(pixels, x, y + i, width, 1, offset + i * pitch)
			Next
			
			surface.texture.Bind()
		End If
	End Method
	
	Method BeginRender:Int()
		CheckRenderers()
			
		If (width <> DeviceWidth() Or height <> DeviceHeight())
			width = DeviceWidth()
			height = DeviceHeight()
			
			SetViewport(0, 0, width, height)
			If (filterManager) filterManager.Resize()
			
			resized = True
		End If

		If (Not suspended) StartRenderer()
		If (Loading) Return 2

		Return 1
	End Method
	
	Method EndRender:Void()
		If (Not suspended) FinishRenderer()
		
		If (renderTarget) Then
			SetRenderTarget(Null)
		End If
		
		If (shader) Then
			SetShader(Null)
		End If
	End Method
	
	Method DiscardGraphics:Void()
	End Method
	
	Method Cls:Void(r:Float, g:Float, b:Float)
		currentRenderer.Clear()
		If (suspended) Return
	
		SetClearColor(r / 255.0, g / 255.0, b / 255.0, 1.0)
		ClearScreen(CLEAR_MASK_COLOR)
	End Method
	
	Method SetAlpha:Void(alpha:Float)
		currentRenderer.SetAlpha(alpha)
	End Method
	
	Method SetColor:Void(r:Float, g:Float, b:Float)
		currentRenderer.SetColor(r, g, b)
	End Method
	
	Method SetMatrix:Void(ix:Float, iy:Float, jx:Float, jy:Float, tx:Float, ty:Float)
		currentRenderer.SetMatrix(ix, iy, jx, jy, tx, ty)
	End Method
	
	Method SetScissor:Void(x:Int, y:Int, width:Int, height:Int)
		If (suspended) Then
			scissorX = x
			scissorY = y
			scissorWidth = width
			scissorHeight = height
			Return
		End If
	
		If x <> 0 Or y <> 0 Or width <> Self.width Or height <> Self.height
			currentRenderer.EnableScissor()
			currentRenderer.SetScissor(x, Self.height - y - height, width, height)
		Else
			currentRenderer.DisableScissor()
		End If
	End Method
	
	Method SetBlend:Void(blend:Int)
		If (suspended) Then
			Self.blend = blend
			Return
		End If
	
		Select blend
			Case AlphaBlend
				currentRenderer.SetBlendFunc(BLEND_FACTOR_SRC_ALPHA, BLEND_FACTOR_ONE_MINUS_SRC_ALPHA)
		
			Case AdditiveBlend
				currentRenderer.SetBlendFunc(BLEND_FACTOR_SRC_ALPHA, BLEND_FACTOR_DST_ALPHA)
				
			Case MultiplyBlend
				currentRenderer.SetBlendFunc(BLEND_FACTOR_DST_COLOR, BLEND_FACTOR_ONE_MINUS_SRC_ALPHA)
				
			Case ScreenBlend
				currentRenderer.SetBlendFunc(BLEND_FACTOR_SRC_ALPHA, BLEND_FACTOR_ONE)
				
			Default
				currentRenderer.DisableBlending()
		End Select
	End Method
	
	Method DrawPoint:Void(x:Float, y:Float)
		If (currentRenderer <> graphicsRenderer) Then
			renderers.Start(graphicsRenderer)
			currentRenderer = graphicsRenderer
		End If
		
		currentRenderer.DrawPoint(x, y)
	End Method
	
	Method DrawRect:Void(x:Float, y:Float, w:Float, h:Float)
		If (currentRenderer <> graphicsRenderer) Then
			renderers.Start(graphicsRenderer)
			currentRenderer = graphicsRenderer
		End If
		
		currentRenderer.DrawRect(x, y, w, h)
	End Method
	
	Method DrawLine:Void(x1:Float, y1:Float, x2:Float, y2:Float)
		If (currentRenderer <> graphicsRenderer) Then
			renderers.Start(graphicsRenderer)
			currentRenderer = graphicsRenderer
		End If
		
		currentRenderer.DrawLine(x1, y1, x2, y2)
	End Method
	
	Method DrawOval:Void(x:Float, y:Float, w:Float, h:Float)
		If (currentRenderer <> graphicsRenderer) Then
			renderers.Start(graphicsRenderer)
			currentRenderer = graphicsRenderer
		End If
		
		currentRenderer.DrawOval(x, y, w, h)
	End Method
	
	Method DrawPoly:Void(verts:Float[])
		If (currentRenderer <> graphicsRenderer) Then
			renderers.Start(graphicsRenderer)
			currentRenderer = graphicsRenderer
		End If
		
		currentRenderer.DrawPoly(verts)
	End Method
	
	Method DrawPoly2:Void(verts:Float[], surface:Surface, srcx:Int, srcy:Int)
		If (currentRenderer <> surfacedPolyRenderer) Then
			renderers.Start(surfacedPolyRenderer)
			currentRenderer = surfacedPolyRenderer
		End If
		
		currentRenderer.DrawPoly(verts, surface, srcx, srcy)
	End Method
	
	Method DrawSurface:Void(surface:Surface, x:Float, y:Float)
		If (currentRenderer <> surfaceRenderer) Then
			renderers.Start(surfaceRenderer)
			currentRenderer = surfaceRenderer
		End If
		
		currentRenderer.DrawSurface(surface, x, y)
	End Method
	
	Method DrawSurface2:Void(surface:Surface, x:Float, y:Float, srcx:Int, srcy:Int, srcw:Int, srch:Int)
		If (currentRenderer <> surfaceRenderer) Then
			renderers.Start(surfaceRenderer)
			currentRenderer = surfaceRenderer
		End If
		
		currentRenderer.DrawSurface(surface, x, y, srcx, srcy, srcw, srch)
	End Method
	
	Method DrawSurfaceTransform:Void(surface:Surface, x:Float, y:Float, rotation:Float, scaleX:Float, scaleY:Float)
		If (currentRenderer <> surfaceRenderer) Then
			renderers.Start(surfaceRenderer)
			currentRenderer = surfaceRenderer
		End If
		
		currentRenderer.DrawSurfaceTransform(surface, x, y, rotation, scaleX, scaleY)
	End Method
	
	Method DrawSurface2Transform:Void(surface:Surface, x:Float, y:Float, srcx:Int, srcy:Int, srcw:Int, srch:Int, rotation:Float, scaleX:Float, scaleY:Float)
		If (currentRenderer <> surfaceRenderer) Then
			renderers.Start(surfaceRenderer)
			currentRenderer = surfaceRenderer
		End If
		
		currentRenderer.DrawSurfaceTransform(surface, x, y, srcx, srcy, srcw, srch, rotation, scaleX, scaleY)
	End Method
	
	Method ReadPixels:Void(pixels:Int[], x:Int, y:Int, width:Int, height:Int, offset:Int, pitch:Int)
		renderers.Flush()
		glReadPixelsFlipped32(x, Self.height - y - height, width, height, pixels, offset, pitch)
	End Method

	Method LoadSurface__UNSAFE__:Bool(surface:Surface, path:String, format:TextureFormat = TEXTURE_FORMAT_RGBA)		
		Loading += 1
		surface.texture = New StaticTexture2D(path, surface, format, Surface.DefaultOptions)
	End Method
	
Private

	Global RenderTargetBuffer:FrameBuffer
	
	Global FiltersBuffer:FrameBuffer
	Global FiltersSurface:Surface

	Global Matrix:Float[6]
	Global Colors:Int[3]
	Global Loading:Int
	
	Global DefaultGraphicsRenderer:Renderer
	Global DefaultSurfaceRenderer:Renderer
	Global DefaultSurfacedPolyRenderer:Renderer
	
	Global FilterArray:Filter[1]

	Field width:Int
	Field height:Int
	
	Field renderers:BatchStream<Renderer>
	
	Field currentRenderer:Renderer
	Field graphicsRenderer:Renderer
	Field surfaceRenderer:Renderer
	Field surfacedPolyRenderer:Renderer
	Field emptyRenderer:Renderer
	Field latestRenderer:Renderer
	
	Field shader:Shader	
	Field renderTarget:Surface
	
	Field filterManager:FilterManager
	
	Field suspended:Bool	
	Field resized:Bool
	Field flip:Bool
	
	Field blend:Int
	Field scissorX:Int, scissorY:Int, scissorWidth:Int, scissorHeight:Int
	
	Method OnBatchSwitch:Void(oldRenderer:Renderer, newRenderer:Renderer)
		If (oldRenderer.ignore Or newRenderer.ignore) Then
			currentRenderer = newRenderer
			Return
		End If
	
		oldRenderer.GetColor(Colors)
		newRenderer.SetColor(Colors[0], Colors[1], Colors[2])
		
		newRenderer.SetAlpha(oldRenderer.GetAlpha())
		
		oldRenderer.GetMatrix(Matrix)
		newRenderer.SetMatrix(Matrix[0], Matrix[1], Matrix[2], Matrix[3], Matrix[4], Matrix[5])
		
		If (shader) Then
			shader.Apply(newRenderer)
		ElseIf (newRenderer.GetDefaultShader() <> newRenderer.Shader) Then
			newRenderer.SetShader(newRenderer.GetDefaultShader())
		End If
		
		If (oldRenderer.dirty & Renderer.DIRTY_DEVICE_PROJECTION) Then
			If (renderTarget) Then
				newRenderer.SetDeviceProjection(0, 0, renderTarget.Width, renderTarget.Height, flip)
			Else
				newRenderer.SetDeviceProjection(0, 0, width, height, flip)
			End If
			
			oldRenderer.dirty |= Renderer.DIRTY_NONE
		End If

		currentRenderer = newRenderer
	End Method
	
	Method UpdateDeviceProjection:Void()	
		graphicsRenderer.SetDeviceProjection(0, 0, width, height, flip)
		surfaceRenderer.SetDeviceProjection(0, 0, width, height, flip)
		surfacedPolyRenderer.SetDeviceProjection(0, 0, width, height, flip)

		If (currentRenderer And currentRenderer <> graphicsRenderer And currentRenderer <> surfaceRenderer And currentRenderer <> surfacedPolyRenderer) Then
			currentRenderer.SetDeviceProjection(0, 0, width, height, flip)
		End If
	End Method
	
	Method CheckRenderers:Void()
		If (Not graphicsRenderer) Then
			If (Not DefaultGraphicsRenderer) Then
				DefaultGraphicsRenderer = New GraphicsRenderer(1024)
			End If
			
			graphicsRenderer = DefaultGraphicsRenderer
		End If
		
		If (Not surfaceRenderer) Then
			If (Not DefaultSurfaceRenderer) Then
				DefaultSurfaceRenderer = New SurfaceRenderer(1024)
			End If
			
			surfaceRenderer = DefaultSurfaceRenderer
		End If
		
		If (Not surfacedPolyRenderer) Then
			If (Not DefaultSurfacedPolyRenderer) Then
				DefaultSurfacedPolyRenderer = New SurfacedPolyRenderer(512)
			End If
			
			surfacedPolyRenderer = DefaultSurfacedPolyRenderer
		End If
	End Method
	
	Method ResetRenderers:Void()
		graphicsRenderer = Null
		surfaceRenderer = Null
		surfacedPolyRenderer = Null
	End Method
	
	Method StartRenderer:Void()
		If (Not currentRenderer) Then
			If (latestRenderer) Then
				currentRenderer = latestRenderer
			Else
				currentRenderer = graphicsRenderer
			End If
		End If
		
		If (resized) Then
			UpdateDeviceProjection()
			resized = False
		End If
		
		renderers.Start(currentRenderer)
	End Method
	
	Method FinishRenderer:Void()
		renderers.Finish()
		If (Not suspended) latestRenderer = currentRenderer
	End Method

End

Class Surface Implements IOnLoadTextureComplete

	Method New()
		If (Not DefaultOptions) Then
			DefaultOptions = New TextureOptions()
			
#If Not MOJO_IMAGE_FILTERING_ENABLED
			DefaultOptions.filter = TEXTURE_FILTER_NEAREST
#End
		End If
	End Method

	Method Discard:Void()
		texture.Discard()
	End Method

	Method Width:Int() Property
		Return texture.Width
	End Method
	
	Method Height:Int() Property
		Return texture.Height
	End Method
	
	Method Loaded:Bool() Property
		Return texture.Loaded
	End Method

	Method OnLoadTextureComplete:Void(texture:Texture)
		GraphicsDevice.Loading -= 1
	End Method
	
	Method Texture:Texture2D() Property
		Return texture
	End Method
	
	Method HandleX:Float()
		Return tx
	End
	
	Method HandleY:Float()
		Return ty
	End
	
	Method SetHandle( tx:Float, ty:Float )
		Self.tx = tx
		Self.ty = ty
	End
	
	Private

	Global DefaultOptions:TextureOptions
	Field texture:Texture2D
	Field tx:Float, ty:Float

End
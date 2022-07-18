Strict

Friend harmony.frontend.mojo.shader
Friend harmony.frontend.mojo.graphicsdevice

Import "filters/mf_invert.frag"

Import "filters/mf_sprite_mask.vert"
Import "filters/mf_sprite_mask.frag"

Import shader
Import graphicsdevice
Import mojo.app

Private

Import harmony.backend.graphics
Import renderers
Import brl.pool

Public

Class StaticFilter Extends Filter
	
	Method New()
		static = True
	End Method

End Class

Class Filter
	
	Method Name:String() Property Abstract
	
	Method VertexShader:String() Property Abstract
	Method FragmentShader:String() Property Abstract
	
	Method OnCreate:Void() Abstract
	
	Method OnApply:Void()
	End Method
	
	Method Shader:Shader() Property Final
		If (Not shader) Then
			emptyShader = New Shader()
			Return emptyShader
		End If
	
		Return shader
	End Method
	
Protected

	Field shader:Shader
	
Private
	Field emptyShader:Shader
	Field static:Bool
	
	Method Apply:Void(shader:Shader = Null) Final
		If (shader And shader <> Self.shader) Then
			If (Not static) Error "Non static filter can't be applied to shader"
			Self.shader = shader
			OnCreate()
		ElseIf (Not Self.shader)
			If (static) Then
				shader = New Shader()
				shader.PushFilter(Self)
				Return
			Else
				OnCreate()
				If (Not Self.shader) Error "Non static filters must create shaders in OnCreate"
				Self.shader = shader
			End If
		End If
		
		If (Self.emptyShader) Then
			For Local uniform := EachIn Self.emptyShader.uniforms
				Self.shader.uniforms.Set(uniform.Key, uniform.Value)
			Next
			
			Self.emptyShader = Null
		End If
		
		OnApply()
	End Method
	
	Method Detach:Void()
		shader = Null
	End Method

End Class

Class InvertFilter Extends StaticFilter Final

	Method Name:String() Property
		Return INVERT_SHADER_NAME
	End Method
	
	Method VertexShader:String() Property
		Return ""
	End Method
	
	Method FragmentShader:String() Property
		Return LoadString(INVERT_SHADER_NAME + ".frag")
	End Method
	
	Method OnCreate:Void()
		Invert = 1.0
	End Method
	
	Method Invert:Void(invert:Float) Property
		Shader.SetFloat(INVERT_UNIFORM_NAME, invert)
	End Method
	
	Method Invert:Float() Property
		Return Shader.GetFloat(INVERT_UNIFORM_NAME)
	End Method
	
Private

	Const INVERT_SHADER_NAME:String = "mf_invert"
	Const INVERT_UNIFORM_NAME:String = "u_" + INVERT_SHADER_NAME

	Field invert:Float
	
End Class

Class SpriteMaskFilter Extends TransformableFilter

	Method New()
		static = True
	End Method

	Method Name:String() Property
		Return SPRITE_MASK_NAME
	End Method
	
	Method VertexShader:String() Property
		Return LoadString(SPRITE_MASK_NAME + ".vert")
	End Method
	
	Method FragmentShader:String() Property
		Return LoadString(SPRITE_MASK_NAME + ".frag")
	End Method
	
	Method OnCreate:Void()
		static = True
		Alpha = 1
		Mask = Null
		ResetMatrix()
	End Method

	Method Alpha:Void(alpha:Float) Property
		Shader.SetFloat(SPRITE_MASK_ALPHA, alpha)
	End Method
	
	Method Alpha:Float() Property
		Return Shader.GetFloat(SPRITE_MASK_ALPHA)
	End Method
	
	Method Mask:Void(mask:Image) Property
		If (Not mask) Then
			If (Not EmptyMask) Then
				EmptyMask = CreateImage(1, 1)
				EmptyMask.WritePixels([$FFFFFFFF], 0, 0, 1, 1)
			End If
			
			mask = EmptyMask
			ResetMatrix()
		End If
		
		Shader.SetSampler2D(SPRITE_MASK_SAMPLER, mask)
	End Method
	
	Method Scale:Void(x:Float, y:Float)
		Super.Scale(1.0 / x, 1.0 / y)
	End Method
	
	Method Rotate:Void(angle:Float)
		Super.Rotate(-angle)
	End Method
	
	Method Translate:Void(x:Float, y:Float) Final
		Super.Translate(-x, -y)
	End Method
	
Private

	Const SPRITE_MASK_NAME:String = "mf_sprite_mask"
	Const SPRITE_MASK_ALPHA:String = "u_" + SPRITE_MASK_NAME + "_alpha"
	Const SPRITE_MASK_SAMPLER:String = "u_" + SPRITE_MASK_NAME + "_sampler"
	Const SPRITE_MASK_MATRIX:String = "u_" + SPRITE_MASK_NAME + "_matrix"
	
	Global EmptyMask:Image
	
	Method Matrix:String() Property
		Return SPRITE_MASK_MATRIX
	End Method

End Class

Private

Class TransformableFilter Extends Filter

	Method Matrix:String() Property Abstract
	
	Method New()
		mat3 = [1.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 1.0]
	End Method
	
	Method Scale:Void(x:Float, y:Float)
		Transform(x, 0, 0, y, 0, 0)
	End Method
	
	Method Rotate:Void(angle:Float)
		Transform(Cos(angle), -Sin(angle), Sin(angle), Cos(angle), 0, 0)
	End Method
	
	Method Translate:Void(x:Float, y:Float)
		Transform(1, 0, 0, 1, x, y)
	End Method

	Method Transform:Void(ix:Float, iy:Float, jx:Float, jy:Float, tx:Float, ty:Float) Final
		Local ix2:Float=ix*mat3[0]+iy*mat3[3]
		Local iy2:Float=ix*mat3[1]+iy*mat3[4]
		Local jx2:Float=jx*mat3[0]+jy*mat3[3]
		Local jy2:Float=jx*mat3[1]+jy*mat3[4]
		Local tx2:Float=tx*mat3[0]+ty*mat3[3]+mat3[6]
		Local ty2:Float=tx*mat3[1]+ty*mat3[4]+mat3[7]
		
		SetMatrix(ix2, iy2, jx2, jy2, tx2, ty2)
	End Method
	
	Method ResetMatrix:Void() Final
		SetMatrix(1, 0, 0, 1, 0, 0)
	End Method
	
	Method SetMatrix:Void(ix:Float, iy:Float, jx:Float, jy:Float, tx:Float, ty:Float) Final
		mat3[0] = ix
		mat3[1] = iy
		mat3[3] = jx
		mat3[4] = jy
		mat3[6] = tx
		mat3[7] = ty
		
		Shader.SetFloatMat3(Matrix, mat3)
	End Method
	
Private

	Field mat3:Float[]

End Class

Class FilterManager
	
	Method New()
		If (Not DataPool) Then
			DataPool = New Stack<FilterData>()
		End If
	
		filterStack = New Stack<FilterData>()
		filterStack.Push(New FilterData(Null, []))
		
		renderer = New FilterRenderer(1)
		
		renderer.SetMatrix(1, 0, 0, 1, 0, 0)
		renderer.SetAlpha(1)
	End Method
	
	Method Validate:Void()
		If (filterStack.Length <> 1) Then
			filterStack.Top().renderTarget.Start()
		End If
	End Method
	
	Method PushFilter:Void(device:GraphicsDevice, filters:Filter[])
		Local size:Int = filters.Length()
		Local data:FilterData = AllocateFilterData()
		
		data.renderTarget.Start()
		data.renderTarget.Clear()
		
		data.size = size
		
		If (data.filters.Length() < filters.Length()) Then
			data.filters = data.filters.Resize(size)
		End If
		
		For Local i:Int = 0 Until size
			data.filters[i] = filters[i]
		Next		
		
		filterStack.Push(data)
	End Method
	
	Method PopFilter:Void(device:GraphicsDevice)
		If (filterStack.Length = 1) Return
	
		Local data:FilterData = filterStack.Pop()
		Local prevData:FilterData = filterStack.Top()
		
		If (Not device.currentRenderer) Then
			FreeFilterData(data)
			Return
		End If
		
		Local oldRenderer:Renderer = device.currentRenderer
		Local blending:Int = device.blend
		Local scissor:Bool = device.currentRenderer.IsScissorEnabled()
		
		If (device.blend <> AlphaBlend) Then
			device.SetBlend(AlphaBlend)
		End If
		
		If (scissor) Then
			device.currentRenderer.DisableScissor()
		End If
		
		device.renderers.Start(renderer)		
		
		If (data.size = 1) Then
			data.renderTarget.Finish()		
			ApplyFilter(device, data.filters[0], data.surface, prevData.renderTarget)
		Else
			data.renderTarget.Finish()
		
			Local flip:FilterData = data
			Local flop:FilterData = AllocateFilterData()
			
			flop.renderTarget.Clear()
			
			Local l:Int = data.size - 1
			For Local i:Int = 0 Until l
				ApplyFilter(device, data.filters[i], flip.surface, flop.renderTarget)
				
				Local tmp := flip.surface
				flip.SetSurface(flop.surface)
				flop.SetSurface(tmp)
			Next
			
			ApplyFilter(device, data.filters[l], flip.surface, prevData.renderTarget)
			
			FreeFilterData(flop)
		End If
		
		device.renderers.Start(oldRenderer)
		
		If (device.blend <> AlphaBlend) Then
			device.SetBlend(blending)
		End If
		
		If (scissor) Then
			'note: TODO not sure that it will work
			device.currentRenderer.EnableScissor()
		End If
		
		FreeFilterData(data)
	End Method
	
	Method Resize:Void()
		Local l:Int = DataPool.Length
		Local data:FilterData[] = DataPool.Data
				
		For Local i:Int = 0 Until l
			data[i].ResizeSurface()
			
			Local filters:Filter[] = data[i].filters			
			For Local j:Int = 0 Until filters.Length()
				If (filters[j].shader) Then
					filters[j].shader.Apply(renderer)
					renderer.SetDeviceProjection(0, 0, DeviceWidth(), DeviceHeight(), True)
				End If
			Next
		Next
	End Method
	
Private

	Global DataPool:Stack<FilterData>
			
	Field filterStack:Stack<FilterData>
	Field renderer:FilterRenderer
	
	Method ApplyFilter:Void(device:GraphicsDevice, filter:Filter, in:Surface, out:FrameBuffer)
		If (out) Then
			out.Start()
		ElseIf (device.renderTarget)
			GraphicsDevice.RenderTargetBuffer.Start()
		End If
		
		If (Not filter.shader) Then
			filter.Apply(Null)
			filter.shader.Apply(renderer)
			renderer.SetDeviceProjection(0, 0, DeviceWidth(), DeviceHeight(), True)
		End If
			
		filter.shader.Apply(renderer)
		renderer.DrawSurface(in, 0, 0)
		renderer.Flush()
	End Method
	
	Method AllocateFilterData:FilterData()
		If DataPool.IsEmpty() Return New FilterData()
		Return DataPool.Pop()
	End Method
	
	Method FreeFilterData:Void(data:FilterData)
		DataPool.Push(data)
	End Method

End Class

Class FilterData

	Field renderTarget:FrameBuffer
	Field filters:Filter[]
	Field size:Int
	
	Method New()
		If (Not TextureOptions) Then
			TextureOptions = New TextureOptions(Surface.DefaultOptions)
			TextureOptions.padded = (Texture.NPOTSupport() = TEXTURE_NPOT_SUPPORT_PARTIAL)
		End If
	
		Self.renderTarget = New FrameBuffer()
		ResizeSurface()
	End Method
	
	Method New(renderTarget:FrameBuffer, filters:Filter[])
		Self.renderTarget = renderTarget
		Self.filters = filters
	End Method
	
	Method SetSurface:Void(surface:Surface)
		Self.surface = surface
		renderTarget.SetColorTarget(surface.texture)
	End Method
	
	Method ResizeSurface:Void()
		If (surface) Then
			surface.texture.Bind()
			surface.texture.Resize(DeviceWidth(), DeviceHeight())
		Else
			surface = New Surface()
			surface.texture = New StaticTexture2D(DeviceWidth(), DeviceHeight(), TEXTURE_FORMAT_RGBA, TextureOptions)
			Self.renderTarget.SetColorTarget(surface.texture)
		End If
	End Method
	
Private

	Global TextureOptions:TextureOptions

	Field surface:Surface
	
End Class

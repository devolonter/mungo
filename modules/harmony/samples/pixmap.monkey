
Import harmony.backend.graphics
Import harmony.mojo

#HTML5_CANVAS_WIDTH=640
#HTML5_CANVAS_HEIGHT=480

Class HarmonyApp Extends App Implements IOnLoadTextureComplete

	Field basicProgram:ShaderProgram

	Field brush:Texture2D
	
	Field canvas:Texture2D
	
	Field vertexBuffer:VertexBuffer

	Method OnCreate()
		SetUpdateRate(60)
		
		'our canvas
		Local options:= New TextureOptions()
		options.padded = True
		
		Local format:=TEXTURE_FORMAT_RGBA
		canvas = New DynamicTexture2D(DeviceWidth(), DeviceHeight(), TEXTURE_FORMAT_RGBA, options)
		canvas.Bind()
		
		Local w:Int = DeviceWidth() - 20, h = DeviceHeight() - 20
		
		'fill canvas
		Local pixels:Int[] = New Int[w * h]
		Local pixels2:Int[] = New Int[w * h]
		
		For Local i:Int = 0 Until pixels.Length()
			pixels[i] = $FF000000
		Next
		
		'Print pixels[0]
		
		canvas.ClearPixels($FF0000FF)
		canvas.SetPixels32(pixels, 10, 10, DeviceWidth() - 20, DeviceHeight() - 20)
		'canvas.GetPixels32(pixels2, 10, 10, DeviceWidth() - 20, DeviceHeight() - 20)
		
		'For Local i:Int = 0 Until pixels.Length()
			'If (pixels[i] <> pixels2[i]) Error "wrong value on index: " + i + ". Value is " + pixels2[i] + ", but expected is " + pixels[i]
		'Next
		
		'canvas.SetPixels32(pixels2, 10, 10, DeviceWidth() - 20, DeviceHeight() - 20)
		'canvas.GetPixels32(pixels2, 10, 10, DeviceWidth() - 20, DeviceHeight() - 20)
		'canvas.SetPixels32(pixels2, 10, 10, DeviceWidth() - 20, DeviceHeight() - 20)
		
		'Print canvas.GetPixel(100, 100)
		
		'create brush
		'brush = CreatePixmap(16, 16)
		'brush = New Int[256 * 256]
		brush = New ReadableTexture2D("mungo.png", Self, format)

		basicProgram = LoadShaderProgram("basic")
		basicProgram.Bind()
		basicProgram.SetUniformf("uProjection", DeviceWidth() / 2.0, DeviceHeight() / 2.0)

		Local verts:Float[] = [0.0, 0.0, 0.0, 0.0, Float(DeviceWidth()), 0.0, Float(DeviceWidth() / Float(canvas.RealWidth)), 0.0, Float(DeviceWidth()), Float(DeviceHeight()), Float(DeviceWidth() / Float(canvas.RealWidth)), Float(DeviceHeight() / Float(canvas.RealHeight)), 0.0, Float(DeviceHeight()), 0.0, Float(DeviceHeight() / Float(canvas.RealHeight))]
		
		vertexBuffer = New VertexBuffer(8, ["aVertexPosition", "aTextureCoord"], [VERTEX_ATTR_FLOAT2, VERTEX_ATTR_FLOAT2])
		vertexBuffer.SetVertices(verts)
		
		DisableMojoRender()
		EnableMode(MODE_BLEND)
		SetBlendFunc(BLEND_FUNC_ADD, BLEND_FACTOR_SRC_ALPHA, BLEND_FACTOR_ONE_MINUS_SRC_ALPHA)
	End Method
	
	Method OnRender()
		If (MouseDown())
			'canvas.SetPixels32(brush, MouseX(), MouseY(), 256, 256)
			canvas.Draw(brush, MouseX(), MouseY(), 64, 64, 128, 128)
		End If
		
		'canvas.SetPixel($FF0000FF, Rnd() * DeviceWidth(), Rnd * DeviceHeight())
	
		'clear
		SetClearColor(1, 1, 1, 1.0)
		ClearScreen(CLEAR_MASK_COLOR)
		
		'draw tiled bg	
		canvas.Bind()
		basicProgram.Bind()		
		vertexBuffer.Bind(basicProgram)
			
		DrawArrays(DRAW_MODE_TRIANGLE_FAN, 0, 4)
		canvas.Unbind()
	End Method
	
	Method OnLoadTextureComplete:Void(texture:Texture)
		'Texture2D(texture).GetPixels32(brush, 0, 0, 256, 256)
	End Method

End Class

Function Main()
	New HarmonyApp()
End Function

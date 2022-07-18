
Import harmony.backend.graphics
Import harmony.mojo

#HTML5_CANVAS_WIDTH=640
#HTML5_CANVAS_HEIGHT=480

Class HarmonyApp Extends App

	Field camera:Texture2D
	
	Field buffer:FrameBuffer
	
	Field brush:Pixmap
	
	Field canvas:Texture2D

	Method OnCreate()
		SetUpdateRate(60)		
		
		camera = New Texture2D(128, 128)
		
		buffer = New FrameBuffer()
		buffer.SetColorTarget(camera)
		
		brush = CreatePixmap(16, 16, PIXMAP_FORMAT_RGB)
		brush.Fill($00FF00)
		
		canvas = New Texture2D(256, 256, False, False, TEXTURE_FORMAT_RGB)		
		
		Local program:ShaderProgram = LoadShaderProgram("basic")
		program.Bind()
		program.SetUniformf("uProjection", DeviceWidth() / 2.0, DeviceHeight() / 2.0)
		
		Local vbo:VertexBuffer = New StaticVertexBuffer(4+4*4, ["aVertexPosition", "aTextureCoord"], [VERTEX_ATTR_FLOAT2, VERTEX_ATTR_FLOAT2])
		
		vbo.Bind(program)
		vbo.SetVertices(SetupVertices())
		
		DisableMojoRender()
		EnableMode(MODE_BLEND)
		SetBlendFunc(BLEND_FUNC_ADD, BLEND_FACTOR_SRC_ALPHA, BLEND_FACTOR_ONE_MINUS_SRC_ALPHA)
	End Method
	
	Method OnRender()
		If (MouseDown())
			Local l:Float = (DeviceWidth()-canvas.Width) * 0.5
			Local t:Float = (DeviceHeight()-canvas.Height) * 0.5
		
			If (MouseX() >= l And MouseX() <= l + canvas.Width And MouseY() >= t And MouseY() <= t + canvas.Height)
				canvas.Draw(brush, MouseX() - l, MouseY() - t)
			End If
		End If
	
		'clear
		SetClearColor(0, 0, 1, 1)
		ClearScreen(CLEAR_MASK_COLOR)
		
		'Render to texture
		buffer.Start()
			SetClearColor(0, 1, 1, 1)
			ClearScreen(CLEAR_MASK_COLOR)
		
			canvas.Bind()
			DrawArrays(DRAW_MODE_TRIANGLE_FAN, 0, 4)		
		buffer.Finish()
		
		DrawArrays(DRAW_MODE_TRIANGLE_FAN, 0, 4)
		
		camera.Bind()
		DrawArrays(DRAW_MODE_TRIANGLE_FAN, 4, 4)
		DrawArrays(DRAW_MODE_TRIANGLE_FAN, 8, 4)
		DrawArrays(DRAW_MODE_TRIANGLE_FAN, 12, 4)
		DrawArrays(DRAW_MODE_TRIANGLE_FAN, 16, 4)
	End Method
	
	Method SetupVertices:Float[]()
		Local vertices:Float[4*4+4*4*4]
		
		vertices[0] = (DeviceWidth()-canvas.Width) * 0.5; vertices[1] = (DeviceHeight()-canvas.Height) * 0.5;
		vertices[4] = vertices[0] + canvas.Width; vertices[5] = vertices[1];
		vertices[6] = 1
		vertices[8] = vertices[4]; vertices[9] = vertices[1] + canvas.Height;
		vertices[10] = 1; vertices[11] = 1
		vertices[12] = vertices[0]; vertices[13] = vertices[9]
		vertices[15] = 1
		
		vertices[19] = 1 'revert Y
		vertices[20] = camera.Width
		vertices[22] = 1; vertices[23] = 1
		vertices[24] = camera.Width; vertices[25] = camera.Height
		vertices[26] = 1
		vertices[29] = camera.Height
		
		vertices[33] = DeviceHeight() - camera.Height
		vertices[35] = 1
		vertices[36] = camera.Width; vertices[37] = vertices[33]
		vertices[38] = 1; vertices[39] = 1
		vertices[40] = camera.Width; vertices[41] = DeviceHeight()
		vertices[42] = 1
		vertices[45] = DeviceHeight()
		
		vertices[48] = DeviceWidth() - camera.Width
		vertices[51] = 1 'revert Y
		vertices[52] = DeviceWidth()
		vertices[54] = 1; vertices[55] = 1
		vertices[56] = DeviceWidth(); vertices[57] = camera.Height
		vertices[58] = 1
		vertices[60] = DeviceWidth() - camera.Width; vertices[61] = camera.Height
		
		vertices[64] = DeviceWidth() - camera.Width; vertices[65] = DeviceHeight() - camera.Height
		vertices[67] = 1 'revert Y
		vertices[68] = DeviceWidth(); vertices[69] = DeviceHeight() - camera.Height
		vertices[70] = 1; vertices[71] = 1
		vertices[72] = DeviceWidth(); vertices[73] = DeviceHeight()
		vertices[74] = 1
		vertices[76] = DeviceWidth() - camera.Width; vertices[77] = DeviceHeight()
		
		Return vertices
	End Method

End Class

Function Main()
	New HarmonyApp()
End Function
